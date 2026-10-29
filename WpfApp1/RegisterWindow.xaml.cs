using System.Text.RegularExpressions;
using System.Windows;

namespace CyberClubManager;

public partial class RegisterWindow : Window
{
    public RegisterWindow()
    {
        InitializeComponent();
    }

    private void Register_Click(object sender, RoutedEventArgs e)
    {
        string login = LoginBox.Text.Trim();
        string name = NameBox.Text.Trim();
        string email = EmailBox.Text.Trim();
        string password = PasswordInput.Password;
        string repeat = PasswordRepeat.Password;

        var errors = new List<string>();
        if (!Regex.IsMatch(login, "^[A-Za-z0-9_]{3,50}$"))
        {
            errors.Add("Логин: от 3 до 50 символов, только латинские буквы, цифры и _.");
        }
        if (name == "")
        {
            errors.Add("Введите ФИО.");
        }
        if (email != "" && !Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
        {
            errors.Add("Почта должна быть в формате name@example.com.");
        }
        if (password.Length < 6)
        {
            errors.Add("Пароль должен быть не короче 6 символов.");
        }
        if (password != repeat)
        {
            errors.Add("Пароли не совпадают.");
        }
        if (errors.Count > 0)
        {
            ErrorText.Text = string.Join("\n", errors);
            return;
        }

        try
        {
            object? exists = Database.Scalar("SELECT id FROM users WHERE login = @l", ("l", login));
            if (exists != null)
            {
                ErrorText.Text = "Этот логин уже занят. Выберите другой.";
                return;
            }

            object? emailValue = email == "" ? null : email;
            object? newId = Database.Scalar(
                "INSERT INTO users (login, password_hash, full_name, email, role_id) VALUES (@l, @p, @f, @e, (SELECT id FROM roles WHERE name = 'User')) RETURNING id",
                ("l", login), ("p", Security.HashPassword(password)), ("f", name), ("e", emailValue));

            Audit.Write("REGISTER", "users", "Зарегистрирован новый пользователь «" + login + "» (ФИО: " + name + ")", Convert.ToInt32(newId));
            MessageBox.Show("Регистрация прошла успешно. Теперь войдите в систему.", "Готово", MessageBoxButton.OK, MessageBoxImage.Information);
            Close();
        }
        catch (Exception ex)
        {
            ErrorText.Text = ErrorHelper.GetMessage(ex);
        }
    }
}
