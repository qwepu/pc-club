using System.Data;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace CyberClubManager;

public partial class ProfilePage : UserControl
{
    private const string FullNamePattern = @"^\S+(\s+\S+){2,}$";
    private const string EmailPattern = @"^[^@\s]+@[^@\s]+\.[^@\s]+$";

    private int secretClicks;
    private DateTime secretStart = DateTime.MinValue;

    public ProfilePage()
    {
        InitializeComponent();
        LoadData();
    }

    private void Grid_AutoGeneratingColumn(object sender, DataGridAutoGeneratingColumnEventArgs e)
    {
        GridHelper.Format(e);
    }

    private static decimal Number(string sql)
    {
        object? value = Database.Scalar(sql, ("u", CurrentUser.Id));
        return value == null ? 0 : Convert.ToDecimal(value);
    }

    private static string Initials(string fullName)
    {
        string[] parts = fullName.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        return string.Concat(parts.Take(2).Select(p => char.ToUpper(p[0])));
    }

    private void LoadData()
    {
        try
        {
            DataTable user = Database.Query("SELECT login, full_name, email FROM users WHERE id = @id", ("id", CurrentUser.Id));
            string fullName = user.Rows[0]["full_name"].ToString() ?? "";
            string login = user.Rows[0]["login"].ToString() ?? "";
            string email = user.Rows[0]["email"] == DBNull.Value ? "почта не указана" : user.Rows[0]["email"].ToString() ?? "";

            InitialsText.Text = Initials(fullName);
            NameText.Text = fullName;
            RoleText.Text = CurrentUser.RoleTitle;
            ContactText.Text = "Логин: " + login + "   |   " + email;

            decimal sessions = Number("SELECT COUNT(*) FROM game_sessions WHERE user_id = @u");
            decimal sessionsMoney = Number("SELECT COALESCE(SUM(cost), 0) FROM game_sessions WHERE user_id = @u");
            decimal orders = Number("SELECT COUNT(*) FROM orders WHERE user_id = @u");
            decimal ordersMoney = Number("SELECT COALESCE(SUM(oi.quantity * oi.price_at_order), 0) FROM orders o JOIN order_items oi ON oi.order_id = o.id WHERE o.user_id = @u AND o.status <> 'Cancelled'");
            object? computer = Database.Scalar(
                "SELECT c.name FROM game_sessions s JOIN computers c ON c.id = s.computer_id WHERE s.user_id = @u AND s.end_time IS NULL LIMIT 1",
                ("u", CurrentUser.Id));

            StatsPanel.Children.Clear();
            StatsPanel.Children.Add(Ui.StatCard("Сеансов", sessions.ToString("N0")));
            StatsPanel.Children.Add(Ui.StatCard("Потрачено на сеансы", sessionsMoney.ToString("N2")));
            StatsPanel.Children.Add(Ui.StatCard("Заказов", orders.ToString("N0")));
            StatsPanel.Children.Add(Ui.StatCard("Потрачено на заказы", ordersMoney.ToString("N2")));
            StatsPanel.Children.Add(Ui.StatCard("Сейчас за компьютером", computer == null ? "—" : computer.ToString() ?? "—"));

            SessionsGrid.ItemsSource = Database.Query(
                "SELECT c.name AS \"Компьютер\", t.name AS \"Тариф\", s.start_time AS \"Начало\", s.end_time AS \"Конец\", s.cost AS \"Стоимость\" FROM game_sessions s JOIN computers c ON c.id = s.computer_id JOIN tariffs t ON t.id = s.tariff_id WHERE s.user_id = @u ORDER BY s.start_time DESC LIMIT 5",
                ("u", CurrentUser.Id)).DefaultView;
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }

    private void ChangePassword_Click(object sender, RoutedEventArgs e)
    {
        ChangePasswordWindow window = new ChangePasswordWindow { Owner = Window.GetWindow(this) };
        window.ShowDialog();
    }

    private void EditProfile_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            DataTable data = Database.Query("SELECT full_name, email FROM users WHERE id = @id", ("id", CurrentUser.Id));
            string oldName = data.Rows[0]["full_name"].ToString() ?? "";
            string? oldEmail = data.Rows[0]["email"] == DBNull.Value ? null : data.Rows[0]["email"].ToString();

            var initial = new Dictionary<string, object?> { ["full_name"] = oldName, ["email"] = oldEmail };
            var fields = new List<FormField>
            {
                new FormField("full_name", "ФИО", FieldType.Text)
                {
                    Required = true,
                    MaxLength = 100,
                    Pattern = FullNamePattern,
                    PatternMessage = "Введите ФИО полностью: фамилия, имя и отчество через пробел."
                },
                new FormField("email", "Почта", FieldType.Text)
                {
                    MaxLength = 100,
                    Pattern = EmailPattern,
                    PatternMessage = "Почта должна быть в формате name@example.com."
                }
            };
            EditWindow window = new EditWindow("Мои данные", fields, initial, null) { Owner = Window.GetWindow(this) };
            if (window.ShowDialog() != true)
            {
                return;
            }

            string newName = (string)window.Values["full_name"]!;
            string? newEmail = window.Values["email"] as string;
            Database.Execute("UPDATE users SET full_name = @f, email = @e WHERE id = @id",
                ("f", newName), ("e", newEmail), ("id", CurrentUser.Id));

            var changes = new List<string>();
            if (newName != oldName)
            {
                changes.Add("ФИО: " + oldName + " → " + newName);
            }
            if (newEmail != oldEmail)
            {
                changes.Add("Почта: " + (oldEmail ?? "пусто") + " → " + (newEmail ?? "пусто"));
            }
            if (changes.Count > 0)
            {
                Audit.Write("UPDATE", "users", "Пользователь изменил свои данные. " + string.Join("; ", changes));
            }

            CurrentUser.SetFullName(newName);
            Application.Current.Windows.OfType<MainWindow>().FirstOrDefault()?.RefreshHeader();
            LoadData();
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }

    private void Secret_Click(object sender, MouseButtonEventArgs e)
    {
        if ((DateTime.Now - secretStart).TotalSeconds > 3)
        {
            secretClicks = 0;
            secretStart = DateTime.Now;
        }
        secretClicks++;
        if (secretClicks >= 5)
        {
            secretClicks = 0;
            GameWindow window = new GameWindow { Owner = Window.GetWindow(this) };
            window.ShowDialog();
        }
    }
}
