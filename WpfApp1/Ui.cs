using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace CyberClubManager;

public static class Ui
{
    public static Border StatCard(string title, string value)
    {
        Border card = new Border
        {
            Style = (Style)Application.Current.FindResource("Card"),
            Width = 220
        };
        StackPanel panel = new StackPanel();
        panel.Children.Add(new TextBlock
        {
            Text = title,
            Foreground = (Brush)Application.Current.FindResource("MutedBrush"),
            FontSize = 12
        });
        panel.Children.Add(new TextBlock
        {
            Text = value,
            FontSize = 26,
            FontWeight = FontWeights.Bold,
            Margin = new Thickness(0, 6, 0, 0)
        });
        card.Child = panel;
        return card;
    }
}
