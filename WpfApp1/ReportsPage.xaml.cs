using System.Data;
using System.Windows;
using System.Windows.Controls;
using Microsoft.Win32;

namespace CyberClubManager;

public partial class ReportsPage : UserControl
{
    private DataTable? current;
    private ReportDef? currentReport;

    public ReportsPage()
    {
        InitializeComponent();
        List<ReportDef> list = Reports.ForRole(CurrentUser.Role);
        ReportBox.ItemsSource = list;
        ReportBox.DisplayMemberPath = "Title";
        if (list.Count > 0)
        {
            ReportBox.SelectedIndex = 0;
        }
    }

    private void ReportBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (ReportBox.SelectedItem is not ReportDef report)
        {
            return;
        }
        try
        {
            CurrentUser.Require(report.Roles);
            current = Database.Query(report.Sql);
            currentReport = report;
            ReportTable.ItemsSource = current.DefaultView;
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }

    private void ReportTable_AutoGeneratingColumn(object sender, DataGridAutoGeneratingColumnEventArgs e)
    {
        GridHelper.Format(e);
    }

    private void Excel_Click(object sender, RoutedEventArgs e)
    {
        Export("Excel (*.xlsx)|*.xlsx", ".xlsx", (table, title, path) => ReportExporter.ToExcel(table, title, path));
    }

    private void Pdf_Click(object sender, RoutedEventArgs e)
    {
        Export("PDF (*.pdf)|*.pdf", ".pdf", (table, title, path) => ReportExporter.ToPdf(table, title, path));
    }

    private void Export(string filter, string extension, Action<DataTable, string, string> action)
    {
        if (current == null || currentReport == null)
        {
            MessageBox.Show("Сначала выберите отчёт.");
            return;
        }
        SaveFileDialog dialog = new SaveFileDialog
        {
            Filter = filter,
            FileName = "Отчёт_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + extension
        };
        if (dialog.ShowDialog() != true)
        {
            return;
        }
        try
        {
            action(current, currentReport.Title, dialog.FileName);
            Audit.Write("CREATE", "reports", "Сформирован отчёт «" + currentReport.Title + "» в формате " + extension.TrimStart('.').ToUpper());
            MessageBox.Show("Отчёт сохранён:\n" + dialog.FileName, "Готово", MessageBoxButton.OK, MessageBoxImage.Information);
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }
}
