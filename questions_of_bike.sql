USE bike_store;

-- BEGINNER QUESTIONS --

-- 1) Список всех продуктов: напишите запрос для получения всех названий продуктов и соответствующих им названий брендов
SELECT product_name, brand_name
FROM products p
INNER JOIN brands b
	ON p.brand_id = b.brand_id
ORDER BY brand_name;

-- 2) Поиск активного персонала: напишите запрос для поиска всех активных сотрудников и названий их магазинов
SELECT first_name, last_name, store_name
FROM staffs sf
INNER JOIN stores st
	ON sf.store_id = st.store_id
WHERE active = TRUE;

-- 3) Сведения о клиенте: напишите запрос для списка всех клиентов с их полными именами, адресами электронной почты и номерами телефонов
SELECT first_name, last_name, email, phone
FROM customers;

-- 4) Категории продуктов: напишите запрос для подсчета количества продуктов в каждой категории
SELECT category_name, COUNT(pr.category_id) AS quantity
FROM products pr
INNER JOIN categories ct
	ON pr.category_id = ct.category_id
GROUP BY pr.category_id
ORDER BY quantity DESC;

-- 5) Заказы по клиенту: напишите запрос для подсчета общего количества заказов, размещенных каждым клиентом
SELECT last_name, first_name, COUNT(*) AS quantity
FROM orders o
INNER JOIN customers cs
	ON o.customer_id = cs.customer_id
GROUP BY o.customer_id
ORDER BY last_name, first_name;

-- INTERMEDIATE QUESTIONS --

-- 1) Общий объем продаж по продукту: напишите запрос для расчета общей суммы продаж для каждого продукта (с учетом количества, цены по прейскуранту и скидки)
SELECT product_name,
	   ROUND(SUM(quantity * (oi.list_price * (1 - discount))), 2) AS sales_revenue
FROM products pr
INNER JOIN order_items oi
	ON pr.product_id = oi.product_id
GROUP BY pr.product_id
ORDER BY sales_revenue DESC;

-- 2) Заказы по статусу: напишите запрос для подсчета количества заказов для каждого статуса заказа
SELECT order_status, COUNT(order_id) AS num_of_order
FROM orders 
GROUP BY order_status
ORDER BY order_status;

-- 3) Заказы клиентов: напишите запрос для списка всех клиентов, которые разместили хотя бы один заказ, включая их полное имя и общее количество заказов
SELECT CONCAT(last_name, ' ', first_name) AS full_name, 
	   COUNT(order_id) AS num_of_orders
FROM orders o
INNER JOIN customers cs
	ON o.customer_id = cs.customer_id
GROUP BY o.customer_id
ORDER BY num_of_orders DESC, full_name;

-- 4) Наличие на складе: напишите запрос для поиска общего количества каждого продукта, доступного во всех магазинах
SELECT product_name, SUM(quantity) AS total_quantity
FROM products pr
INNER JOIN stocks st
	ON pr.product_id = st.product_id
GROUP BY st.product_id
ORDER BY total_quantity DESC;

-- 5) Доход по магазину: напишите запрос для расчета общего дохода, полученного каждым магазином
SELECT store_name, 
	ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_store_revenue
FROM order_items oi
INNER JOIN orders o
	ON oi.order_id = o.order_id     
INNER JOIN stores st
	ON st.store_id = o.store_id
GROUP BY o.store_id
ORDER BY total_store_revenue DESC;

-- ADVANCED QUESTIONS --

-- 1) Анализ ежемесячных продаж: напишите запрос для расчета общей суммы продаж за каждый месяц 
SELECT YEAR(order_date) AS year, 
	   MONTH(order_date) AS month, 
	   ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_of_month
FROM order_items oi
INNER JOIN orders o
	ON oi.order_id = o.order_id    
GROUP BY YEAR(order_date), MONTH(order_date); 

-- 2) Лучшие клиенты: напишите запрос для поиска 5 лучших клиентов, которые потратили больше всего денег
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
	   ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS spent
FROM order_items oi
INNER JOIN orders o
	ON oi.order_id = o.order_id
INNER JOIN customers cs
	ON o.customer_id = cs.customer_id
GROUP BY cs.customer_id
ORDER BY spent DESC
LIMIT 5;

-- 3) Иерархия сотрудников: напишите запрос для перечисления всех сотрудников вместе с именами их менеджеров
SELECT e.staff_id, 
	   CONCAT(e.first_name, ' ', e.last_name) AS emploee,
	   CONCAT(m.first_name, ' ', m.last_name) AS manager
FROM staffs e
LEFT JOIN staffs m
	ON m.staff_id = e.manager_id;
    
-- 4) Эффективность продукта: напишите запрос для определения того, какие продукты имеют самый высокий объем продаж в 2018 году
SELECT pr.product_id,
	   product_name,
	   ROUND(SUM(quantity * oi.list_price * (1 - discount)), 2) AS unit_sold
FROM products pr
INNER JOIN order_items oi
	ON pr.product_id = oi.product_id
INNER JOIN orders o
	ON oi.order_id = o.order_id
WHERE YEAR(order_date) = '2018'
GROUP BY product_id
ORDER BY unit_sold DESC
LIMIT 10;
    
-- 5) Анализ местоположения клиентов: напишите запрос для подсчета количества клиентов, 
-- общего объема продаж, средней стоимости заказа и максимальной стоимости заказа для клиентов в каждом городе
SELECT city,
       COUNT(cs.customer_id) AS customer_count,
	   ROUND(SUM(quantity * oi.list_price * (1 - discount)), 2) AS sales_volume,
       ROUND(AVG(quantity * oi.list_price * (1 - discount)), 2) AS avg_order,
       ROUND(MAX(quantity * oi.list_price * (1 - discount)), 2) AS max_order
FROM customers cs
INNER JOIN orders o
	ON cs.customer_id = o.customer_id
INNER JOIN order_items oi
	ON o.order_id = oi.order_id
GROUP BY city
ORDER BY sales_volume DESC;     

-- -------------------------------- ОКОННЫЕ ФУНКЦИИ -------------------------------------

-- 1) Ранг товаров: напишите запрос для распределения самых дорогих товаров к самым дешевым
SELECT product_name, 
	   list_price,
	   DENSE_RANK() OVER (ORDER BY list_price DESC) AS product_dense_rank
FROM products;

-- 2) Количество заказов в день: напишите запрос для определения общего числа заказов по дням без учета отмененных заказов, 
-- сформируйте накопительную сумму заказов
WITH subq AS (
	SELECT order_date,
		   COUNT(order_id) AS orders_count
	FROM orders
    GROUP BY order_date
)
SELECT order_date,
	   orders_count,
       SUM(orders_count) OVER (ORDER BY order_date) AS orders_cum_count
FROM subq;

-- 3) Нумерование заказов пользователей: напишите запрос для определения порядкового номера каждого заказа для каждого покупателя 
SELECT customer_id, 
	   order_id, 
	   order_date,
	   ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number
FROM orders
WHERE order_id NOT IN (
	SELECT order_id
    FROM orders
    WHERE order_status = 3
);

-- 4) Время между заказами: напишите запрос для определения прошедшего времени с момента предыдущего заказа для каждого пользователя без учета отмеенных заказов
WITH subq AS (
	SELECT customer_id, 
		   order_id,
		   order_date,
		   LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS time_lag
	FROM orders
    WHERE order_id NOT IN (
		SELECT order_id
		FROM orders
		WHERE order_status = 3
	)
)

SELECT customer_id, 
	   order_id,
       order_date,
	   time_lag,
       DATEDIFF(order_date, time_lag) AS time_diff_days
FROM subq;
       
-- 5) Время между заказами: рассчитайте среднее время между заказами для каждого пользователя, у которого более одного заказа  
WITH subq1 AS (
	SELECT customer_id, 
		   order_id,
		   order_date,
		   LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS time_lag
	FROM orders
    WHERE order_id NOT IN (
		SELECT order_id
		FROM orders
		WHERE order_status = 3
	)
),
subq2 AS (
	SELECT customer_id, 
		   order_id,
		   order_date,
		   time_lag,
		   DATEDIFF(order_date, time_lag) AS time_diff_days
	FROM subq1
)

SELECT customer_id, 
	   ROUND(AVG(time_diff_days), 2) AS days_between_orders
FROM subq2
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- 6) Продуктивные продавцы: напишите запрос для определения продавцов, которые осуществили больше заказов, чем среднее значение продаж 
WITH subq1 AS (
	SELECT DISTINCT staff_id, 
					COUNT(order_id) OVER (PARTITION BY staff_id) AS staff_orders
	FROM orders
),
subq2 AS (
	   SELECT staff_id, 
	   staff_orders,
	   ROUND(AVG(staff_orders) OVER (), 2) AS avg_orders_staff
       FROM subq1
)

SELECT staff_id, 
	   staff_orders,
	   avg_orders_staff,
       CASE 
			WHEN staff_orders > avg_orders_staff
			THEN 'YES'
			ELSE 'NO'
       END AS is_above_avg
FROM subq2;

-- 7) Первые и повторные заказы: напишите запрос для определения числа первых и повторных для каждого дня
WITH subq  AS(
	SELECT customer_id,
		   order_date,
		   order_id,
		   CASE
				WHEN order_date = MIN(order_date) OVER (PARTITION BY customer_id)
				THEN 'Первый'
				ELSE 'Повторный'
		   END AS order_type
	FROM orders
	WHERE order_id NOT IN (
		SELECT order_id
		FROM orders
		WHERE order_status = 3
	)
)

SELECT order_date,
	   order_type,
	   COUNT(order_id) AS orders_count
FROM subq
GROUP BY order_date, order_type
ORDER BY order_date, order_type;



