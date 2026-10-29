using System.Data;
using System.IO;
using System.Text.Json;
using Npgsql;

namespace CyberClubManager;

public static class Database
{
    private static string? connectionString;

    public static NpgsqlConnection GetConnection()
    {
        if (connectionString == null)
        {
            string path = Path.Combine(AppContext.BaseDirectory, "appsettings.json");
            string json = File.ReadAllText(path);
            using JsonDocument doc = JsonDocument.Parse(json);
            connectionString = doc.RootElement.GetProperty("ConnectionString").GetString();
        }
        return new NpgsqlConnection(connectionString);
    }

    private static void AddParams(NpgsqlCommand cmd, (string Name, object? Value)[] parameters)
    {
        foreach (var p in parameters)
        {
            cmd.Parameters.AddWithValue(p.Name, p.Value ?? DBNull.Value);
        }
    }

    public static DataTable Query(string sql, params (string Name, object? Value)[] parameters)
    {
        using NpgsqlConnection conn = GetConnection();
        conn.Open();
        using NpgsqlCommand cmd = new NpgsqlCommand(sql, conn);
        AddParams(cmd, parameters);
        using NpgsqlDataReader reader = cmd.ExecuteReader();
        DataTable table = new DataTable();
        table.Load(reader);
        return table;
    }

    public static int Execute(string sql, params (string Name, object? Value)[] parameters)
    {
        using NpgsqlConnection conn = GetConnection();
        conn.Open();
        using NpgsqlCommand cmd = new NpgsqlCommand(sql, conn);
        AddParams(cmd, parameters);
        return cmd.ExecuteNonQuery();
    }

    public static object? Scalar(string sql, params (string Name, object? Value)[] parameters)
    {
        using NpgsqlConnection conn = GetConnection();
        conn.Open();
        using NpgsqlCommand cmd = new NpgsqlCommand(sql, conn);
        AddParams(cmd, parameters);
        object? result = cmd.ExecuteScalar();
        return result == DBNull.Value ? null : result;
    }

    public static DataTable QueryTx(NpgsqlConnection conn, NpgsqlTransaction tx, string sql, params (string Name, object? Value)[] parameters)
    {
        using NpgsqlCommand cmd = new NpgsqlCommand(sql, conn, tx);
        AddParams(cmd, parameters);
        using NpgsqlDataReader reader = cmd.ExecuteReader();
        DataTable table = new DataTable();
        table.Load(reader);
        return table;
    }

    public static int ExecuteTx(NpgsqlConnection conn, NpgsqlTransaction tx, string sql, params (string Name, object? Value)[] parameters)
    {
        using NpgsqlCommand cmd = new NpgsqlCommand(sql, conn, tx);
        AddParams(cmd, parameters);
        return cmd.ExecuteNonQuery();
    }

    public static object? ScalarTx(NpgsqlConnection conn, NpgsqlTransaction tx, string sql, params (string Name, object? Value)[] parameters)
    {
        using NpgsqlCommand cmd = new NpgsqlCommand(sql, conn, tx);
        AddParams(cmd, parameters);
        object? result = cmd.ExecuteScalar();
        return result == DBNull.Value ? null : result;
    }

    public static void EnsureDemoAccounts()
    {
        CreateAccount("admin", "Admin123!", "Администратор системы", "admin@cyberclub.local", "Administrator");
        CreateAccount("manager", "Manager123!", "Менеджер клуба", "manager@cyberclub.local", "Manager");
        CreateAccount("user", "User123!", "Тестовый пользователь", "user@cyberclub.local", "User");
    }

    private static void CreateAccount(string login, string password, string fullName, string email, string role)
    {
        object? exists = Scalar("SELECT id FROM users WHERE login = @l", ("l", login));
        if (exists != null)
        {
            return;
        }
        object? roleId = Scalar("SELECT id FROM roles WHERE name = @r", ("r", role));
        if (roleId == null)
        {
            throw new UserMessageException("В таблице roles нет роли " + role + ". Сначала выполните SQL-скрипт создания таблиц.");
        }
        Execute(
            "INSERT INTO users (login, password_hash, full_name, email, role_id) VALUES (@l, @p, @f, @e, @r)",
            ("l", login), ("p", Security.HashPassword(password)), ("f", fullName), ("e", email), ("r", roleId));
    }
}
