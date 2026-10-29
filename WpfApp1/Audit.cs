namespace CyberClubManager;

public static class Audit
{
    public static void Write(string action, string entity, string details, int? userId = null)
    {
        try
        {
            int? id = userId;
            if (id == null && CurrentUser.Id != 0)
            {
                id = CurrentUser.Id;
            }
            Database.Execute(
                "INSERT INTO audit_logs (action, entity_name, user_id, details) VALUES (@a, @e, @u, @d)",
                ("a", action), ("e", entity), ("u", id), ("d", details));
        }
        catch
        {
        }
    }

    public static string EntityTitle(string table)
    {
        return table switch
        {
            "users" => "пользователь",
            "computers" => "компьютер",
            "tariffs" => "тариф",
            "products" => "товар",
            "orders" => "заказ",
            "game_sessions" => "сеанс",
            _ => table
        };
    }

    public static string NameOf(string table, Dictionary<string, object?> row)
    {
        string key = table switch
        {
            "users" => "login",
            "computers" => "name",
            "tariffs" => "name",
            "products" => "name",
            _ => ""
        };
        if (key != "" && row.ContainsKey(key) && row[key] != null)
        {
            return " «" + row[key] + "»";
        }
        return "";
    }
}
