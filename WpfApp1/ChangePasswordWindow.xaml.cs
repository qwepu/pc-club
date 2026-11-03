using System.Windows;

namespace CyberClubManager;

public partial class ChangePasswordWindow : Window
{
    public ChangePasswordWindow()
    {
        InitializeComponent();
    }

    private void Save_Click(object sender, RoutedEventArgs e)
    {
        string oldPassword = OldBox.Password;
        string newPassword = NewBox.Password;

        if (!Security.Verify(oldPassword, CurrentUser.PasswordHash))
        {
            ErrorText.Text = "Текущий пароль указан неверно.";
            return;
        }
        if (newPassword.Length < 6)
        {
            ErrorText.Text = "Новый пароль должен быть не короче 6 символов.";
            return;
        }
        if (newPassword != RepeatBox.Password)
        {
            ErrorText.Text = "Новые пароли не совпадают.";
            return;
        }
        if (newPassword == oldPassword)
        {
            ErrorText.Text = "Новый пароль должен отличаться от текущего.";
            return;
        }

        try
        {
            string hash = Security.HashPassword(newPassword);
            Database.Execute("UPDATE users SET password_hash = @h WHERE id = @id", ("h", hash), ("id", CurrentUser.Id));
            CurrentUser.SetPasswordHash(hash);
            Audit.Write("UPDATE", "users", "Пользователь сменил свой пароль");
            MessageBox.Show("Пароль изменён.", "Готово", MessageBoxButton.OK, MessageBoxImage.Information);
            Close();
        }
        catch (Exception ex)
        {
            ErrorText.Text = ErrorHelper.GetMessage(ex);
        }
    }
}
