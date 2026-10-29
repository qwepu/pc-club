using System.Collections.ObjectModel;
using System.Data;
using System.Windows;

namespace CyberClubManager;

public class CartItem
{
    public int ProductId { get; set; }
    public string Name { get; set; } = "";
    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public decimal Total => Price * Quantity;
}

public partial class OrderCreateWindow : Window
{
    private readonly ObservableCollection<CartItem> cart = new();

    public OrderCreateWindow()
    {
        InitializeComponent();
        CartGrid.ItemsSource = cart;
        UpdateTotal();
        try
        {
            DataTable products = Database.Query(
                "SELECT id, name, category, price, quantity_in_stock FROM products WHERE is_available AND quantity_in_stock > 0 ORDER BY category, name");
            ProductsGrid.ItemsSource = products.DefaultView;
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }

    private void UpdateTotal()
    {
        TotalText.Text = "Итого: " + cart.Sum(c => c.Total).ToString("N2");
    }

    private void AddToCart_Click(object sender, RoutedEventArgs e)
    {
        if (ProductsGrid.SelectedItem is not DataRowView row)
        {
            MessageBox.Show("Выберите товар в списке слева.");
            return;
        }
        if (!int.TryParse(QtyBox.Text.Trim(), out int quantity) || quantity < 1)
        {
            MessageBox.Show("Количество должно быть целым числом не меньше 1.");
            return;
        }

        int productId = Convert.ToInt32(row["id"]);
        int stock = Convert.ToInt32(row["quantity_in_stock"]);
        CartItem? existing = cart.FirstOrDefault(c => c.ProductId == productId);
        int already = existing?.Quantity ?? 0;

        if (already + quantity > stock)
        {
            MessageBox.Show("На складе только " + stock + " шт. этого товара.");
            return;
        }

        if (existing != null)
        {
            existing.Quantity += quantity;
        }
        else
        {
            cart.Add(new CartItem
            {
                ProductId = productId,
                Name = row["name"].ToString() ?? "",
                Price = Convert.ToDecimal(row["price"]),
                Quantity = quantity
            });
        }
        CartGrid.Items.Refresh();
        UpdateTotal();
    }

    private void Remove_Click(object sender, RoutedEventArgs e)
    {
        if (CartGrid.SelectedItem is CartItem item)
        {
            cart.Remove(item);
            CartGrid.Items.Refresh();
            UpdateTotal();
        }
    }

    private void Place_Click(object sender, RoutedEventArgs e)
    {
        if (cart.Count == 0)
        {
            MessageBox.Show("Добавьте в заказ хотя бы один товар.");
            return;
        }
        try
        {
            var items = cart.Select(c => (c.ProductId, c.Quantity)).ToList();
            int orderId = OrderService.CreateOrder(CurrentUser.Id, CommentBox.Text.Trim(), items);
            MessageBox.Show("Заказ №" + orderId + " оформлен. Ожидайте, пока менеджер его примет.", "Готово", MessageBoxButton.OK, MessageBoxImage.Information);
            DialogResult = true;
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }
}
