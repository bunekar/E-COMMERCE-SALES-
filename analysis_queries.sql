---------------------------- Level 1: Basics 
-- 1. Retrieve customer names and emails for email marketing
select * from customers;
select name , email from customers ;

-- 2. View complete product catalog with all available details
--  (The product manager may want to review all product listings in one go.)
SELECT * FROM PRODUCTS;

-- 3. List all unique product categories
-- Useful for analyzing the range of departments or for creating filters on the website.
SELECT DISTINCT CATEGORY FROM PRODUCTS;
SELECT CATEGORY FROM PRODUCTS 
GROUP BY CATEGORY;

-- 4. Show all products priced above ₹1,000
-- This helps identify high-value items for premium promotions or pricing strategy reviews.
SELECT * FROM PRODUCTS 
WHERE PRICE > 1000
ORDER BY PRICE DESC;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000)
-- A merchandising team might need this to create a mid-tier pricing campaign.
SELECT * FROM PRODUCTS 
WHERE PRICE between 2000  AND 5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
-- This is used when customer IDs are pre-selected from another system.
SELECT customer_id
FROM customers
WHERE customer_id IN (1,2,3);


-- 7. Identify customers whose names start with the letter ‘A’
-- Used for alphabetical segmentation in outreach or app display.
SELECT NAME FROM CUSTOMERS 
WHERE NAME LIKE 'A%';


-- 8. List electronics products priced under ₹3,000
-- Used by merchandising or frontend teams to showcase budget electronics.
SELECT CATEGORY , PRICE FROM PRODUCTS 
WHERE CATEGORY = 'ELECTRONICS' AND PRICE < 3000;



-- 9. Display product names and prices in descending order of price
-- This helps teams easily view and compare top-priced items.

SELECT NAME , PRICE  FROM PRODUCTS 
ORDER BY PRICE DESC;

-- 10. Display product names and prices, sorted by price and then by name
-- The merchandising or catalog team may want to list products from most expensive to cheapest. 
-- If multiple products have the same price, they should be sorted alphabetically for clarity on storefronts or printed catalogs.
SELECT NAME , PRICE  FROM PRODUCTS 
ORDER BY PRICE DESC , NAME ASC;


-- Level 2: Filtering and Formatting

-- 1. Retrieve orders where customer information is missing (possibly due to data migration or deletion)
-- Used to identify orphaned orders or test data where customer_id is not linked.
SELECT ORDER_ID , CUSTOMER_ID , ORDER_DATE , TOTAL_AMOUNT FROM ORDERS
WHERE CUSTOMER_ID IS NULL;

-- 2. Display customer names and emails using column aliases for frontend readability
 -- Useful for feeding into frontend displays or report headings that require user-friendly labels.
SELECT NAME AS CUSTOMER_NAME , EMAIL AS CUSOTMER_EMAIL  FROM CUSTOMERS;

-- 3. Calculate total value per item ordered by multiplying quantity and item price
-- This can help generate per-line item bill details or invoice breakdowns.
SELECT order_item_id , quantity * ITEM_PRICE AS TOTAL_VALUE 
FROM order_items
ORDER BY TOTAL_VALUE DESC ;

-- 4. Combine customer name and phone number in a single column
-- Used to show brief customer summaries or contact lists.

SELECT concat( NAME , '-' ,phone) as cn
 FROM CUSTOMERS;

-- 5. Extract only the date part from order timestamps for date-wise reporting
-- Helps group or filter orders by date without considering time.

select date(order_date) as order_date_only
from orders;

-- 6. List products that do not have any stock left
-- This helps the inventory team identify out-of-stock items.
select * from products 
where stock_quantity =0 or stock_quantity is null ;

------------------------------- Level 3: Aggregations

-- 1. Count the total number of orders placed
-- Used by business managers to track order volume over time
select count(order_id) as order_placed    
from orders;

-- 2. Calculate the total revenue collected from all orders
-- This gives the overall sales value
select sum(total_amount) as total_revenue 
 from orders;
 
 -- 3. Calculate the average order value
-- Used for understanding customer spending patterns.
select avg(total_amount) as total_revenue 
 from orders; 
 
 -- 4. Count the number of customers who have placed at least one order
-- This identifies active customers.
SELECT 
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders;

-- 5. Find the number of orders placed by each customer
-- Helpful for identifying top or repeat customers.
select count(order_id) as orders_count  ,  customer_id
from orders
group by customer_id
order by orders_count desc ;


-- 6. Find total sales amount made by each customer
select sum(total_amount) as total_sales , customer_id
from orders
group by customer_id
order by total_sales desc;

-- 7. List the number of products sold per category
-- This helps category managers assess performance by department.


SELECT 
    p.category,
    SUM(oi.quantity) AS products_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;


-- 8. Find the average item price per category
-- Useful to compare pricing across departments.


select avg(price) as avg_price , category 
from products
group by category ;


-- 9. Show number of orders placed per day
-- Used to track daily business activity and demand trends.

select count(*) as no_of_orders , date(order_date) as order_day
from orders 
group by order_day
order by order_day;

-- 10. List total payments received per payment method
-- Helps the finance team understand preferred transaction modes.

select method, sum(amount_paid) as total_payments
from payments
group by method
order by total_payments desc;

--------------------   Level 4: Multi-Table Queries (JOINS)
-- . Retrieve order details along with the customer name (INNER JOIN)
-- Used for displaying which customer placed each order.

select o.order_id ,o.order_date ,o.customer_id , c.name as customer_name 
from orders o 
inner join customers c on o.customer_id = c.customer_id;

-- 2. Get list of products that have been sold (INNER JOIN with order_items)
-- Used to find which products were actually included in orders.

select oi.product_id, p.name as product_name, sum(oi.quantity) as total_sold
from order_items oi
inner join products p on oi.product_id = p.product_id
group by oi.product_id, p.name
order by total_sold desc;

-- 3. List all orders with their payment method (INNER JOIN)
-- Used by finance or audit teams to see how each order was paid for.

select o.order_id, o.customer_id, o.order_date, p.method as payment_method, p.amount_paid
from orders o
inner join payments p on o.order_id = p.order_id
order by o.order_id;


-- 4. Get list of customers and their orders (LEFT JOIN)
-- Used to find all customers and see who has or hasn’t placed orders.


select c.customer_id, c.name as customer_name, o.order_id, o.order_date
from customers c
left join orders o on c.customer_id = o.customer_id
order by c.customer_id;


---  5. List all products along with order item quantity (LEFT JOIN)
-- Useful for inventory teams to track what sold and what hasn’t

select p.product_id, p.name as product_name, sum(oi.quantity) as total_sold
from products p
left join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.name
order by total_sold desc;


-- 6. List all payments including those with no matching orders (RIGHT JOIN)
-- Rare but used when ensuring all payments are mapped correctly


select p.payment_id, p.method as payment_method, p.amount_paid, o.order_id
from orders o
right join payments p on o.order_id = p.order_id
order by p.payment_id;


--   7. Combine data from three tables: customer, order, and payment
-- Used for detailed transaction reports.


select c.customer_id, c.name as customer_name,
       o.order_id, o.order_date,
       p.payment_id, p.method as payment_method, p.amount_paid
from customers c
left join orders o on c.customer_id = o.customer_id
left join payments p on o.order_id = p.order_id
order by c.customer_id, o.order_id;


------------- Level 5: Subqueries (Inner Queries)
-- 1. List all products priced above the average product price
-- Used by pricing analysts to identify premium-priced products.

select product_id, name, price
from products
where price > (select avg(price) from products)
order by price desc;

--  2. Find customers who have placed at least one order
-- Used to identify active customers for loyalty campaigns.

select distinct c.customer_id, c.name as customer_name
from customers c
inner join orders o on c.customer_id = o.customer_id
order by c.customer_id;

-- 3. Show orders whose total amount is above the average for that customer
-- Used to detect unusually high purchases per customer.


select o.order_id, o.customer_id, o.order_date, o.total_amount
from orders o
where o.total_amount > (
    select avg(o2.total_amount)
    from orders o2
    where o2.customer_id = o.customer_id
)
order by o.customer_id, o.total_amount desc;



----  4. Display customers who haven’t placed any orders
 -- Used for re-engagement campaigns targeting inactive users.

select c.customer_id, c.name as customer_name
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null
order by c.customer_id;

--  5. Show products that were never ordered
-- Helps with inventory clearance decisions or product deactivation.

select p.product_id, p.name as product_name
from products p
left join order_items oi on p.product_id = oi.product_id
where oi.order_id is null
order by p.product_id;

-- 6. Show highest value order per customer
-- Used to identify the largest transaction made by each customer.
select o.customer_id, o.order_id, o.order_date, o.total_amount
from orders o
where o.total_amount = (
    select max(o2.total_amount)
    from orders o2
    where o2.customer_id = o.customer_id
)
order by o.customer_id;


-- 7. Highest Order Per Customer (Including Names)
-- Used to identify the largest transaction made by each customer. Outputs name as well.

select c.customer_id, c.name as customer_name, o.order_id, o.order_date, o.total_amount
from customers c
inner join orders o on c.customer_id = o.customer_id
where o.total_amount = (
    select max(o2.total_amount)
    from orders o2
    where o2.customer_id = c.customer_id
)
order by c.customer_id;

----------- Level 6: Set Operations

-- 1. List all customers who have either placed an order or written a product review
-- Used to identify engaged customers from different activity areas.

    
select distinct customer_id, name
from customers
where customer_id in (
    select customer_id from orders
    union
    select customer_id from reviews
)
order by customer_id;

-- 2. List all customers who have placed an order as well as reviewed a product [intersect not supported]
-- Used to identify highly engaged customers for rewards.
select c.customer_id, c.name
from customers c
where exists (
    select 1 from orders o where o.customer_id = c.customer_id
)
and exists (
    select 1 from reviews r where r.customer_id = c.customer_id
)
order by c.customer_id;

