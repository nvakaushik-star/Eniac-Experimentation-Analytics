USE magist;

# (3) There is a sudden drop in sales since September 2018; 
# (9) Tech-product categories (roughly): audio, consoles_games, electronics, computers_accessories, pc_gamer, computers, table_printing_image, telephony; 
# (10) Around 15.03% of all products sold are tech or tech-adjacent.
# (12) Only 2.24% of all the past customers ordered expensive (85th price ranking percentile and up) tech products.
# (15) Tech earnings: 1,836,059.80 €, 13.51% of the total earnings.
# (16) In average a tech seller earns 792.09 € montly, which is below the mean (826.28 €) among all sellers.
# (18) On time: 89.15%; Delayed: 7.87%
# (19) Seems like the weight of an order does not have much influence on whether or not it's delivered on time.
# --------------------------------------------------------------------------------------------------------------------------------------------------------

# 1. How many orders are there in the dataset?
SELECT COUNT(order_id) AS order_count
FROM orders;

# 2. Are orders actually delivered?
SELECT 
    order_status,
    COUNT(order_id) AS order_count,
    ROUND(100 * COUNT(order_id) / (SELECT COUNT(order_id) FROM orders), 2) AS order_count_pot
FROM orders
GROUP BY order_status;

# 3. Is Magist having user growth?
SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

# 4. How many products are there on the products table?
SELECT COUNT(DISTINCT product_id) AS products_count
FROM products;

# 5. Which are the categories with the most products?
SELECT 
    pt.product_category_name_english,
    COUNT(DISTINCT p.product_id) AS product_count
FROM product_category_name_translation pt
JOIN products p USING (product_category_name)
GROUP BY pt.product_category_name_english
ORDER BY product_count DESC
LIMIT 5;

# 6. How many of those products were present in actual transactions?
SELECT ROUND(100 * COUNT(DISTINCT oi.product_id) / (SELECT COUNT(DISTINCT product_id) FROM products), 2) AS active_prod_pot
FROM order_items oi
JOIN products p USING (product_id);

# 7. What’s the price for the most expensive and cheapest products?
SELECT MAX(price) AS max_price, MIN(price) AS min_price
FROM order_items;

# 8. What are the highest and lowest payment values?
SELECT MAX(payment_value) AS max_payment, MIN(payment_value) AS min_payment
FROM order_payments;

# 9. What categories of tech products does Magist have?
SELECT DISTINCT pt.product_category_name_english
FROM product_category_name_translation pt
JOIN products p USING (product_category_name)
WHERE pt.product_category_name_english LIKE '%computer%'
   OR pt.product_category_name_english LIKE '%pc%'
   OR pt.product_category_name_english LIKE '%phon%'
   OR pt.product_category_name_english LIKE '%electr%'
   OR pt.product_category_name_english LIKE '%consoles%'
   OR pt.product_category_name_english LIKE '%audio%'
   OR pt.product_category_name_english LIKE '%tablet%';

# 10. How many products of these tech categories have been sold and what percentage do they represent?
SELECT 
    COUNT(oi.product_id) AS tech_products_sold,
    ROUND(100 * COUNT(oi.product_id) / (SELECT COUNT(product_id) FROM order_items), 2) AS tech_products_sold_pot
FROM product_category_name_translation pt
JOIN products p USING (product_category_name)
JOIN order_items oi USING (product_id)
WHERE pt.product_category_name_english IN (
    'audio','consoles_games','electronics','computers_accessories',
    'pc_gamer','computers','tablets_printing_image','telephony'
);

SELECT COUNT(product_id) AS total_products_sold
FROM order_items;

# 11. What’s the average price of the products being sold?
SELECT AVG(price) AS avg_price
FROM order_items;

# 12. Are expensive tech products popular?
WITH ranked AS (
    SELECT 
        pt.product_category_name_english,
        oi.order_id,
        CUME_DIST() OVER (ORDER BY oi.price) AS cd
    FROM product_category_name_translation pt
    JOIN products p USING (product_category_name)
    JOIN order_items oi USING (product_id)
    WHERE pt.product_category_name_english IN (
        'audio','consoles_games','electronics','computers_accessories',
        'pc_gamer','computers','tablets_printing_image','telephony'
    )
)
SELECT 
    CASE
        WHEN cd >= 0.85 THEN 'High'
        WHEN cd >= 0.5 THEN 'Medium'
        ELSE 'Low'
    END AS price_category,
    COUNT(DISTINCT o.customer_id) AS customers_count,
    ROUND(100 * COUNT(DISTINCT o.customer_id) / (SELECT COUNT(DISTINCT customer_id) FROM orders), 2) AS customer_count_pot
FROM ranked
JOIN orders o USING (order_id)
GROUP BY price_category;

# 13. How many months of data are included in the Magist database?
SELECT COUNT(DISTINCT CONCAT(YEAR(order_purchase_timestamp), '-', MONTH(order_purchase_timestamp))) AS months_count
FROM orders;

# 14. How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
SELECT COUNT(DISTINCT seller_id) AS sellers_count
FROM sellers;

WITH sellers_categories AS (
    SELECT s.seller_id, pt.product_category_name_english
    FROM sellers s
    JOIN order_items oi USING (seller_id)
    JOIN products p USING (product_id)
    JOIN product_category_name_translation pt USING (product_category_name)
)
SELECT 
    COUNT(DISTINCT seller_id) AS tech_sellers_count,
    ROUND(100 * COUNT(DISTINCT seller_id) / (SELECT COUNT(DISTINCT seller_id) FROM sellers), 2) AS tech_sellers_pot
FROM sellers_categories
WHERE product_category_name_english IN (
    'audio','consoles_games','electronics','computers_accessories',
    'pc_gamer','computers','tablets_printing_image','telephony'
);

# 15. What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
SELECT SUM(price) AS total_earnings
FROM order_items;

WITH prices_tech AS (
    SELECT oi.price, pt.product_category_name_english
    FROM sellers s
    JOIN order_items oi USING (seller_id)
    JOIN products p USING (product_id)
    JOIN product_category_name_translation pt USING (product_category_name)
    WHERE pt.product_category_name_english IN (
        'audio','consoles_games','electronics','computers_accessories',
        'pc_gamer','computers','tablets_printing_image','telephony'
    )
)
SELECT 
    SUM(price) AS tech_earnings,
    ROUND(100 * SUM(price) / (SELECT SUM(price) FROM order_items), 2) AS tech_earnings_pot
FROM prices_tech;

# 16a. Average monthly income of all sellers
WITH seller_month_income AS (
    SELECT 
        s.seller_id,
        CONCAT(YEAR(o.order_approved_at), '-', MONTH(o.order_approved_at)) AS ym,
        SUM(oi.price) AS income_month
    FROM sellers s
    JOIN order_items oi USING (seller_id)
    JOIN orders o USING (order_id)
    GROUP BY s.seller_id, ym
)
SELECT AVG(income_month) AS avg_monthly_income_per_seller
FROM seller_month_income;

# 16b. Average monthly income of Tech sellers
WITH seller_month_income_tech AS (
    SELECT 
        s.seller_id,
        CONCAT(YEAR(o.order_approved_at), '-', MONTH(o.order_approved_at)) AS ym,
        SUM(oi.price) AS income_month
    FROM sellers s
    JOIN order_items oi USING (seller_id)
    JOIN orders o USING (order_id)
    JOIN products p USING (product_id)
    JOIN product_category_name_translation pt USING (product_category_name)
    WHERE pt.product_category_name_english IN (
        'audio','consoles_games','electronics','computers_accessories',
        'pc_gamer','computers','tablets_printing_image','telephony'
    )
    GROUP BY s.seller_id, ym
)
SELECT AVG(income_month) AS avg_monthly_income_seller_tech
FROM seller_month_income_tech;

# 17. Average time between order placement and delivery
WITH time_interval AS (
    SELECT TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) AS waiting_time
    FROM orders
)
SELECT AVG(waiting_time) AS avg_waiting_time
FROM time_interval;

# 18. On-time vs delayed delivery
SELECT 
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'True'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'False'
        ELSE 'Else'
    END AS is_on_time,
    COUNT(order_id) AS order_count,
    ROUND(100 * COUNT(order_id) / (SELECT COUNT(order_id) FROM orders), 2) AS order_count_pot
FROM orders
GROUP BY is_on_time
ORDER BY order_count DESC;

# 19. Does order weight influence delivery timing?
WITH order_status_weight AS (
    SELECT 
        o.order_id,
        CASE
            WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'True'
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'False'
            ELSE 'Else'
        END AS is_on_time,
        SUM(product_weight_g) AS order_weight_g
    FROM orders o
    JOIN order_items oi USING (order_id)
    JOIN products p USING (product_id)
    GROUP BY o.order_id
)
SELECT is_on_time, AVG(order_weight_g) AS avg_weight
FROM order_status_weight
GROUP BY is_on_time;
