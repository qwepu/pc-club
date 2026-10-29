using System.Data;
using System.Windows;

namespace CyberClubManager;

public partial class LoginWindow : Window
{
    public LoginWindow()
    {
        InitializeComponent();
        LoginBox.Focus();
    }

    private void Login_Click(object sender, RoutedEventArgs e)
    {
        ErrorText.Text = "";
        string login = LoginBox.Text.Trim();
        string password = PasswordInput.Password;

        if (login == "" || password == "")
        {
            ErrorText.Text = "Введите логин и пароль.";
            return;
        }

        try
        {
            DataTable dt = Database.Query(
                "SELECT u.id, u.login, u.password_hash, u.full_name, r.name AS role_name FROM users u JOIN roles r ON r.id = u.role_id WHERE u.login = @login",
                ("login", login));

            if (dt.Rows.Count == 0 || !Security.Verify(password, dt.Rows[0]["password_hash"].ToString() ?? ""))
            {
                ErrorText.Text = "Неверный логин или пароль.";
                return;
            }

            DataRow row = dt.Rows[0];
            CurrentUser.Set(
                Convert.ToInt32(row["id"]),
                row["login"].ToString() ?? "",
                row["full_name"].ToString() ?? "",
                row["role_name"].ToString() ?? "");
            Audit.Write("LOGIN", "users", "Вход в систему, роль: " + CurrentUser.RoleTitle);

            new MainWindow().Show();
            Close();
        }
        catch (Exception ex)
        {
            ErrorText.Text = ErrorHelper.GetMessage(ex);
        }
    }

    private void Register_Click(object sender, RoutedEventArgs e)
    {
        RegisterWindow window = new RegisterWindow { Owner = this };
        window.ShowDialog();
    }
}
