using System.Windows;
using System.Windows.Controls;

namespace CyberClubManager;

public partial class DashboardPage : UserControl
{
    public DashboardPage()
    {
        InitializeComponent();
        LoadData();
    }

    private void Refresh_Click(object sender, RoutedEventArgs e)
    {
        LoadData();
    }

    private void Grid_AutoGeneratingColumn(object sender, DataGridAutoGeneratingColumnEventArgs e)
    {
        GridHelper.Format(e);
    }

    private static decimal Number(string sql)
    {
        object? value = Database.Scalar(sql);
        return value == null ? 0 : Convert.ToDecimal(value);
    }

    private void LoadData()
    {
        try
        {
            CardsPanel.Children.Clear();

            decimal free = Number("SELECT COUNT(*) FROM computers c WHERE c.status AND NOT EXISTS (SELECT 1 FROM game_sessions s WHERE s.computer_id = c.id AND s.end_time IS NULL)");
            decimal busy = Number("SELECT COUNT(DISTINCT computer_id) FROM game_sessions WHERE end_time IS NULL");
            decimal off = Number("SELECT COUNT(*) FROM computers WHERE NOT status");
            decimal newOrders = Number("SELECT COUNT(*) FROM orders WHERE status = 'New'");
            decimal sessionsMoney = Number("SELECT COALESCE(SUM(cost), 0) FROM game_sessions WHERE end_time::date = CURRENT_DATE");
            decimal ordersMoney = Number("SELECT COALESCE(SUM(oi.quantity * oi.price_at_order), 0) FROM orders o JOIN order_items oi ON oi.order_id = o.id WHERE o.created_at::date = CURRENT_DATE AND o.status <> 'Cancelled'");

            CardsPanel.Children.Add(Ui.StatCard("Свободных компьютеров", free.ToString("N0")));
            CardsPanel.Children.Add(Ui.StatCard("Заняты сейчас", busy.ToString("N0")));
            CardsPanel.Children.Add(Ui.StatCard("Недоступны", off.ToString("N0")));
            CardsPanel.Children.Add(Ui.StatCard("Новых заказов", newOrders.ToString("N0")));
            CardsPanel.Children.Add(Ui.StatCard("Выручка за сегодня: сеансы", sessionsMoney.ToString("N2")));
            CardsPanel.Children.Add(Ui.StatCard("Выручка за сегодня: заказы", ordersMoney.ToString("N2")));

            ActiveGrid.ItemsSource = Database.Query(
                "SELECT u.full_name AS \"Клиент\", c.name AS \"Компьютер\", t.name AS \"Тариф\", s.start_time AS \"Начало\" FROM game_sessions s JOIN users u ON u.id = s.user_id JOIN computers c ON c.id = s.computer_id JOIN tariffs t ON t.id = s.tariff_id WHERE s.end_time IS NULL ORDER BY s.start_time").DefaultView;

            LowStockGrid.ItemsSource = Database.Query(
                "SELECT name AS \"Товар\", category AS \"Категория\", quantity_in_stock AS \"Остаток\" FROM products WHERE is_available AND quantity_in_stock <= 5 ORDER BY quantity_in_stock, name LIMIT 10").DefaultView;
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }
}
