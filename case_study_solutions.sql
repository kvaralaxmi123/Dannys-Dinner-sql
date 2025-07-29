use dannys_diner;
select *
from menu;

select * from members;

select *
from menu join sales
on menu.product_id = sales.product_id;

select customer_id,max(product_name) as 'Highest_orders', count(product_name) as 'total'
from menu join sales
on menu.product_id = sales.product_id
group by customer_id ;

select  customer_id,product_name,order_date,dense_rank() over(partition by customer_id order by order_date asc) as rn
from menu join sales
on menu.product_id = sales.product_id;

select customer_id,product_name,order_date
from (select  customer_id,product_name,order_date,dense_rank() over(partition by customer_id order by order_date asc) as rn
from menu join sales
on menu.product_id = sales.product_id) sub
where rn =1;

SELECT * FROM MENU;
SELECT * FROM SALES;

select * from members;

select sum(menu.product_id) as total
from menu join sales
on menu.product_id = sales.product_id
group by customer_id;

select sum(menu.product_id*price) as 'total', customer_id
from menu join sales
on menu.product_id = sales.product_id
group by customer_id;



-- casestudy1 Danny's Dinner --
-- What is the total amount each customer spent at the restaurant?---
SELECT s.customer_id, SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;


-- How many days has each customer visited the restaurant?----
SELECT customer_id, COUNT(DISTINCT order_date) AS visit_days
FROM sales
GROUP BY customer_id;


-- What was the first item from the menu purchased by each customer?---
SELECT DISTINCT s.customer_id, m.product_name
FROM (
    SELECT customer_id, order_date, product_id,
           RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rnk
    FROM sales ) s
JOIN menu m ON s.product_id = m.product_id
WHERE rnk = 1;

-- What is the most purchased item on the menu and how many times was it purchased by all customers?---
SELECT m.product_name, COUNT(*) AS purchase_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;

-- Which item was the most popular for each customer?--
SELECT customer_id, product_name, order_count
FROM (
    SELECT s.customer_id, m.product_name, COUNT(*) AS order_count,
           RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rnk
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
) ranked
WHERE rnk = 1;


-- Which item was purchased first by the customer after they became a member?
SELECT customer_id, product_name
FROM (
    SELECT s.customer_id, s.order_date, m.product_name,
           RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
    FROM sales s
    JOIN members mem ON s.customer_id = mem.customer_id
    JOIN menu m ON s.product_id = m.product_id
    WHERE s.order_date >= mem.join_date
) ranked
WHERE rnk = 1;








 

 
 