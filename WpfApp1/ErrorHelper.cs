using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using Npgsql;

namespace CyberClubManager;

public static class ErrorHelper
{
    public static string GetMessage(Exception ex)
    {
        if (ex is UserMessageException)
        {
            return ex.Message;
        }
        if (ex is PostgresException pg)
        {
            switch (pg.SqlState)
            {
                case "23505":
                    return "Такая запись уже существует: значение должно быть уникальным (например, логин или название).";
                case "23503":
                    return "Операция невозможна: запись связана с другими данными (например, у неё есть сеансы или заказы).";
                case "23514":
                    return "Введённое значение недопустимо (например, отрицательная цена или неверный статус).";
                case "23502":
                    return "Не заполнено обязательное поле.";
                case "22001":
                    return "Слишком длинное значение в одном из полей.";
            }
            return "Ошибка базы данных: " + pg.MessageText;
        }
        if (ex is NpgsqlException || ex is System.Net.Sockets.SocketException)
        {
            return "Нет подключения к базе данных. Проверьте, что PostgreSQL (Docker) запущен и данные в appsettings.json верны.";
        }
        if (ex is FileNotFoundException)
        {
            return "Не найден файл appsettings.json с настройками подключения к базе.";
        }
        return "Произошла ошибка: " + ex.Message;
    }

    public static void Show(Exception ex)
    {
        MessageBox.Show(GetMessage(ex), "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
    }
}

public static class GridHelper
{
    public static void Format(DataGridAutoGeneratingColumnEventArgs e)
    {
        if (e.Column is DataGridTextColumn column && column.Binding is Binding binding)
        {
            if (e.PropertyType == typeof(DateTime))
            {
                binding.StringFormat = "dd.MM.yyyy HH:mm";
            }
            else if (e.PropertyType == typeof(decimal))
            {
                binding.StringFormat = "N2";
            }
        }
    }
}
