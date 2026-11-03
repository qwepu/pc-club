using System.Windows;
using System.Windows.Controls;

namespace CyberClubManager;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        UserText.Text = CurrentUser.FullName;
        RoleText.Text = CurrentUser.RoleTitle;
        ThemeButton.Content = ThemeManager.IsDark ? "Светлая тема" : "Тёмная тема";

        if (!CurrentUser.IsUser)
        {
            AddTab("Главная", new DashboardPage());
        }
        if (CurrentUser.IsAdmin)
        {
            AddTab("Пользователи", new CrudPage(PageConfigs.Users()));
        }
        AddTab("Компьютеры", new CrudPage(PageConfigs.Computers(CurrentUser.IsAdmin)));
        AddTab("Тарифы", new CrudPage(PageConfigs.Tariffs(CurrentUser.IsAdmin)));
        AddTab("Товары", new CrudPage(PageConfigs.Products(!CurrentUser.IsUser)));
        AddTab(CurrentUser.IsUser ? "Мои заказы" : "Заказы", new CrudPage(PageConfigs.Orders()));
        AddTab(CurrentUser.IsUser ? "Мои сеансы" : "Сеансы", new CrudPage(PageConfigs.Sessions()));
        if (CurrentUser.IsAdmin)
        {
            AddTab("Журнал действий", new CrudPage(PageConfigs.AuditLog()));
        }
        if (!CurrentUser.IsUser)
        {
            AddTab("Отчёты", new ReportsPage());
        }
        AddTab("Личный кабинет", new ProfilePage());
    }

    private void Theme_Click(object sender, RoutedEventArgs e)
    {
        ThemeManager.Apply(!ThemeManager.IsDark);
        ThemeManager.Save();
        new MainWindow().Show();
        Close();
    }

    public void RefreshHeader()
    {
        UserText.Text = CurrentUser.FullName;
    }

    private void AddTab(string header, UserControl content)
    {
        Tabs.Items.Add(new TabItem { Header = header, Content = content });
    }

    private void ChangePassword_Click(object sender, RoutedEventArgs e)
    {
        ChangePasswordWindow window = new ChangePasswordWindow { Owner = this };
        window.ShowDialog();
    }

    private void Logout_Click(object sender, RoutedEventArgs e)
    {
        Audit.Write("LOGOUT", "users", "Выход из системы");
        CurrentUser.Clear();
        new LoginWindow().Show();
        Close();
    }
}
