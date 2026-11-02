using System.Data;
using ClosedXML.Excel;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace CyberClubManager;

public class ReportDef
{
    public string Title { get; }
    public string Sql { get; }
    public string[] Roles { get; }

    public ReportDef(string title, string sql, string[] roles)
    {
        Title = title;
        Sql = sql;
        Roles = roles;
    }
}

public static class Reports
{
    private static readonly string[] Staff = { "Administrator", "Manager" };
    private static readonly string[] AdminOnly = { "Administrator" };

    private static readonly List<ReportDef> All = new()
    {
        new ReportDef("Выручка по тарифам",
            "SELECT t.name AS \"Тариф\", COUNT(s.id) AS \"Сеансов\", COALESCE(SUM(s.cost), 0) AS \"Выручка\" FROM tariffs t JOIN game_sessions s ON s.tariff_id = t.id GROUP BY t.name ORDER BY \"Выручка\" DESC",
            Staff),
        new ReportDef("Выручка по месяцам",
            "SELECT TO_CHAR(DATE_TRUNC('month', start_time), 'YYYY-MM') AS \"Месяц\", COUNT(*) AS \"Сеансов\", SUM(cost) AS \"Выручка\" FROM game_sessions GROUP BY DATE_TRUNC('month', start_time) ORDER BY DATE_TRUNC('month', start_time)",
            Staff),
        new ReportDef("Загрузка компьютеров (топ-20)",
            "SELECT c.name AS \"Компьютер\", COUNT(s.id) AS \"Сеансов\", COALESCE(SUM(s.cost), 0) AS \"Выручка\" FROM computers c LEFT JOIN game_sessions s ON s.computer_id = c.id GROUP BY c.name ORDER BY \"Сеансов\" DESC, c.name LIMIT 20",
            Staff),
        new ReportDef("Продажи товаров (топ-20)",
            "SELECT p.name AS \"Товар\", p.category AS \"Категория\", SUM(oi.quantity) AS \"Продано\", SUM(oi.quantity * oi.price_at_order) AS \"Сумма\" FROM order_items oi JOIN products p ON p.id = oi.product_id JOIN orders o ON o.id = oi.order_id WHERE o.status <> 'Cancelled' GROUP BY p.id, p.name, p.category ORDER BY \"Сумма\" DESC LIMIT 20",
            Staff),
        new ReportDef("Заказы по статусам",
            "SELECT CASE status WHEN 'New' THEN 'Новый' WHEN 'Processing' THEN 'В обработке' WHEN 'Completed' THEN 'Выполнен' WHEN 'Cancelled' THEN 'Отменён' END AS \"Статус\", COUNT(*) AS \"Заказов\" FROM orders GROUP BY status ORDER BY \"Заказов\" DESC",
            Staff),
        new ReportDef("Пользователи по ролям",
            "SELECT r.name AS \"Роль\", COUNT(u.id) AS \"Пользователей\" FROM roles r LEFT JOIN users u ON u.role_id = r.id GROUP BY r.name ORDER BY r.name",
            AdminOnly),
        new ReportDef("Журнал действий за 7 дней",
            "SELECT a.created_at AS \"Время\", a.action AS \"Действие\", a.entity_name AS \"Сущность\", COALESCE(u.full_name, '—') AS \"Кто\", a.details AS \"Что сделано\" FROM audit_logs a LEFT JOIN users u ON u.id = a.user_id WHERE a.created_at >= NOW() - INTERVAL '7 days' ORDER BY a.created_at DESC",
            AdminOnly)
    };

    public static List<ReportDef> ForRole(string role)
    {
        return All.Where(r => r.Roles.Contains(role)).ToList();
    }
}

public static class ReportExporter
{
    public static decimal?[] CalculateSums(DataTable table)
    {
        var sums = new decimal?[table.Columns.Count];
        for (int i = 0; i < table.Columns.Count; i++)
        {
            Type type = table.Columns[i].DataType;
            if (type == typeof(decimal) || type == typeof(long) || type == typeof(int))
            {
                decimal sum = 0;
                foreach (DataRow row in table.Rows)
                {
                    if (!row.IsNull(i))
                    {
                        sum += Convert.ToDecimal(row[i]);
                    }
                }
                sums[i] = sum;
            }
        }
        return sums;
    }

    private static string FormatSum(DataColumn column, decimal value)
    {
        return column.DataType == typeof(decimal) ? value.ToString("N2") : value.ToString("N0");
    }

    public static string SummaryText(DataTable table)
    {
        decimal?[] sums = CalculateSums(table);
        var parts = new List<string>();
        for (int i = 0; i < sums.Length; i++)
        {
            if (sums[i] != null)
            {
                parts.Add(table.Columns[i].ColumnName + ": " + FormatSum(table.Columns[i], sums[i]!.Value));
            }
        }
        if (parts.Count == 0)
        {
            return "Всего записей: " + table.Rows.Count;
        }
        return "Итого — " + string.Join("     ", parts);
    }

    public static void ToExcel(DataTable table, string title, string path)
    {
        DataTable copy = table.Copy();
        copy.TableName = "Report";
        using XLWorkbook workbook = new XLWorkbook();
        IXLWorksheet sheet = workbook.Worksheets.Add("Отчёт");
        sheet.Cell(1, 1).Value = title;
        sheet.Cell(1, 1).Style.Font.Bold = true;
        sheet.Cell(1, 1).Style.Font.FontSize = 14;
        sheet.Cell(2, 1).Value = "Сформирован: " + DateTime.Now.ToString("dd.MM.yyyy HH:mm");
        sheet.Cell(4, 1).InsertTable(copy);

        int totalRow = 4 + table.Rows.Count + 1;
        decimal?[] sums = CalculateSums(table);
        if (sums.Any(x => x != null))
        {
            sheet.Cell(totalRow, 1).Value = "Итого";
            for (int i = 0; i < sums.Length; i++)
            {
                if (sums[i] != null)
                {
                    IXLCell cell = sheet.Cell(totalRow, i + 1);
                    cell.Value = (double)sums[i]!.Value;
                    cell.Style.NumberFormat.Format = table.Columns[i].DataType == typeof(decimal) ? "#,##0.00" : "#,##0";
                }
            }
        }
        else
        {
            sheet.Cell(totalRow, 1).Value = "Всего записей: " + table.Rows.Count;
        }
        sheet.Range(totalRow, 1, totalRow, table.Columns.Count).Style.Font.Bold = true;
        sheet.Columns().AdjustToContents(4, totalRow);
        workbook.SaveAs(path);
    }

    public static void ToPdf(DataTable table, string title, string path)
    {
        QuestPDF.Settings.License = LicenseType.Community;
        string date = DateTime.Now.ToString("dd.MM.yyyy HH:mm");
        decimal?[] sums = CalculateSums(table);
        bool hasSums = sums.Any(x => x != null);

        Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4.Landscape());
                page.Margin(30);
                page.DefaultTextStyle(x => x.FontFamily("Arial").FontSize(10));

                page.Header().Column(column =>
                {
                    column.Item().Text(title).FontSize(18).Bold();
                    column.Item().Text("CyberClub Manager, " + date).FontColor(Colors.Grey.Darken1);
                });

                page.Content().PaddingTop(12).Table(t =>
                {
                    t.ColumnsDefinition(columns =>
                    {
                        foreach (DataColumn column in table.Columns)
                        {
                            columns.RelativeColumn();
                        }
                    });
                    t.Header(header =>
                    {
                        foreach (DataColumn column in table.Columns)
                        {
                            header.Cell().Background(Colors.Grey.Lighten3).Padding(4).Text(column.ColumnName).Bold();
                        }
                    });
                    foreach (DataRow row in table.Rows)
                    {
                        foreach (object? item in row.ItemArray)
                        {
                            t.Cell().BorderBottom(0.5f).BorderColor(Colors.Grey.Lighten2).Padding(4).Text(Format(item));
                        }
                    }
                    for (int i = 0; i < table.Columns.Count; i++)
                    {
                        string text = "";
                        if (sums[i] != null)
                        {
                            text = FormatSum(table.Columns[i], sums[i]!.Value);
                        }
                        else if (i == 0)
                        {
                            text = hasSums ? "Итого" : "Всего записей: " + table.Rows.Count;
                        }
                        t.Cell().Background(Colors.Grey.Lighten4).Padding(4).Text(text).Bold();
                    }
                });

                page.Footer().AlignCenter().Text(x =>
                {
                    x.Span("Страница ");
                    x.CurrentPageNumber();
                });
            });
        }).GeneratePdf(path);
    }

    private static string Format(object? value)
    {
        if (value == null || value == DBNull.Value)
        {
            return "";
        }
        if (value is DateTime date)
        {
            return date.ToString("dd.MM.yyyy HH:mm");
        }
        if (value is decimal money)
        {
            return money.ToString("N2");
        }
        return value.ToString() ?? "";
    }
}
