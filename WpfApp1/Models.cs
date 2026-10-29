using System.Data;

namespace CyberClubManager;

public class Option
{
    public string Text { get; set; } = "";
    public object? Value { get; set; }

    public Option() { }

    public Option(string text, object? value)
    {
        Text = text;
        Value = value;
    }
}

public enum FieldType { Text, Multiline, Integer, Decimal, Combo, Password }

public class FormField
{
    public string Key { get; }
    public string Label { get; }
    public FieldType Type { get; }
    public bool Required { get; set; }
    public int MaxLength { get; set; }
    public decimal? Min { get; set; }
    public decimal? Max { get; set; }
    public string Pattern { get; set; } = "";
    public string PatternMessage { get; set; } = "";
    public List<Option> Options { get; set; } = new();

    public FormField(string key, string label, FieldType type)
    {
        Key = key;
        Label = label;
        Type = type;
    }
}

public class FilterDef
{
    public string Label { get; }
    public string Expression { get; }
    public List<Option> Options { get; }

    public FilterDef(string label, string expression, List<Option> options)
    {
        Label = label;
        Expression = expression;
        Options = options;
    }
}

public class ExtraButton
{
    public string Text { get; }
    public Action<CrudPage> Click { get; }

    public ExtraButton(string text, Action<CrudPage> click)
    {
        Text = text;
        Click = click;
    }
}

public class CrudConfig
{
    public string Title { get; set; } = "";
    public string Table { get; set; } = "";
    public string SelectSql { get; set; } = "";
    public string BaseWhere { get; set; } = "";
    public string GroupBy { get; set; } = "";
    public List<string> SearchExpressions { get; } = new();
    public List<FilterDef> Filters { get; } = new();
    public List<Option> Sorts { get; } = new();
    public List<FormField> Fields { get; } = new();
    public List<ExtraButton> Buttons { get; } = new();
    public bool CanAdd { get; set; }
    public bool CanEdit { get; set; }
    public bool CanDelete { get; set; }
    public Func<int, string?>? DeleteCheck { get; set; }
}

public class UserMessageException : Exception
{
    public UserMessageException(string message) : base(message) { }
}

public static class OptionLoader
{
    public static List<Option> Load(string sql)
    {
        var list = new List<Option>();
        DataTable dt = Database.Query(sql);
        foreach (DataRow row in dt.Rows)
        {
            list.Add(new Option(row[1].ToString() ?? "", row[0]));
        }
        return list;
    }
}
