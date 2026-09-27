-- 1. Low-stock alert: products with stock <= 5 and category name. Order by stock ascending.
SELECT 
    p.name AS product_name,
    c.name AS category_name,
    p.stock
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.stock <= 5
ORDER BY p.stock ASC;

-- 2. Orders per customer: customer name + total spent (sum of quantity * unit_price_cents), highest first.
SELECT 
    c.name AS customer_name,
    COALESCE(SUM(oi.quantity * oi.unit_price_cents), 0) AS total_spent_cents
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id AND o.status != 'cancelled'
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY c.id, c.name
ORDER BY total_spent_cents DESC;

-- 3. Top 5 best-selling products in the last 30 days (by quantity sold). Show product name + units sold + revenue.
SELECT 
    p.name AS product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price_cents) AS revenue_cents
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
JOIN products p ON oi.product_id = p.id
WHERE o.placed_at >= CURRENT_TIMESTAMP - INTERVAL '30 days'
  AND o.status != 'cancelled'
GROUP BY p.id, p.name
ORDER BY units_sold DESC
LIMIT 5;

-- 4. Revenue by category for the last 30 days. Order highest first.
SELECT 
    c.name AS category_name,
    COALESCE(SUM(oi.quantity * oi.unit_price_cents), 0) AS total_revenue_cents
FROM categories c
JOIN products p ON c.id = p.category_id
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
WHERE o.placed_at >= CURRENT_TIMESTAMP - INTERVAL '30 days'
  AND o.status != 'cancelled'
GROUP BY c.id, c.name
ORDER BY total_revenue_cents DESC;

-- 5. Orders that have been 'pending' for more than 7 days
SELECT 
    o.id AS order_id,
    c.name AS customer_name,
    c.email,
    o.placed_at,
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE o.status = 'pending'
  AND o.placed_at < CURRENT_TIMESTAMP - INTERVAL '7 days'
ORDER BY o.placed_at ASC;
