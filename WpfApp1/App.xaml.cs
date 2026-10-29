using System.Windows;

namespace CyberClubManager;

public partial class App : Application
{
    public App()
    {
        DispatcherUnhandledException += (s, e) =>
        {
            ErrorHelper.Show(e.Exception);
            e.Handled = true;
        };
    }

    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);
        try
        {
            Database.EnsureDemoAccounts();
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
            Shutdown();
            return;
        }
        new LoginWindow().Show();
    }
}
