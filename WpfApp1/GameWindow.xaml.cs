using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace CyberClubManager;

public partial class GameWindow : Window
{
    private const int Cells = 20;
    private const int CellSize = 20;

    private readonly DispatcherTimer timer = new DispatcherTimer();
    private readonly Random random = new Random();
    private List<(int X, int Y)> snake = new();
    private (int X, int Y) food;
    private (int X, int Y) direction;
    private (int X, int Y) nextDirection;
    private int score;
    private bool running;

    public GameWindow()
    {
        InitializeComponent();
        timer.Tick += (s, e) => Step();
        Closed += (s, e) => timer.Stop();
        StartGame();
    }

    private void StartGame()
    {
        snake = new List<(int X, int Y)> { (10, 10), (9, 10), (8, 10) };
        direction = (1, 0);
        nextDirection = (1, 0);
        score = 0;
        running = true;
        PlaceFood();
        timer.Interval = TimeSpan.FromMilliseconds(130);
        timer.Start();
        Draw();
    }

    private void PlaceFood()
    {
        do
        {
            food = (random.Next(Cells), random.Next(Cells));
        }
        while (snake.Contains(food));
    }

    private void Step()
    {
        direction = nextDirection;
        var head = (X: snake[0].X + direction.X, Y: snake[0].Y + direction.Y);

        if (head.X < 0 || head.Y < 0 || head.X >= Cells || head.Y >= Cells || snake.Contains(head))
        {
            GameOver();
            return;
        }

        snake.Insert(0, head);
        if (head == food)
        {
            score++;
            PlaceFood();
            timer.Interval = TimeSpan.FromMilliseconds(Math.Max(60, timer.Interval.TotalMilliseconds - 3));
        }
        else
        {
            snake.RemoveAt(snake.Count - 1);
        }
        Draw();
    }

    private void GameOver()
    {
        timer.Stop();
        running = false;
        ScoreText.Text = "Игра окончена. Счёт: " + score + ". Пробел — заново";
    }

    private void Draw()
    {
        GameCanvas.Children.Clear();
        AddCell(food.X, food.Y, Brushes.Crimson);
        for (int i = 0; i < snake.Count; i++)
        {
            Brush brush = i == 0 ? Brushes.Indigo : (Brush)FindResource("AccentBrush");
            AddCell(snake[i].X, snake[i].Y, brush);
        }
        ScoreText.Text = "Счёт: " + score;
    }

    private void AddCell(int x, int y, Brush brush)
    {
        Rectangle cell = new Rectangle
        {
            Width = CellSize - 2,
            Height = CellSize - 2,
            RadiusX = 4,
            RadiusY = 4,
            Fill = brush
        };
        Canvas.SetLeft(cell, x * CellSize + 1);
        Canvas.SetTop(cell, y * CellSize + 1);
        GameCanvas.Children.Add(cell);
    }

    private void Window_KeyDown(object sender, KeyEventArgs e)
    {
        switch (e.Key)
        {
            case Key.Up:
            case Key.W:
                if (direction.Y == 0) nextDirection = (0, -1);
                break;
            case Key.Down:
            case Key.S:
                if (direction.Y == 0) nextDirection = (0, 1);
                break;
            case Key.Left:
            case Key.A:
                if (direction.X == 0) nextDirection = (-1, 0);
                break;
            case Key.Right:
            case Key.D:
                if (direction.X == 0) nextDirection = (1, 0);
                break;
            case Key.Space:
            case Key.Enter:
                if (!running) StartGame();
                break;
            case Key.Escape:
                Close();
                break;
        }
    }
}
