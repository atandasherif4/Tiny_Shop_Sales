--DATA IN MOTION SQL CASE STUDY 

--Creating the customers table
CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

--Inserting values into the customer table
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

--Viewing the customer table
SELECT *
FROM customers;

--Creating the products table
CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

--Inserting values into the products table
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

--Viewing the table created
SELECT *
FROM products;

--Creating the orders table
CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

--Inserting values into the orders table
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

--Viewing the orders table
SELECT *
FROM orders;

--Creating order items table
CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);

--Inserting values into the order items table
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);

--Viewing the order items table
SELECT *
FROM order_items;

--Questions
-- Question One: Which product has the highest price? Only return a single row.
SELECT product_name, 
	   price
FROM products
GROUP BY product_name,price
ORDER BY price DESC
LIMIT 1;

--Question Two: Which customer has made the most orders?
SELECT customers.customer_id,
	   customers.first_name,
	   customers.last_name,
	   COUNT(DISTINCT order_id) AS count_of_order
FROM customers  
INNER JOIN orders
USING(customer_id)
INNER JOIN order_items 
USING(order_id)
GROUP BY customer_id
ORDER BY customer_id ASC
LIMIT 3;

--Question Three: What’s the total revenue per product?
WITH sales AS ( 
		SELECT order_items.order_id,
			   products.product_id,
			   products.product_name,
			   order_items.quantity,
			   products.price,
			   order_items.quantity * products.price AS amount_sold
		FROM products 
		INNER JOIN order_items 
		USING(product_id)
		ORDER BY product_name ASC
			)
SELECT sales.product_name,
	   SUM(sales.amount_sold) AS total_revenue	   
FROM sales
GROUP BY product_name;

--Question Four: Find the day with the highest revenue.
WITH sales_day AS ( 
		SELECT order_items.order_id,
			   products.product_id,
			   products.product_name,
			   orders.order_date,
			   order_items.quantity,
			   products.price,
			   order_items.quantity * products.price AS amount_sold
		FROM products 
		INNER JOIN order_items
		USING(product_id)
		INNER JOIN orders
		USING(order_id)
		ORDER BY order_Date ASC
			),
 revenue_per_day AS (
		SELECT sales_day.order_date,
	           SUM(sales_day.amount_sold) AS daily_revenue
FROM sales_day
GROUP BY order_date
			)			
--From the above code it is seen that the maximum dialy revenue was 340.00
SELECT EXTRACT(DAY FROM revenue_per_day.order_date) AS day_with_highest_revenue
FROM revenue_per_day
ORDER BY daily_revenue DESC
LIMIT 1;

--Question Five: Find the first order (by date) for each customer.
SELECT customers.customer_id,
	   customers.first_name,
	   customers.last_name,
	   MIN(order_date) AS date_of_first_order
FROM orders
INNER JOIN customers
USING(customer_id)
GROUP BY customers.customer_id
ORDER BY customers.customer_id;

--Question Six: Find the top 3 customers who have ordered the most distinct products
WITH distinct_product_table AS (
	SELECT customers.customer_id,
		   customers.first_name,
		   customers.last_name,
	       orders.order_id,
	       products.product_id,
	       products.product_name
FROM customers
INNER JOIN orders 
USING(customer_id)
INNER JOIN order_items
USING(order_id)
INNER JOIN products
USING(product_id)
	)

SELECT distinct_product_table.customer_id,
       distinct_product_table.first_name,
	   distinct_product_table.last_name,
	   COUNT(DISTINCT distinct_product_table.product_id) AS count_distinct_products
FROM distinct_product_table
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 3; 

--Question Seven: Which product has been bought the least in terms of quantity?
WITH sum_of_quantity_table AS (
	SELECT products.product_id,
	       products.product_name,
	       SUM(order_items.quantity) AS sum_quantity
FROM products
INNER JOIN order_items
USING(product_id)
GROUP BY 1,2
ORDER BY 3 ASC
	)
--Seeing the product bought least in terms of quantity	
SELECT sum_of_quantity_table.product_name
FROM sum_of_quantity_table
WHERE sum_quantity = 3
ORDER BY 1 ASC; 

-- 8. What is the median order total?
WITH sum_per_order1 AS (
		SELECT order_items.order_id,
		   products.product_id,
		   products.product_name,
     	   orders.order_date,
		   order_items.quantity,
		   products.price,
		   order_items.quantity * products.price AS amount_sold      
		FROM products 
		INNER JOIN order_items
		USING(product_id)
		INNER JOIN orders
		USING(order_id)
		ORDER BY order_Date ASC
       ),

	 sum_per_order2 AS (
		SELECT sum_per_order1.order_id,
               SUM(sum_per_order1.amount_sold) AS sum_by_order
	    FROM sum_per_order1
        GROUP BY 1)
		
--The code below can be used to replace Median function in PostgreSQL
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sum_by_order)
FROM sum_per_order2;

-- 9. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
WITH sales AS (
	SELECT order_items.order_id,
		   products.product_id,
		   products.product_name,
     	   orders.order_date,
		   order_items.quantity,
		   products.price,
		   order_items.quantity * products.price AS amount_sold      
		FROM products 
		INNER JOIN order_items
		USING(product_id)
		INNER JOIN orders
		USING(order_id)
		ORDER BY order_Date ASC
)
--Categorizing the total per order
SELECT sales.order_id,
	   SUM(sales.amount_sold) AS total_per_order,
	   CASE WHEN SUM(sales.amount_sold) > 300 THEN 'Expensive'
	        WHEN SUM(sales.amount_sold) BETWEEN 100 AND 300 THEN 'Affordable'
		ELSE 'Cheap' END AS order_type
FROM sales
GROUP BY 1
ORDER BY 1;

--Question Ten: Find customers who have ordered the product with the highest price.
SELECT master_table.customer_id,
       master_table.first_name,
	   master_table.last_name,
	   master_table.price
FROM (SELECT DISTINCT customers.customer_id,
       	 		    customers.first_name,
	  			    customers.last_name,
	   			    order_items.order_id,
	   				orders.order_date,
	   				products.product_name,
	  			    products.price AS price		 
	FROM customers
	INNER JOIN orders
	USING(customer_id)
	INNER JOIN order_items
	USING(order_id)
	INNER JOIN products
	USING (product_id)
	ORDER BY 1) AS master_table
--The maximum price is 70.00
WHERE master_table.price = 70.00;



