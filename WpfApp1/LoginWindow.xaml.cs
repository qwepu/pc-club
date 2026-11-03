using System.Data;
using System.Windows;

namespace CyberClubManager;

public partial class LoginWindow : Window
{
    private static readonly Dictionary<string, (int Fails, DateTime LockedUntil)> attempts = new();

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

        string key = login.ToLowerInvariant();
        if (attempts.TryGetValue(key, out var state) && state.LockedUntil > DateTime.Now)
        {
            int seconds = (int)Math.Ceiling((state.LockedUntil - DateTime.Now).TotalSeconds);
            ErrorText.Text = "Слишком много неверных попыток. Повторите через " + seconds + " сек.";
            return;
        }

        try
        {
            DataTable dt = Database.Query(
                "SELECT u.id, u.login, u.password_hash, u.full_name, r.name AS role_name FROM users u JOIN roles r ON r.id = u.role_id WHERE u.login = @login",
                ("login", login));

            if (dt.Rows.Count == 0 || !Security.Verify(password, dt.Rows[0]["password_hash"].ToString() ?? ""))
            {
                RegisterFail(key);
                ErrorText.Text = "Неверный логин или пароль.";
                return;
            }
            attempts.Remove(key);

            DataRow row = dt.Rows[0];
            CurrentUser.Set(
                Convert.ToInt32(row["id"]),
                row["login"].ToString() ?? "",
                row["full_name"].ToString() ?? "",
                row["role_name"].ToString() ?? "");
            CurrentUser.SetPasswordHash(row["password_hash"].ToString() ?? "");
            Audit.Write("LOGIN", "users", "Вход в систему, роль: " + CurrentUser.RoleTitle);

            new MainWindow().Show();
            Close();
        }
        catch (Exception ex)
        {
            ErrorText.Text = ErrorHelper.GetMessage(ex);
        }
    }

    private static void RegisterFail(string key)
    {
        int fails = attempts.TryGetValue(key, out var old) ? old.Fails + 1 : 1;
        DateTime until = DateTime.MinValue;
        if (fails >= 5)
        {
            until = DateTime.Now.AddMinutes(2);
            fails = 0;
        }
        attempts[key] = (fails, until);
    }

    private void Register_Click(object sender, RoutedEventArgs e)
    {
        RegisterWindow window = new RegisterWindow { Owner = this };
        window.ShowDialog();
    }
}
