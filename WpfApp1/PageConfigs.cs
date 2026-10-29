using System.Data;
using System.Windows;

namespace CyberClubManager;

public static class PageConfigs
{
    private const string EmailPattern = @"^[^@\s]+@[^@\s]+\.[^@\s]+$";

    private static List<Option> YesNo(string yes, string no)
    {
        return new List<Option> { new Option(yes, true), new Option(no, false) };
    }

    private static List<Option> YesNoFilter(string yes, string no)
    {
        return new List<Option> { new Option(yes, "true"), new Option(no, "false") };
    }

    private static List<Option> Statuses()
    {
        return new List<Option>
        {
            new Option("Новый", "New"),
            new Option("В обработке", "Processing"),
            new Option("Выполнен", "Completed"),
            new Option("Отменён", "Cancelled")
        };
    }

    private static List<Option> Same(params string[] values)
    {
        return values.Select(v => new Option(v, v)).ToList();
    }

    private static void AddSorts(CrudConfig config, params (string Text, string Expression)[] items)
    {
        foreach (var item in items)
        {
            config.Sorts.Add(new Option(item.Text, item.Expression));
        }
    }

    public static CrudConfig Users()
    {
        CurrentUser.Require("Administrator");
        var config = new CrudConfig
        {
            Title = "пользователь",
            Table = "users",
            SelectSql = "SELECT u.id AS \"ID\", u.login AS \"Логин\", u.full_name AS \"ФИО\", u.email AS \"Почта\", r.name AS \"Роль\" FROM users u JOIN roles r ON r.id = u.role_id",
            CanAdd = true,
            CanEdit = true,
            CanDelete = true,
            DeleteCheck = id => id == CurrentUser.Id ? "Нельзя удалить свою учётную запись." : null
        };
        config.SearchExpressions.AddRange(new[] { "u.login", "u.full_name", "u.email" });
        config.Filters.Add(new FilterDef("Роль", "r.id", OptionLoader.Load("SELECT id, name FROM roles ORDER BY id")));
        AddSorts(config, ("ID", "u.id"), ("Логин", "u.login"), ("ФИО", "u.full_name"), ("Роль", "r.name"));
        config.Fields.Add(new FormField("login", "Логин", FieldType.Text)
        {
            Required = true,
            MaxLength = 50,
            Pattern = "^[A-Za-z0-9_]{3,50}$",
            PatternMessage = "Логин: от 3 до 50 символов, только латинские буквы, цифры и _."
        });
        config.Fields.Add(new FormField("full_name", "ФИО", FieldType.Text) { Required = true, MaxLength = 100 });
        config.Fields.Add(new FormField("email", "Почта", FieldType.Text)
        {
            MaxLength = 100,
            Pattern = EmailPattern,
            PatternMessage = "Почта должна быть в формате name@example.com."
        });
        config.Fields.Add(new FormField("role_id", "Роль", FieldType.Combo)
        {
            Required = true,
            Options = OptionLoader.Load("SELECT id, name FROM roles ORDER BY id")
        });
        config.Fields.Add(new FormField("password_hash", "Пароль", FieldType.Password) { Required = true, MaxLength = 64 });
        return config;
    }

    public static CrudConfig Computers(bool canEdit)
    {
        if (canEdit)
        {
            CurrentUser.Require("Administrator");
        }
        var config = new CrudConfig
        {
            Title = "компьютер",
            Table = "computers",
            SelectSql = "SELECT c.id AS \"ID\", c.name AS \"Название\", CASE WHEN c.status THEN 'Доступен' ELSE 'Недоступен' END AS \"Состояние\", c.description AS \"Описание\" FROM computers c",
            CanAdd = canEdit,
            CanEdit = canEdit,
            CanDelete = canEdit
        };
        config.SearchExpressions.AddRange(new[] { "c.name", "c.description" });
        config.Filters.Add(new FilterDef("Состояние", "c.status", YesNoFilter("Доступен", "Недоступен")));
        AddSorts(config, ("ID", "c.id"), ("Название", "c.name"), ("Состояние", "c.status"));
        config.Fields.Add(new FormField("name", "Название", FieldType.Text) { Required = true, MaxLength = 50 });
        config.Fields.Add(new FormField("status", "Состояние", FieldType.Combo) { Required = true, Options = YesNo("Доступен", "Недоступен") });
        config.Fields.Add(new FormField("description", "Описание", FieldType.Multiline) { MaxLength = 500 });
        return config;
    }

    public static CrudConfig Tariffs(bool canEdit)
    {
        if (canEdit)
        {
            CurrentUser.Require("Administrator");
        }
        var config = new CrudConfig
        {
            Title = "тариф",
            Table = "tariffs",
            SelectSql = "SELECT t.id AS \"ID\", t.name AS \"Название\", t.price AS \"Цена\", CASE WHEN t.is_active THEN 'Да' ELSE 'Нет' END AS \"Действует\", t.description AS \"Описание\" FROM tariffs t",
            CanAdd = canEdit,
            CanEdit = canEdit,
            CanDelete = canEdit
        };
        config.SearchExpressions.AddRange(new[] { "t.name", "t.description" });
        config.Filters.Add(new FilterDef("Действует", "t.is_active", YesNoFilter("Да", "Нет")));
        AddSorts(config, ("ID", "t.id"), ("Название", "t.name"), ("Цена", "t.price"), ("Действует", "t.is_active"));
        config.Fields.Add(new FormField("name", "Название", FieldType.Text) { Required = true, MaxLength = 50 });
        config.Fields.Add(new FormField("price", "Цена, руб.", FieldType.Decimal) { Required = true, Min = 0, Max = 99999999 });
        config.Fields.Add(new FormField("is_active", "Действует", FieldType.Combo) { Required = true, Options = YesNo("Да", "Нет") });
        config.Fields.Add(new FormField("description", "Описание", FieldType.Multiline) { MaxLength = 500 });
        return config;
    }

    public static CrudConfig Products(bool canEdit)
    {
        if (canEdit)
        {
            CurrentUser.Require("Administrator", "Manager");
        }
        var categories = Same("Напитки", "Снеки", "Сладости", "Еда", "Другое");
        var config = new CrudConfig
        {
            Title = "товар",
            Table = "products",
            SelectSql = "SELECT p.id AS \"ID\", p.name AS \"Название\", p.category AS \"Категория\", p.price AS \"Цена\", p.quantity_in_stock AS \"Остаток\", CASE WHEN p.is_available THEN 'Да' ELSE 'Нет' END AS \"Доступен\" FROM products p",
            CanAdd = canEdit,
            CanEdit = canEdit,
            CanDelete = canEdit
        };
        config.SearchExpressions.AddRange(new[] { "p.name", "p.category" });
        config.Filters.Add(new FilterDef("Категория", "p.category", Same("Напитки", "Снеки", "Сладости", "Еда", "Другое")));
        config.Filters.Add(new FilterDef("Доступен", "p.is_available", YesNoFilter("Да", "Нет")));
        AddSorts(config, ("ID", "p.id"), ("Название", "p.name"), ("Категория", "p.category"), ("Цена", "p.price"), ("Остаток", "p.quantity_in_stock"));
        config.Fields.Add(new FormField("name", "Название", FieldType.Text) { Required = true, MaxLength = 100 });
        config.Fields.Add(new FormField("category", "Категория", FieldType.Combo) { Required = true, Options = categories });
        config.Fields.Add(new FormField("price", "Цена, руб.", FieldType.Decimal) { Required = true, Min = 0, Max = 99999999 });
        config.Fields.Add(new FormField("quantity_in_stock", "Количество на складе", FieldType.Integer) { Required = true, Min = 0, Max = 1000000 });
        config.Fields.Add(new FormField("is_available", "Доступен для заказа", FieldType.Combo) { Required = true, Options = YesNo("Да", "Нет") });
        return config;
    }

    public static CrudConfig Orders()
    {
        var config = new CrudConfig
        {
            Title = "заказ",
            Table = "orders",
            SelectSql = "SELECT o.id AS \"ID\", o.created_at AS \"Создан\", CASE o.status WHEN 'New' THEN 'Новый' WHEN 'Processing' THEN 'В обработке' WHEN 'Completed' THEN 'Выполнен' WHEN 'Cancelled' THEN 'Отменён' END AS \"Статус\", u.full_name AS \"Клиент\", COALESCE(SUM(oi.quantity * oi.price_at_order), 0) AS \"Сумма\", o.comment AS \"Комментарий\" FROM orders o JOIN users u ON u.id = o.user_id LEFT JOIN order_items oi ON oi.order_id = o.id",
            GroupBy = "o.id, u.id"
        };
        if (CurrentUser.IsUser)
        {
            config.BaseWhere = "o.user_id = " + CurrentUser.Id;
        }
        config.SearchExpressions.AddRange(new[] { "o.comment", "u.full_name", "o.status" });
        config.Filters.Add(new FilterDef("Статус", "o.status", Statuses()));
        if (!CurrentUser.IsUser)
        {
            config.Filters.Add(new FilterDef("Клиент", "u.id", OptionLoader.Load("SELECT id, full_name FROM users ORDER BY full_name")));
        }
        AddSorts(config, ("ID", "o.id"), ("Дата", "o.created_at"), ("Статус", "o.status"), ("Клиент", "u.full_name"), ("Сумма", "\"Сумма\""));

        config.Buttons.Add(new ExtraButton("Создать заказ", page =>
        {
            OrderCreateWindow window = new OrderCreateWindow { Owner = Window.GetWindow(page) };
            if (window.ShowDialog() == true)
            {
                page.Reload();
            }
        }));
        config.Buttons.Add(new ExtraButton("Состав заказа", page => OrderService.ShowItems(page.RequireSelectedId())));
        config.Buttons.Add(new ExtraButton("Получить заказ", page =>
        {
            OrderService.Receive(page.RequireSelectedId());
            page.Reload();
        }));
        config.Buttons.Add(new ExtraButton("Отменить заказ", page =>
        {
            OrderService.Cancel(page.RequireSelectedId());
            page.Reload();
        }));
        if (!CurrentUser.IsUser)
        {
            config.Buttons.Add(new ExtraButton("Принять заказ", page =>
            {
                OrderService.Accept(page.RequireSelectedId());
                page.Reload();
            }));
        }
        if (CurrentUser.IsAdmin)
        {
            config.Buttons.Add(new ExtraButton("Изменить (админ)", EditOrder));
            config.Buttons.Add(new ExtraButton("Удалить заказ", page =>
            {
                int id = page.RequireSelectedId();
                if (MessageBox.Show("Удалить заказ №" + id + "?", "Подтверждение", MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                {
                    return;
                }
                OrderService.Delete(id);
                page.Reload();
            }));
        }
        return config;
    }

    private static void EditOrder(CrudPage page)
    {
        int id = page.RequireSelectedId();
        DataTable data = Database.Query("SELECT status, comment FROM orders WHERE id = @id", ("id", id));
        if (data.Rows.Count == 0)
        {
            throw new UserMessageException("Заказ не найден. Обновите таблицу.");
        }
        object comment = data.Rows[0]["comment"];
        var initial = new Dictionary<string, object?>
        {
            ["status"] = data.Rows[0]["status"].ToString(),
            ["comment"] = comment == DBNull.Value ? null : comment.ToString()
        };
        var fields = new List<FormField>
        {
            new FormField("status", "Статус", FieldType.Combo) { Required = true, Options = Statuses() },
            new FormField("comment", "Комментарий", FieldType.Multiline) { MaxLength = 500 }
        };
        EditWindow window = new EditWindow("Изменение заказа", fields, initial, id) { Owner = Window.GetWindow(page) };
        if (window.ShowDialog() != true)
        {
            return;
        }
        OrderService.AdminUpdate(id, (string)window.Values["status"]!, window.Values["comment"] as string);
        page.Reload();
    }

    public static CrudConfig Sessions()
    {
        var config = new CrudConfig
        {
            Title = "сеанс",
            Table = "game_sessions",
            SelectSql = "SELECT s.id AS \"ID\", u.full_name AS \"Клиент\", c.name AS \"Компьютер\", t.name AS \"Тариф\", s.start_time AS \"Начало\", s.end_time AS \"Конец\", s.cost AS \"Стоимость\" FROM game_sessions s JOIN users u ON u.id = s.user_id JOIN computers c ON c.id = s.computer_id JOIN tariffs t ON t.id = s.tariff_id",
            CanDelete = CurrentUser.IsAdmin
        };
        if (CurrentUser.IsUser)
        {
            config.BaseWhere = "s.user_id = " + CurrentUser.Id;
        }
        config.SearchExpressions.AddRange(new[] { "u.full_name", "c.name", "t.name" });
        config.Filters.Add(new FilterDef("Состояние", "CASE WHEN s.end_time IS NULL THEN 'active' ELSE 'finished' END",
            new List<Option> { new Option("Идёт сейчас", "active"), new Option("Завершён", "finished") }));
        config.Filters.Add(new FilterDef("Тариф", "t.id", OptionLoader.Load("SELECT id, name FROM tariffs ORDER BY name")));
        config.Filters.Add(new FilterDef("Компьютер", "c.id", OptionLoader.Load("SELECT id, name FROM computers ORDER BY name")));
        AddSorts(config, ("ID", "s.id"), ("Начало", "s.start_time"), ("Компьютер", "c.name"), ("Клиент", "u.full_name"), ("Стоимость", "s.cost"));

        config.Buttons.Add(new ExtraButton("Начать сеанс", StartSession));
        config.Buttons.Add(new ExtraButton("Завершить сеанс", page =>
        {
            SessionService.Finish(page.RequireSelectedId());
            page.Reload();
        }));
        return config;
    }

    private static void StartSession(CrudPage page)
    {
        var fields = new List<FormField>
        {
            new FormField("computer_id", "Компьютер", FieldType.Combo)
            {
                Required = true,
                Options = OptionLoader.Load("SELECT c.id, c.name FROM computers c WHERE c.status AND NOT EXISTS (SELECT 1 FROM game_sessions s WHERE s.computer_id = c.id AND s.end_time IS NULL) ORDER BY c.name")
            },
            new FormField("tariff_id", "Тариф", FieldType.Combo)
            {
                Required = true,
                Options = OptionLoader.Load("SELECT id, name || ' — ' || price || ' руб.' FROM tariffs WHERE is_active ORDER BY name")
            }
        };
        if (!CurrentUser.IsUser)
        {
            fields.Add(new FormField("user_id", "Клиент", FieldType.Combo)
            {
                Required = true,
                Options = OptionLoader.Load("SELECT id, full_name || ' (' || login || ')' FROM users ORDER BY full_name")
            });
        }
        EditWindow window = new EditWindow("Начать сеанс", fields, null, null) { Owner = Window.GetWindow(page) };
        if (window.ShowDialog() != true)
        {
            return;
        }
        int userId = CurrentUser.IsUser ? CurrentUser.Id : Convert.ToInt32(window.Values["user_id"]);
        SessionService.Start(userId, Convert.ToInt32(window.Values["computer_id"]), Convert.ToInt32(window.Values["tariff_id"]));
        page.Reload();
    }

    public static CrudConfig AuditLog()
    {
        CurrentUser.Require("Administrator");
        var config = new CrudConfig
        {
            Title = "запись журнала",
            Table = "audit_logs",
            SelectSql = "SELECT a.id AS \"ID\", a.created_at AS \"Время\", COALESCE(u.full_name, '—') AS \"Кто\", CASE r.name WHEN 'Administrator' THEN 'Администратор' WHEN 'Manager' THEN 'Менеджер' WHEN 'User' THEN 'Пользователь' ELSE '' END AS \"Роль\", CASE a.action WHEN 'LOGIN' THEN 'Вход' WHEN 'LOGOUT' THEN 'Выход' WHEN 'REGISTER' THEN 'Регистрация' WHEN 'CREATE' THEN 'Создание' WHEN 'UPDATE' THEN 'Изменение' WHEN 'DELETE' THEN 'Удаление' ELSE a.action END AS \"Действие\", CASE a.entity_name WHEN 'users' THEN 'Пользователи' WHEN 'computers' THEN 'Компьютеры' WHEN 'tariffs' THEN 'Тарифы' WHEN 'products' THEN 'Товары' WHEN 'orders' THEN 'Заказы' WHEN 'game_sessions' THEN 'Сеансы' WHEN 'reports' THEN 'Отчёты' ELSE a.entity_name END AS \"Раздел\", a.details AS \"Что сделано\" FROM audit_logs a LEFT JOIN users u ON u.id = a.user_id LEFT JOIN roles r ON r.id = u.role_id"
        };
        config.SearchExpressions.AddRange(new[] { "u.full_name", "u.login", "a.details", "a.entity_name" });
        config.Filters.Add(new FilterDef("Действие", "a.action", new List<Option>
        {
            new Option("Вход", "LOGIN"),
            new Option("Выход", "LOGOUT"),
            new Option("Регистрация", "REGISTER"),
            new Option("Создание", "CREATE"),
            new Option("Изменение", "UPDATE"),
            new Option("Удаление", "DELETE")
        }));
        config.Filters.Add(new FilterDef("Раздел", "a.entity_name", new List<Option>
        {
            new Option("Пользователи", "users"),
            new Option("Компьютеры", "computers"),
            new Option("Тарифы", "tariffs"),
            new Option("Товары", "products"),
            new Option("Заказы", "orders"),
            new Option("Сеансы", "game_sessions"),
            new Option("Отчёты", "reports")
        }));
        config.Filters.Add(new FilterDef("Кто", "u.id", OptionLoader.Load("SELECT id, full_name FROM users ORDER BY full_name")));
        AddSorts(config, ("ID", "a.id"), ("Время", "a.created_at"), ("Кто", "u.full_name"), ("Действие", "a.action"), ("Раздел", "a.entity_name"));
        return config;
    }
}
