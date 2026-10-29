# CyberClub Manager

WPF (C#, .NET 10) + PostgreSQL. Учебный проект.

## Запуск
1. Запусти PostgreSQL (Docker) с базой из SQL-файлов проекта (таблицы + cyberclub_test_data.sql).
2. В файле appsettings.json впиши свой пароль вместо YOUR_PASSWORD (файл в .gitignore, в Git не попадёт).
3. Открой CyberClubManager.csproj в Visual Studio, дождись восстановления NuGet-пакетов (Npgsql, ClosedXML, QuestPDF), нажми ▶.

## Тестовые аккаунты (создаются автоматически при первом запуске)
| Логин | Пароль | Роль |
|---|---|---|
| admin | Admin123! | Администратор |
| manager | Manager123! | Менеджер |
| user | User123! | Пользователь |

Пользователи из тестовых данных (user1...user100) имеют ненастоящие хеши, войти под ними нельзя.

## Структура
- Database.cs: подключение и параметризованные запросы (защита от SQL-инъекций)
- Security.cs: хеширование паролей (PBKDF2 + соль)
- CurrentUser.cs: текущий пользователь и проверка роли
- Audit.cs: запись в журнал действий
- OrderService.cs, SessionService.cs: бизнес-логика заказов и сеансов (транзакции, проверка прав)
- PageConfigs.cs: описание всех разделов (SQL, поиск, фильтры, сортировка, поля форм, кнопки по ролям)
- CrudPage: универсальный экран таблицы; EditWindow: универсальная форма с проверкой данных
- LoginWindow, RegisterWindow, MainWindow, OrderCreateWindow, ReportsPage
- Reports.cs: SQL отчётов и экспорт в Excel (ClosedXML) и PDF (QuestPDF)
