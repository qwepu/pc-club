using System.Globalization;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;

namespace CyberClubManager;

public partial class EditWindow : Window
{
    private readonly List<FormField> fields;
    private readonly Dictionary<string, Control> controls = new();
    private readonly bool editing;

    public Dictionary<string, object?> Values { get; private set; } = new();

    public EditWindow(string title, List<FormField> fields, Dictionary<string, object?>? initial, int? id)
    {
        InitializeComponent();
        Title = title;
        this.fields = fields;
        editing = id != null;

        if (id != null)
        {
            AddLabel("ID (изменить нельзя)");
            FieldsPanel.Children.Add(new TextBox { Text = id.ToString(), IsEnabled = false });
        }

        foreach (FormField field in fields)
        {
            AddField(field, initial);
        }
    }

    private void AddLabel(string text)
    {
        FieldsPanel.Children.Add(new TextBlock { Text = text, Style = (Style)FindResource("LabelText") });
    }

    private void AddField(FormField field, Dictionary<string, object?>? initial)
    {
        AddLabel(field.Label + (field.Required ? " *" : ""));

        object? value = null;
        if (initial != null && initial.ContainsKey(field.Key))
        {
            value = initial[field.Key];
        }

        Control control;
        switch (field.Type)
        {
            case FieldType.Combo:
                ComboBox combo = new ComboBox { ItemsSource = field.Options, DisplayMemberPath = "Text", SelectedValuePath = "Value" };
                if (value != null)
                {
                    combo.SelectedValue = value;
                }
                control = combo;
                break;
            case FieldType.Password:
                control = new PasswordBox();
                break;
            case FieldType.Multiline:
                control = new TextBox
                {
                    AcceptsReturn = true,
                    TextWrapping = TextWrapping.Wrap,
                    Height = 70,
                    VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
                    Text = value?.ToString() ?? ""
                };
                break;
            case FieldType.Decimal:
                control = new TextBox { Text = value == null ? "" : Convert.ToDecimal(value).ToString("0.00", CultureInfo.InvariantCulture) };
                break;
            default:
                control = new TextBox { Text = value?.ToString() ?? "" };
                break;
        }

        FieldsPanel.Children.Add(control);
        controls[field.Key] = control;

        if (field.Type == FieldType.Password && editing)
        {
            FieldsPanel.Children.Add(new TextBlock
            {
                Text = "Оставьте пустым, чтобы не менять пароль",
                Foreground = System.Windows.Media.Brushes.Gray,
                Margin = new Thickness(4, 0, 4, 0)
            });
        }
    }

    private void Ok_Click(object sender, RoutedEventArgs e)
    {
        var errors = new List<string>();
        var result = new Dictionary<string, object?>();

        foreach (FormField field in fields)
        {
            Control control = controls[field.Key];
            string label = "«" + field.Label + "»";

            if (field.Type == FieldType.Combo)
            {
                object? selected = ((ComboBox)control).SelectedValue;
                if (selected == null && field.Required)
                {
                    errors.Add("Выберите значение в поле " + label + ".");
                }
                result[field.Key] = selected;
                continue;
            }

            string text = control is PasswordBox box ? box.Password : ((TextBox)control).Text.Trim();

            if (text == "")
            {
                bool passwordKept = field.Type == FieldType.Password && editing;
                if (field.Required && !passwordKept)
                {
                    errors.Add("Поле " + label + " обязательно для заполнения.");
                }
                result[field.Key] = null;
                continue;
            }

            if (field.MaxLength > 0 && text.Length > field.MaxLength)
            {
                errors.Add("Поле " + label + ": не больше " + field.MaxLength + " символов.");
                continue;
            }

            switch (field.Type)
            {
                case FieldType.Integer:
                    if (!int.TryParse(text, NumberStyles.Integer, CultureInfo.InvariantCulture, out int number))
                    {
                        errors.Add("Поле " + label + " должно быть целым числом.");
                    }
                    else if (field.Min != null && number < field.Min)
                    {
                        errors.Add("Поле " + label + " не может быть меньше " + field.Min + ".");
                    }
                    else if (field.Max != null && number > field.Max)
                    {
                        errors.Add("Поле " + label + " не может быть больше " + field.Max + ".");
                    }
                    else
                    {
                        result[field.Key] = number;
                    }
                    break;

                case FieldType.Decimal:
                    string normalized = text.Replace(',', '.');
                    if (!decimal.TryParse(normalized, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal money))
                    {
                        errors.Add("Поле " + label + " должно быть числом (например, 150 или 150.50).");
                    }
                    else if (Math.Round(money, 2) != money)
                    {
                        errors.Add("Поле " + label + ": не больше двух знаков после запятой.");
                    }
                    else if (field.Min != null && money < field.Min)
                    {
                        errors.Add("Поле " + label + " не может быть меньше " + field.Min + ".");
                    }
                    else if (field.Max != null && money > field.Max)
                    {
                        errors.Add("Поле " + label + " слишком большое.");
                    }
                    else
                    {
                        result[field.Key] = money;
                    }
                    break;

                case FieldType.Password:
                    if (text.Length < 6)
                    {
                        errors.Add("Пароль должен быть не короче 6 символов.");
                    }
                    else
                    {
                        result[field.Key] = text;
                    }
                    break;

                default:
                    if (field.Pattern != "" && !Regex.IsMatch(text, field.Pattern))
                    {
                        errors.Add(field.PatternMessage != "" ? field.PatternMessage : "Поле " + label + " заполнено неверно.");
                    }
                    else
                    {
                        result[field.Key] = text;
                    }
                    break;
            }
        }

        if (errors.Count > 0)
        {
            ErrorText.Text = string.Join("\n", errors);
            return;
        }

        Values = result;
        DialogResult = true;
    }
}
