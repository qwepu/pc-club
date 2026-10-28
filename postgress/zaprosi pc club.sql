SELECT u.id, u.login, u.password_hash, u.full_name, r.name AS role
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE u.login = 'user5';

SELECT COUNT(*) FROM users WHERE login = 'newuser';

INSERT INTO users (login, password_hash, full_name, email, role_id)
VALUES ('newuser', 'test_hash_new', 'Новиков Павел', 'new@cyberclub.test',
        (SELECT id FROM roles WHERE name = 'User'));

SELECT u.id, u.login, u.full_name, u.email, r.name AS role
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE u.login ILIKE '%иван%'
   OR u.full_name ILIKE '%иван%'
   OR u.email ILIKE '%иван%';

SELECT u.id, u.login, u.full_name, r.name AS role
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE r.name = 'Manager'
  AND u.full_name ILIKE '%петров%';

SELECT u.id, u.login, u.full_name, u.email, r.name AS role
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE (u.login ILIKE '%user%' OR u.full_name ILIKE '%user%' OR u.email ILIKE '%user%')
  AND r.name = 'User'
ORDER BY r.name ASC, u.full_name ASC;

UPDATE users
SET full_name = 'Новиков Павел Игоревич',
    email = 'novikov@cyberclub.test',
    role_id = (SELECT id FROM roles WHERE name = 'Manager')
WHERE login = 'newuser';

DELETE FROM users WHERE login = 'newuser';

SELECT id, name, status, description
FROM computers
WHERE (name ILIKE '%PC-0%' OR description ILIKE '%PC-0%')
  AND status = TRUE
ORDER BY name ASC;

INSERT INTO computers (name, status, description)
VALUES ('PC-101', TRUE, 'Новый игровой компьютер');

UPDATE computers
SET status = FALSE, description = 'На обслуживании'
WHERE name = 'PC-101';

DELETE FROM computers WHERE name = 'PC-101';

SELECT c.id, c.name
FROM computers c
WHERE c.status = TRUE
  AND NOT EXISTS (
      SELECT 1 FROM game_sessions s
      WHERE s.computer_id = c.id AND s.end_time IS NULL
  )
ORDER BY c.name;

SELECT id, name, price, is_active, description
FROM tariffs
WHERE (name ILIKE '%VIP%' OR description ILIKE '%VIP%')
  AND is_active = TRUE
  AND price BETWEEN 100 AND 1000
ORDER BY price DESC, name ASC;

INSERT INTO tariffs (name, price, is_active, description)
VALUES ('Тестовый тариф', 150.00, TRUE, 'Тариф для проверки');

UPDATE tariffs
SET price = 200.00, is_active = FALSE
WHERE name = 'Тестовый тариф';

DELETE FROM tariffs WHERE name = 'Тестовый тариф';

SELECT id, name, category, price, quantity_in_stock, is_available
FROM products
WHERE (name ILIKE '%кола%' OR category ILIKE '%кола%')
   OR (category = 'Напитки' AND is_available = TRUE AND price <= 100)
ORDER BY category ASC, price ASC, name ASC;

SELECT id, name, category, price, quantity_in_stock
FROM products
WHERE category = 'Напитки'
  AND is_available = TRUE
  AND price BETWEEN 30 AND 120
ORDER BY price ASC, name ASC;

INSERT INTO products (name, category, price, quantity_in_stock, is_available)
VALUES ('Тестовый товар', 'Снеки', 99.00, 10, TRUE);

UPDATE products
SET price = 120.00, quantity_in_stock = 25
WHERE name = 'Тестовый товар';

DELETE FROM products WHERE name = 'Тестовый товар';

SELECT s.id, u.full_name, c.name AS computer, t.name AS tariff,
       s.start_time, s.end_time, s.cost
FROM game_sessions s
JOIN users u ON u.id = s.user_id
JOIN computers c ON c.id = s.computer_id
JOIN tariffs t ON t.id = s.tariff_id
WHERE (u.full_name ILIKE '%иван%' OR c.name ILIKE '%PC-00%')
  AND s.start_time >= NOW() - INTERVAL '30 days'
ORDER BY s.start_time DESC, c.name ASC;

INSERT INTO game_sessions (user_id, computer_id, tariff_id)
VALUES (4, 1, 1);

SELECT s.id, c.name AS computer, u.full_name, s.start_time
FROM game_sessions s
JOIN computers c ON c.id = s.computer_id
JOIN users u ON u.id = s.user_id
WHERE s.end_time IS NULL;

UPDATE game_sessions s
SET end_time = NOW(), cost = t.price
FROM tariffs t
WHERE t.id = s.tariff_id
  AND s.computer_id = 1
  AND s.end_time IS NULL;

DELETE FROM game_sessions
WHERE computer_id = 1 AND user_id = 4 AND tariff_id = 1
  AND start_time >= NOW() - INTERVAL '1 day'
  AND id > 100;

WITH new_order AS (
    INSERT INTO orders (comment, user_id)VALUES ('Заказ из приложения', 14)
    RETURNING id
)
INSERT INTO order_items (order_id, product_id, quantity, price_at_order)
SELECT new_order.id, p.id, 2, p.price
FROM new_order, products p
WHERE p.id = 5;

SELECT o.id, o.created_at, o.status, o.comment, u.full_name
FROM orders o
JOIN users u ON u.id = o.user_id
WHERE o.status = 'New'
ORDER BY o.created_at ASC;

UPDATE orders SET status = 'Processing' WHERE id = 101 AND status = 'New';

UPDATE products p
SET quantity_in_stock = p.quantity_in_stock - oi.quantity
FROM order_items oi
WHERE oi.product_id = p.id AND oi.order_id = 101;

UPDATE order_items SET quantity = 3 WHERE order_id = 101 AND product_id = 5;

UPDATE orders SET comment = 'Изменено администратором' WHERE id = 101;

UPDATE orders SET status = 'Completed' WHERE id = 101 AND status = 'Processing';

UPDATE orders SET status = 'Cancelled' WHERE id = 101 AND status IN ('New', 'Processing');

SELECT o.id, o.created_at, o.status, p.name AS product, oi.quantity, oi.price_at_order,
       oi.quantity * oi.price_at_order AS line_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
WHERE o.user_id = 14
ORDER BY o.created_at DESC;

SELECT o.id, o.status, SUM(oi.quantity * oi.price_at_order) AS order_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, o.status
ORDER BY o.id;

DELETE FROM orders WHERE id = 101;

INSERT INTO audit_logs (action, entity_name, user_id, details)
VALUES ('UPDATE', 'orders', 2, 'Менеджер принял заказ');

SELECT l.id, l.created_at, l.action, l.entity_name, u.login, l.details
FROM audit_logs l
LEFT JOIN users u ON u.id = l.user_id
WHERE l.action = 'UPDATE'
  AND l.created_at >= NOW() - INTERVAL '7 days'
ORDER BY l.created_at DESC;

SELECT t.name AS tariff, COUNT(*) AS sessions_count, SUM(s.cost) AS total_cost
FROM game_sessions s
JOIN tariffs t ON t.id = s.tariff_id
GROUP BY t.name
ORDER BY total_cost DESC;

SELECT DATE_TRUNC('month', start_time)::date AS month,
       COUNT(*) AS sessions_count,
       SUM(cost) AS revenue
FROM game_sessions
GROUP BY DATE_TRUNC('month', start_time)
ORDER BY month;

SELECT c.name AS computer, COUNT(s.id) AS sessions_count
FROM computers c
LEFT JOIN game_sessions s ON s.computer_id = c.id
GROUP BY c.name
ORDER BY sessions_count DESC, c.name ASC
LIMIT 10;

SELECT p.name AS product, SUM(oi.quantity) AS sold,
       SUM(oi.quantity * oi.price_at_order) AS total
FROM order_items oi
JOIN products p ON p.id = oi.product_id
JOIN orders o ON o.id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.name
ORDER BY total DESC
LIMIT 10;

SELECT status, COUNT(*) AS orders_count
FROM orders
GROUP BY status
ORDER BY orders_count DESC;

SELECT r.name AS role, COUNT(u.id) AS users_count
FROM roles r
LEFT JOIN users u ON u.role_id = r.id
GROUP BY r.name
ORDER BY r.name;