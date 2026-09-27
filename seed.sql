-- 1. Insert 5 Categories
INSERT INTO categories (name) VALUES
('Electronics'),
('Clothing'),
('Home & Kitchen'),
('Books'),
('Sports & Outdoors');

-- 2. Insert 50 Products (Includes 5 with stock = 0 and 5 with stock < 5)
INSERT INTO products (sku, name, category_id, price_cents, stock) VALUES
-- Electronics (1-10)
('ELE-001', 'Wireless Mouse', 1, 2500, 0),    -- Stock = 0
('ELE-002', 'Mechanical Keyboard', 1, 8999, 2),-- Stock < 5
('ELE-003', 'USB-C Cable', 1, 1299, 50),
('ELE-004', 'Bluetooth Headphones', 1, 5999, 15),
('ELE-005', 'HD Monitor', 1, 14999, 8),
('ELE-006', 'Webcam 1080p', 1, 3999, 0),      -- Stock = 0
('ELE-007', 'Portable Speaker', 1, 4500, 3),  -- Stock < 5
('ELE-008', 'Phone Stand', 1, 1500, 25),
('ELE-009', 'External Hard Drive', 1, 7999, 12),
('ELE-010', 'Smartwatch', 1, 19999, 6),

-- Clothing (11-20)
('CLO-001', 'Cotton T-Shirt', 2, 1999, 100),
('CLO-002', 'Denim Jeans', 2, 4999, 0),       -- Stock = 0
('CLO-003', 'Hoodie', 2, 3999, 4),            -- Stock < 5
('CLO-004', 'Running Shoes', 2, 7999, 20),
('CLO-005', 'Socks (5-Pack)', 2, 1200, 60),
('CLO-006', 'Winter Coat', 2, 12999, 7),
('CLO-007', 'Baseball Cap', 2, 1500, 18),
('CLO-008', 'Leather Belt', 2, 2500, 30),
('CLO-009', 'Sweatpants', 2, 3499, 1),        -- Stock < 5
('CLO-010', 'Scarf', 2, 1800, 15),

-- Home & Kitchen (21-30)
('HOM-001', 'Coffee Maker', 3, 4999, 10),
('HOM-002', 'Stainless Steel Water Bottle', 3, 1999, 40),
('HOM-003', 'Blender', 3, 3999, 0),          -- Stock = 0
('HOM-004', 'Chef Knife', 3, 2999, 14),
('HOM-005', 'Cutting Board', 3, 1500, 22),
('HOM-006', 'Toaster', 3, 2499, 9),
('HOM-007', 'Non-stick Frying Pan', 3, 3499, 11),
('HOM-008', 'Desk Lamp', 3, 2299, 3),         -- Stock < 5
('HOM-009', 'Bed Sheet Set', 3, 5999, 16),
('HOM-010', 'Throw Pillow', 3, 1299, 25),

-- Books (31-40)
('BOK-001', 'SQL Database Guide', 4, 3500, 50),
('BOK-002', 'Python Basics', 4, 2999, 0),      -- Stock = 0
('BOK-003', 'Algorithms & Data Structures', 4, 4500, 12),
('BOK-004', 'Web Development Handbook', 4, 3800, 30),
('BOK-005', 'Sci-Fi Novel', 4, 1499, 80),
('BOK-006', 'Biography of Tech Leaders', 4, 2200, 15),
('BOK-007', 'Cookbook Essentials', 4, 2750, 19),
('BOK-008', 'History of Computing', 4, 3200, 8),
('BOK-009', 'Design Patterns', 4, 4200, 25),
('BOK-010', 'Fantasy Trilogy Vol 1', 4, 1899, 40),

-- Sports & Outdoors (41-50)
('SPO-001', 'Yoga Mat', 5, 2500, 35),
('SPO-002', 'Dumbbell Set 10lbs', 5, 4500, 8),
('SPO-003', 'Bicycle Helmet', 5, 3999, 14),
('SPO-004', 'Resistance Bands', 5, 1299, 45),
('SPO-005', 'Camping Tent', 5, 8999, 6),
('SPO-006', 'Hiking Backpack', 5, 6500, 10),
('SPO-007', 'Soccer Ball', 5, 1999, 20),
('SPO-008', 'Tennis Racket', 5, 5500, 7),
('SPO-009', 'Jump Rope', 5, 899, 50),
('SPO-010', 'Waterproof Flashlight', 5, 1499, 18);

-- 3. Insert 30 Customers
INSERT INTO customers (name, email, created_at)
SELECT 
    'Customer ' || i,
    'customer' || i || '@example.com',
    CURRENT_TIMESTAMP - (i || ' days')::INTERVAL
FROM generate_series(1, 30) AS i;

-- 4. Insert 100 Orders over last 90 days with randomized status
INSERT INTO orders (customer_id, placed_at, status)
SELECT 
    ((i % 30) + 1) AS customer_id,
    CURRENT_TIMESTAMP - ((i * 0.85) || ' days')::INTERVAL - ((i * 3) || ' hours')::INTERVAL AS placed_at,
    (ARRAY['pending', 'paid', 'shipped', 'cancelled'])[((i % 4) + 1)] AS status
FROM generate_series(1, 100) AS i;

-- 5. Insert 250 Order Items (Each order gets 1 to 5 line items)
INSERT INTO order_items (order_id, product_id, quantity, unit_price_cents)
SELECT 
    o.id AS order_id,
    p.id AS product_id,
    ((o.id + p.id) % 3) + 1 AS quantity,
    p.price_cents AS unit_price_cents
FROM orders o
JOIN products p ON p.id = ((o.id * 7 + 3) % 50) + 1;

-- Add supplementary order items to reach ~250 items total
INSERT INTO order_items (order_id, product_id, quantity, unit_price_cents)
SELECT 
    o.id AS order_id,
    p.id AS product_id,
    ((o.id * 2 + p.id) % 2) + 1 AS quantity,
    p.price_cents AS unit_price_cents
FROM orders o
JOIN products p ON p.id = ((o.id * 3 + 11) % 50) + 1;

INSERT INTO order_items (order_id, product_id, quantity, unit_price_cents)
SELECT 
    o.id AS order_id,
    p.id AS product_id,
    1 AS quantity,
    p.price_cents AS unit_price_cents
FROM orders o
JOIN products p ON p.id = ((o.id * 13 + 5) % 50) + 1
WHERE o.id % 2 = 0;
