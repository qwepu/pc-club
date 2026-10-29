namespace CyberClubManager;

public static class CurrentUser
{
    public static int Id { get; private set; }
    public static string Login { get; private set; } = "";
    public static string FullName { get; private set; } = "";
    public static string Role { get; private set; } = "";

    public static bool IsAdmin => Role == "Administrator";
    public static bool IsManager => Role == "Manager";
    public static bool IsUser => Role == "User";

    public static string RoleTitle => Role switch
    {
        "Administrator" => "Администратор",
        "Manager" => "Менеджер",
        "User" => "Пользователь",
        _ => Role
    };

    public static void Set(int id, string login, string fullName, string role)
    {
        Id = id;
        Login = login;
        FullName = fullName;
        Role = role;
    }

    public static void Clear()
    {
        Id = 0;
        Login = "";
        FullName = "";
        Role = "";
    }

    public static void Require(params string[] roles)
    {
        if (!roles.Contains(Role))
        {
            throw new UserMessageException("Недостаточно прав для этого действия.");
        }
    }
}
