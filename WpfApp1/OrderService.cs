using System.Data;
using System.Text;
using System.Windows;
using Npgsql;

namespace CyberClubManager;

public static class OrderService
{
    public static string StatusTitle(string status) => status switch
    {
        "New" => "Новый",
        "Processing" => "В обработке",
        "Completed" => "Выполнен",
        "Cancelled" => "Отменён",
        _ => status
    };

    public static int CreateOrder(int userId, string comment, List<(int ProductId, int Quantity)> items)
    {
        CurrentUser.Require("Administrator", "Manager", "User");
        if (items.Count == 0)
        {
            throw new UserMessageException("В заказе нет товаров.");
        }
        using NpgsqlConnection conn = Database.GetConnection();
        conn.Open();
        using NpgsqlTransaction tx = conn.BeginTransaction();

        object? commentValue = comment == "" ? null : comment;
        object? newId = Database.ScalarTx(conn, tx,
            "INSERT INTO orders (comment, user_id) VALUES (@c, @u) RETURNING id",
            ("c", commentValue), ("u", userId));
        int orderId = Convert.ToInt32(newId);

        foreach (var item in items)
        {
            int rows = Database.ExecuteTx(conn, tx,
                "UPDATE products SET quantity_in_stock = quantity_in_stock - @q WHERE id = @p AND is_available AND quantity_in_stock >= @q",
                ("q", item.Quantity), ("p", item.ProductId));
            if (rows == 0)
            {
                throw new UserMessageException("Товара недостаточно на складе или он стал недоступен. Обновите список и попробуйте снова.");
            }
            Database.ExecuteTx(conn, tx,
                "INSERT INTO order_items (order_id, product_id, quantity, price_at_order) SELECT @o, id, @q, price FROM products WHERE id = @p",
                ("o", orderId), ("q", item.Quantity), ("p", item.ProductId));
        }

        DataTable lines = Database.QueryTx(conn, tx,
            "SELECT p.name, oi.quantity, oi.price_at_order FROM order_items oi JOIN products p ON p.id = oi.product_id WHERE oi.order_id = @o ORDER BY p.name",
            ("o", orderId));
        var parts = new List<string>();
        decimal total = 0;
        foreach (DataRow line in lines.Rows)
        {
            int quantity = Convert.ToInt32(line[1]);
            total += quantity * Convert.ToDecimal(line[2]);
            parts.Add(line[0] + " × " + quantity);
        }
        object? clientName = Database.ScalarTx(conn, tx, "SELECT full_name FROM users WHERE id = @u", ("u", userId));

        tx.Commit();
        Audit.Write("CREATE", "orders",
            "Оформлен заказ №" + orderId + " (клиент: " + clientName + "): " + string.Join(", ", parts) + "; сумма " + total.ToString("N2"));
        return orderId;
    }

    public static void Accept(int orderId)
    {
        CurrentUser.Require("Administrator", "Manager");
        ChangeStatus(orderId, "Processing", new[] { "New" }, null, "Заказ принят в работу");
    }

    public static void Receive(int orderId)
    {
        CurrentUser.Require("Administrator", "Manager", "User");
        ChangeStatus(orderId, "Completed", new[] { "Processing" }, CurrentUser.Id, "Клиент получил заказ");
    }

    public static void Cancel(int orderId)
    {
        CurrentUser.Require("Administrator", "Manager", "User");
        if (CurrentUser.IsUser)
        {
            ChangeStatus(orderId, "Cancelled", new[] { "New" }, CurrentUser.Id, "Заказ отменён клиентом");
        }
        else
        {
            ChangeStatus(orderId, "Cancelled", new[] { "New", "Processing" }, null, "Заказ отменён сотрудником");
        }
    }

    public static void AdminUpdate(int orderId, string status, string? comment)
    {
        CurrentUser.Require("Administrator");
        using NpgsqlConnection conn = Database.GetConnection();
        conn.Open();
        using NpgsqlTransaction tx = conn.BeginTransaction();
        (string oldStatus, string client) = ApplyStatus(conn, tx, orderId, status, null, null);
        Database.ExecuteTx(conn, tx, "UPDATE orders SET comment = @c WHERE id = @id", ("c", comment), ("id", orderId));
        tx.Commit();

        string details = "Администратор изменил заказ №" + orderId + " (клиент: " + client + ")";
        if (oldStatus != status)
        {
            details += "; статус «" + StatusTitle(oldStatus) + "» → «" + StatusTitle(status) + "»";
        }
        details += comment == null ? "; комментарий очищен" : "; комментарий: «" + comment + "»";
        Audit.Write("UPDATE", "orders", details);
    }

    public static void Delete(int orderId)
    {
        CurrentUser.Require("Administrator");
        using NpgsqlConnection conn = Database.GetConnection();
        conn.Open();
        using NpgsqlTransaction tx = conn.BeginTransaction();
        DataTable dt = Database.QueryTx(conn, tx,
            "SELECT o.status, u.full_name FROM orders o JOIN users u ON u.id = o.user_id WHERE o.id = @id FOR UPDATE OF o",
            ("id", orderId));
        if (dt.Rows.Count == 0)
        {
            throw new UserMessageException("Заказ не найден. Обновите таблицу.");
        }
        string status = dt.Rows[0]["status"].ToString() ?? "";
        string client = dt.Rows[0]["full_name"].ToString() ?? "";
        if (status == "New" || status == "Processing")
        {
            ChangeStock(conn, tx, orderId, 1);
        }
        Database.ExecuteTx(conn, tx, "DELETE FROM orders WHERE id = @id", ("id", orderId));
        tx.Commit();
        Audit.Write("DELETE", "orders", "Удалён заказ №" + orderId + " (клиент: " + client + ", статус «" + StatusTitle(status) + "»)");
    }

    public static void ShowItems(int orderId)
    {
        if (CurrentUser.IsUser)
        {
            object? owner = Database.Scalar("SELECT user_id FROM orders WHERE id = @id", ("id", orderId));
            if (owner == null || Convert.ToInt32(owner) != CurrentUser.Id)
            {
                throw new UserMessageException("Это не ваш заказ.");
            }
        }
        DataTable dt = Database.Query(
            "SELECT p.name, oi.quantity, oi.price_at_order FROM order_items oi JOIN products p ON p.id = oi.product_id WHERE oi.order_id = @id ORDER BY p.name",
            ("id", orderId));
        StringBuilder sb = new StringBuilder();
        decimal total = 0;
        foreach (DataRow row in dt.Rows)
        {
            int quantity = Convert.ToInt32(row[1]);
            decimal price = Convert.ToDecimal(row[2]);
            total += quantity * price;
            sb.AppendLine(row[0] + " × " + quantity + " = " + (quantity * price).ToString("N2"));
        }
        sb.AppendLine();
        sb.AppendLine("Итого: " + total.ToString("N2"));
        MessageBox.Show(sb.ToString(), "Состав заказа №" + orderId, MessageBoxButton.OK, MessageBoxImage.Information);
    }

    private static void ChangeStatus(int orderId, string newStatus, string[]? allowedOld, int? ownerId, string verb)
    {
        using NpgsqlConnection conn = Database.GetConnection();
        conn.Open();
        using NpgsqlTransaction tx = conn.BeginTransaction();
        (string oldStatus, string client) = ApplyStatus(conn, tx, orderId, newStatus, allowedOld, ownerId);
        tx.Commit();
        Audit.Write("UPDATE", "orders",
            verb + ": заказ №" + orderId + " (клиент: " + client + "), статус «" + StatusTitle(oldStatus) + "» → «" + StatusTitle(newStatus) + "»");
    }

    private static (string OldStatus, string Client) ApplyStatus(NpgsqlConnection conn, NpgsqlTransaction tx, int orderId, string newStatus, string[]? allowedOld, int? ownerId)
    {
        DataTable dt = Database.QueryTx(conn, tx,
            "SELECT o.status, o.user_id, u.full_name FROM orders o JOIN users u ON u.id = o.user_id WHERE o.id = @id FOR UPDATE OF o",
            ("id", orderId));
        if (dt.Rows.Count == 0)
        {
            throw new UserMessageException("Заказ не найден. Обновите таблицу.");
        }
        string oldStatus = dt.Rows[0]["status"].ToString() ?? "";
        int owner = Convert.ToInt32(dt.Rows[0]["user_id"]);
        string client = dt.Rows[0]["full_name"].ToString() ?? "";

        if (ownerId != null && owner != ownerId)
        {
            throw new UserMessageException("Это не ваш заказ.");
        }
        if (allowedOld != null && !allowedOld.Contains(oldStatus))
        {
            throw new UserMessageException("Это действие недоступно для заказа в статусе «" + StatusTitle(oldStatus) + "».");
        }
        if (oldStatus != newStatus)
        {
            if (newStatus == "Cancelled" && oldStatus != "Cancelled")
            {
                ChangeStock(conn, tx, orderId, 1);
            }
            else if (oldStatus == "Cancelled" && newStatus != "Cancelled")
            {
                ChangeStock(conn, tx, orderId, -1);
            }
            Database.ExecuteTx(conn, tx, "UPDATE orders SET status = @s WHERE id = @id", ("s", newStatus), ("id", orderId));
        }
        return (oldStatus, client);
    }

    private static void ChangeStock(NpgsqlConnection conn, NpgsqlTransaction tx, int orderId, int sign)
    {
        try
        {
            Database.ExecuteTx(conn, tx,
                "UPDATE products p SET quantity_in_stock = p.quantity_in_stock + (@sign * oi.quantity) FROM order_items oi WHERE oi.product_id = p.id AND oi.order_id = @o",
                ("sign", sign), ("o", orderId));
        }
        catch (PostgresException ex) when (ex.SqlState == "23514")
        {
            throw new UserMessageException("На складе не хватает товара, чтобы вернуть этот заказ в работу.");
        }
    }
}
