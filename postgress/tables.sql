CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(200)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    login VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    role_id INT NOT NULL REFERENCES roles(id)
);

CREATE TABLE computers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    status BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT
);

CREATE TABLE tariffs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT
);

CREATE TABLE game_sessions (
    id SERIAL PRIMARY KEY,
    start_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    cost NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (cost >= 0),
    user_id INT NOT NULL REFERENCES users(id),
    computer_id INT NOT NULL REFERENCES computers(id),
    tariff_id INT NOT NULL REFERENCES tariffs(id),
    CHECK (end_time IS NULL OR end_time >= start_time)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'New'
        CHECK (status IN ('New', 'Processing', 'Completed', 'Cancelled')),
    comment TEXT,
    user_id INT NOT NULL REFERENCES users(id)
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    quantity_in_stock INT NOT NULL DEFAULT 0 CHECK (quantity_in_stock >= 0),
    is_available BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    action VARCHAR(20) NOT NULL
        CHECK (action IN ('CREATE', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT', 'REGISTER')),
    entity_name VARCHAR(100),
    user_id INT REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_order NUMERIC(10,2) NOT NULL CHECK (price_at_order >= 0),
    UNIQUE (order_id, product_id)
);

INSERT INTO roles (name, description) VALUES
    ('Administrator', 'Full system access'),
    ('Manager', 'Manage products, orders and game sessions'),
    ('User', 'Basic system access');