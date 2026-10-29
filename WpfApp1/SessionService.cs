using System.Data;
using Npgsql;

namespace CyberClubManager;

public static class SessionService
{
    public static void Start(int userId, int computerId, int tariffId)
    {
        CurrentUser.Require("Administrator", "Manager", "User");
        if (CurrentUser.IsUser && userId != CurrentUser.Id)
        {
            throw new UserMessageException("Вы можете начать сеанс только для себя.");
        }
        using NpgsqlConnection conn = Database.GetConnection();
        conn.Open();
        using NpgsqlTransaction tx = conn.BeginTransaction();

        object? available = Database.ScalarTx(conn, tx, "SELECT status FROM computers WHERE id = @c FOR UPDATE", ("c", computerId));
        if (available == null || !(bool)available)
        {
            throw new UserMessageException("Этот компьютер сейчас недоступен.");
        }
        object? busy = Database.ScalarTx(conn, tx, "SELECT COUNT(*) FROM game_sessions WHERE computer_id = @c AND end_time IS NULL", ("c", computerId));
        if (Convert.ToInt64(busy) > 0)
        {
            throw new UserMessageException("На этом компьютере уже идёт сеанс.");
        }
        object? active = Database.ScalarTx(conn, tx, "SELECT is_active FROM tariffs WHERE id = @t", ("t", tariffId));
        if (active == null || !(bool)active)
        {
            throw new UserMessageException("Этот тариф сейчас не действует.");
        }
        Database.ExecuteTx(conn, tx,
            "INSERT INTO game_sessions (user_id, computer_id, tariff_id) VALUES (@u, @c, @t)",
            ("u", userId), ("c", computerId), ("t", tariffId));

        DataTable info = Database.QueryTx(conn, tx,
            "SELECT (SELECT full_name FROM users WHERE id = @u) AS client, (SELECT name FROM computers WHERE id = @c) AS computer, (SELECT name FROM tariffs WHERE id = @t) AS tariff",
            ("u", userId), ("c", computerId), ("t", tariffId));
        tx.Commit();

        DataRow row = info.Rows[0];
        Audit.Write("CREATE", "game_sessions",
            "Начат сеанс: клиент " + row["client"] + ", компьютер " + row["computer"] + ", тариф «" + row["tariff"] + "»");
    }

    public static void Finish(int sessionId)
    {
        CurrentUser.Require("Administrator", "Manager", "User");
        object? owner = Database.Scalar("SELECT user_id FROM game_sessions WHERE id = @id", ("id", sessionId));
        if (owner == null)
        {
            throw new UserMessageException("Сеанс не найден. Обновите таблицу.");
        }
        if (CurrentUser.IsUser && Convert.ToInt32(owner) != CurrentUser.Id)
        {
            throw new UserMessageException("Вы можете завершать только свои сеансы.");
        }
        int rows = Database.Execute(
            "UPDATE game_sessions s SET end_time = CURRENT_TIMESTAMP, cost = t.price FROM tariffs t WHERE t.id = s.tariff_id AND s.id = @id AND s.end_time IS NULL",
            ("id", sessionId));
        if (rows == 0)
        {
            throw new UserMessageException("Этот сеанс уже завершён.");
        }

        DataTable info = Database.Query(
            "SELECT u.full_name, c.name AS computer, s.cost FROM game_sessions s JOIN users u ON u.id = s.user_id JOIN computers c ON c.id = s.computer_id WHERE s.id = @id",
            ("id", sessionId));
        DataRow row = info.Rows[0];
        Audit.Write("UPDATE", "game_sessions",
            "Завершён сеанс №" + sessionId + ": клиент " + row["full_name"] + ", компьютер " + row["computer"] + ", стоимость " + Convert.ToDecimal(row["cost"]).ToString("N2"));
    }
}
