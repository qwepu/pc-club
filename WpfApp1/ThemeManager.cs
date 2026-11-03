using System.IO;
using System.Windows;
using System.Windows.Media;

namespace CyberClubManager;

public static class ThemeManager
{
    public static bool IsDark { get; private set; }

    private static string FilePath => Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "CyberClubManager", "theme.txt");

    public static void Apply(bool dark)
    {
        IsDark = dark;
        Set("BgBrush", dark ? "#14161C" : "#F4F5F7");
        Set("SurfaceBrush", dark ? "#1E2128" : "#FFFFFF");
        Set("LineBrush", dark ? "#323744" : "#E3E5EA");
        Set("TextBrush", dark ? "#E8EAF0" : "#1F2430");
        Set("MutedBrush", dark ? "#9AA1B2" : "#6B7280");
        Set("AccentBrush", dark ? "#7C73FF" : "#4F46E5");
        Set("SelectBrush", dark ? "#2A2E4A" : "#EEF0FF");
        Set("HeaderBgBrush", dark ? "#252932" : "#F9FAFB");
        Set("GridLineBrush", dark ? "#2A2E38" : "#EEF0F3");
    }

    private static void Set(string key, string color)
    {
        Application.Current.Resources[key] = new SolidColorBrush((Color)ColorConverter.ConvertFromString(color));
    }

    public static void Load()
    {
        try
        {
            bool dark = File.Exists(FilePath) && File.ReadAllText(FilePath).Trim() == "dark";
            Apply(dark);
        }
        catch
        {
            Apply(false);
        }
    }

    public static void Save()
    {
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(FilePath)!);
            File.WriteAllText(FilePath, IsDark ? "dark" : "light");
        }
        catch
        {
        }
    }
}
