using System.Data;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace CyberClubManager;

public partial class CrudPage : UserControl
{
    private readonly CrudConfig config;
    private readonly List<ComboBox> filterBoxes = new();
    private bool desc1;
    private bool desc2;

    public CrudPage(CrudConfig config)
    {
        InitializeComponent();
        this.config = config;
        BuildFilters();
        BuildSortBoxes();
        BuildButtons();
        Load();
    }

    public int? SelectedId
    {
        get
        {
            if (Table.SelectedItem is DataRowView row)
            {
                return Convert.ToInt32(row["ID"]);
            }
            return null;
        }
    }

    public int RequireSelectedId()
    {
        int? id = SelectedId;
        if (id == null)
        {
            throw new UserMessageException("Выберите запись в таблице.");
        }
        return id.Value;
    }

    public void Reload()
    {
        Load();
    }

    private void BuildFilters()
    {
        foreach (FilterDef filter in config.Filters)
        {
            var options = new List<Option> { new Option("Все", null) };
            options.AddRange(filter.Options);

            ComboBox box = new ComboBox
            {
                ItemsSource = options,
                DisplayMemberPath = "Text",
                SelectedIndex = 0,
                MinWidth = 140
            };
            box.SelectionChanged += (s, e) => Load();

            FilterPanel.Children.Add(new TextBlock { Text = filter.Label + ":", VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(4, 4, 2, 4), Foreground = (Brush)FindResource("MutedBrush") });
            FilterPanel.Children.Add(box);
            filterBoxes.Add(box);
        }
    }

    private void BuildSortBoxes()
    {
        if (config.Sorts.Count == 0)
        {
            SortPanel.Visibility = Visibility.Collapsed;
            return;
        }
        foreach (ComboBox box in new[] { Sort1Box, Sort2Box })
        {
            var options = new List<Option> { new Option("— не выбрано —", null) };
            options.AddRange(config.Sorts);
            box.ItemsSource = options;
            box.DisplayMemberPath = "Text";
            box.SelectedIndex = 0;
        }
        Sort1Box.SelectionChanged += (s, e) =>
        {
            if (!(Sort1Box.SelectedItem is Option first && first.Value != null))
            {
                Sort2Box.SelectedIndex = 0;
            }
            UpdateSortVisibility();
            Load();
        };
        Sort2Box.SelectionChanged += (s, e) =>
        {
            UpdateSortVisibility();
            Load();
        };
        UpdateSortVisibility();
    }

    private void UpdateSortVisibility()
    {
        bool hasFirst = Sort1Box.SelectedItem is Option first && first.Value != null;
        bool hasSecond = Sort2Box.SelectedItem is Option second && second.Value != null;
        Dir1Button.Visibility = hasFirst ? Visibility.Visible : Visibility.Collapsed;
        ThenText.Visibility = hasFirst ? Visibility.Visible : Visibility.Collapsed;
        Sort2Box.Visibility = hasFirst ? Visibility.Visible : Visibility.Collapsed;
        Dir2Button.Visibility = hasFirst && hasSecond ? Visibility.Visible : Visibility.Collapsed;
    }

    private void Dir1_Click(object sender, RoutedEventArgs e)
    {
        desc1 = !desc1;
        Dir1Button.Content = desc1 ? "↓" : "↑";
        Load();
    }

    private void Dir2_Click(object sender, RoutedEventArgs e)
    {
        desc2 = !desc2;
        Dir2Button.Content = desc2 ? "↓" : "↑";
        Load();
    }

    private void BuildButtons()
    {
        if (config.CanAdd)
        {
            AddButton("Добавить", Add_Click, true);
        }
        if (config.CanEdit)
        {
            AddButton("Изменить", Edit_Click);
        }
        if (config.CanDelete)
        {
            AddButton("Удалить", Delete_Click);
        }
        foreach (ExtraButton extra in config.Buttons)
        {
            ExtraButton current = extra;
            AddButton(current.Text, (s, e) =>
            {
                try
                {
                    current.Click(this);
                }
                catch (Exception ex)
                {
                    ErrorHelper.Show(ex);
                }
            });
        }
        AddButton("Обновить", (s, e) => Load());
    }

    private void AddButton(string text, RoutedEventHandler handler, bool primary = false)
    {
        Button button = new Button { Content = text };
        if (primary)
        {
            button.Style = (Style)FindResource("PrimaryButton");
        }
        button.Click += handler;
        ButtonPanel.Children.Add(button);
    }

    private static string EscapeLike(string text)
    {
        return text.Replace("\\", "\\\\").Replace("%", "\\%").Replace("_", "\\_");
    }

    private string BuildOrder()
    {
        var parts = new List<string>();
        if (Sort1Box.SelectedItem is Option first && first.Value != null)
        {
            parts.Add(first.Value + (desc1 ? " DESC" : " ASC"));
        }
        if (Sort2Box.SelectedItem is Option second && second.Value != null)
        {
            parts.Add(second.Value + (desc2 ? " DESC" : " ASC"));
        }
        if (parts.Count == 0)
        {
            return "1";
        }
        return string.Join(", ", parts);
    }

    private void Load()
    {
        try
        {
            var where = new List<string>();
            var parameters = new List<(string, object?)>();

            if (config.BaseWhere != "")
            {
                where.Add(config.BaseWhere);
            }

            string query = SearchBox.Text.Trim();
            if (query != "" && config.SearchExpressions.Count > 0)
            {
                var parts = config.SearchExpressions.Select(x => "(" + x + ")::text ILIKE @q");
                where.Add("(" + string.Join(" OR ", parts) + ")");
                parameters.Add(("q", "%" + EscapeLike(query) + "%"));
            }

            for (int i = 0; i < filterBoxes.Count; i++)
            {
                if (filterBoxes[i].SelectedItem is Option option && option.Value != null)
                {
                    where.Add("(" + config.Filters[i].Expression + ")::text = @f" + i);
                    parameters.Add(("f" + i, option.Value.ToString()));
                }
            }

            string sql = config.SelectSql;
            if (where.Count > 0)
            {
                sql += " WHERE " + string.Join(" AND ", where);
            }
            if (config.GroupBy != "")
            {
                sql += " GROUP BY " + config.GroupBy;
            }
            sql += " ORDER BY " + BuildOrder();

            DataTable data = Database.Query(sql, parameters.ToArray());
            Table.ItemsSource = data.DefaultView;
            CountText.Text = "Найдено записей: " + data.Rows.Count;
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }

    private void SearchBox_KeyDown(object sender, KeyEventArgs e)
    {
        if (e.Key == Key.Enter)
        {
            Load();
        }
    }

    private void Apply_Click(object sender, RoutedEventArgs e)
    {
        Load();
    }

    private void Reset_Click(object sender, RoutedEventArgs e)
    {
        SearchBox.Text = "";
        foreach (ComboBox box in filterBoxes)
        {
            box.SelectedIndex = 0;
        }
        desc1 = false;
        desc2 = false;
        Dir1Button.Content = "↑";
        Dir2Button.Content = "↑";
        if (Sort1Box.Items.Count > 0)
        {
            Sort1Box.SelectedIndex = 0;
            Sort2Box.SelectedIndex = 0;
        }
        Load();
    }

    private void Table_AutoGeneratingColumn(object sender, DataGridAutoGeneratingColumnEventArgs e)
    {
        GridHelper.Format(e);
    }

    private Dictionary<string, object?> LoadRow(int id)
    {
        DataTable data = Database.Query("SELECT * FROM " + config.Table + " WHERE id = @id", ("id", id));
        if (data.Rows.Count == 0)
        {
            throw new UserMessageException("Запись не найдена. Обновите таблицу.");
        }
        var result = new Dictionary<string, object?>();
        foreach (DataColumn column in data.Columns)
        {
            object value = data.Rows[0][column];
            result[column.ColumnName] = value == DBNull.Value ? null : value;
        }
        return result;
    }

    private void Add_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            if (!config.CanAdd)
            {
                throw new UserMessageException("Недостаточно прав для добавления.");
            }
            EditWindow window = new EditWindow("Добавление: " + config.Title, config.Fields, null, null) { Owner = Window.GetWindow(this) };
            if (window.ShowDialog() == true)
            {
                Save(null, window.Values, null);
            }
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }

    private void Edit_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            if (!config.CanEdit)
            {
                throw new UserMessageException("Недостаточно прав для изменения.");
            }
            int id = RequireSelectedId();
            Dictionary<string, object?> initial = LoadRow(id);
            EditWindow window = new EditWindow("Изменение: " + config.Title, config.Fields, initial, id) { Owner = Window.GetWindow(this) };
            if (window.ShowDialog() == true)
            {
                Save(id, window.Values, initial);
            }
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }

    private static string FormatValue(FormField field, object? value)
    {
        if (value == null)
        {
            return "пусто";
        }
        if (field.Type == FieldType.Combo)
        {
            Option? option = field.Options.FirstOrDefault(o => Equals(o.Value, value));
            return option != null ? option.Text : value.ToString() ?? "";
        }
        if (value is decimal money)
        {
            return money.ToString("0.00", CultureInfo.InvariantCulture);
        }
        return value.ToString() ?? "";
    }

    private void Save(int? id, Dictionary<string, object?> values, Dictionary<string, object?>? old)
    {
        var columns = new List<string>();
        var parameters = new List<(string, object?)>();
        var created = new List<string>();
        var changes = new List<string>();
        int index = 0;

        foreach (FormField field in config.Fields)
        {
            object? value = values[field.Key];
            if (field.Type == FieldType.Password)
            {
                if (value == null)
                {
                    continue;
                }
                changes.Add("пароль изменён");
                value = Security.HashPassword((string)value);
            }
            else
            {
                string newText = FormatValue(field, value);
                created.Add(field.Label + ": " + newText);
                if (old != null)
                {
                    object? oldValue = old.ContainsKey(field.Key) ? old[field.Key] : null;
                    string oldText = FormatValue(field, oldValue);
                    if (oldText != newText)
                    {
                        changes.Add(field.Label + ": " + oldText + " → " + newText);
                    }
                }
            }
            columns.Add(field.Key);
            parameters.Add(("p" + index, value));
            index++;
        }

        string title = Audit.EntityTitle(config.Table);
        string recordName = Audit.NameOf(config.Table, values);

        if (id == null)
        {
            string names = string.Join(", ", columns);
            string markers = string.Join(", ", Enumerable.Range(0, columns.Count).Select(n => "@p" + n));
            string sql = "INSERT INTO " + config.Table + " (" + names + ") VALUES (" + markers + ") RETURNING id";
            object? newId = Database.Scalar(sql, parameters.ToArray());
            Audit.Write("CREATE", config.Table, "Создан " + title + recordName + " (ID=" + newId + "). " + string.Join("; ", created));
        }
        else
        {
            string sets = string.Join(", ", columns.Select((c, n) => c + " = @p" + n));
            parameters.Add(("id", id));
            string sql = "UPDATE " + config.Table + " SET " + sets + " WHERE id = @id";
            Database.Execute(sql, parameters.ToArray());
            if (changes.Count > 0)
            {
                Audit.Write("UPDATE", config.Table, "Изменён " + title + recordName + " (ID=" + id + "). " + string.Join("; ", changes));
            }
        }
        Load();
    }

    private void Delete_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            if (!config.CanDelete)
            {
                throw new UserMessageException("Недостаточно прав для удаления.");
            }
            int id = RequireSelectedId();
            string? problem = config.DeleteCheck?.Invoke(id);
            if (problem != null)
            {
                MessageBox.Show(problem, "Удаление невозможно", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }
            Dictionary<string, object?> old = LoadRow(id);
            if (MessageBox.Show("Удалить выбранную запись?", "Подтверждение", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
            {
                return;
            }
            Database.Execute("DELETE FROM " + config.Table + " WHERE id = @id", ("id", id));
            Audit.Write("DELETE", config.Table, "Удалён " + Audit.EntityTitle(config.Table) + Audit.NameOf(config.Table, old) + " (ID=" + id + ")");
            Load();
        }
        catch (Exception ex)
        {
            ErrorHelper.Show(ex);
        }
    }
}
