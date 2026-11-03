use bicycle_sales_db;

select * from brands;
select * from categories;
select * from customers limit 10;
select * from order_items limit 10;
select * from orders limit 10;
select * from products limit 10;
select * from staffs;
select * from stocks limit 10;
select * from stores;

# 1 Which regions are most profitable per order, Where should be target marketing/expansion ?
SELECT str.state, str.store_name,
CONCAT("$ ", (ROUND(SUM(ort.quantity*(ort.list_price*(1-ort.discount))) / COUNT(DISTINCT ort.order_id), 2))) AS avg_revenue_per_order
FROM stores str 
JOIN orders o ON o.store_id=str.store_id
JOIN order_items ort ON ort.order_id=o.order_id 
GROUP BY str.state, str.store_name
ORDER BY (ROUND(SUM(ort.quantity*(ort.list_price*(1-ort.discount))) / COUNT(DISTINCT ort.order_id), 2)) DESC;

# 2 Where should we open new stores or focus advertising based on customer concentration?
SELECT c.state, COUNT(c.customer_id) AS Number_of_people 
FROM customers c 
GROUP BY c.state 
ORDER BY Number_of_people DESC;

# 3 The majority of people in this database are concentrated in New York.
SELECT c.zip_code, c.state, COUNT(c.customer_id) AS Number_of_people 
FROM customers c
GROUP BY c.zip_code, c.state
ORDER BY Number_of_people DESC LIMIT 20;

# 4 Which brands drive our revenue and deserve better placement/promotion in stores?
SELECT b.brand_name, 
CONCAT("$ ", ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))/1000),2)," thousand") AS revenue
FROM brands b 
JOIN products p ON p.brand_id=b.brand_id
JOIN order_items ort ON ort.product_id=p.product_id 
GROUP BY b.brand_name 
ORDER BY ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))/1000),2) DESC;

# 5 What are our best sellers — and should we bundle or feature them more?
SELECT p.product_name, SUM(ort.quantity) AS Total_quantity_ordered, 
CONCAT("$ ",(ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))),2))) AS total_revenue
FROM products p
JOIN order_items ort ON ort.product_id=p.product_id
GROUP BY p.product_name 
ORDER BY SUM(ort.quantity) DESC, ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))),2) DESC LIMIT 10;

# 6 Which product types (e.g., mountain bikes, road bikes) are most popular, and should we adjust inventory accordingly?
SELECT cat.category_name, 
CONCAT("$ ", ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))/1000),2), " thousand") AS total_revenue
FROM categories cat 
JOIN products p ON p.category_id=cat.category_id
JOIN order_items ort ON ort.product_id=p.product_id
GROUP BY cat.category_name
ORDER BY ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))/1000),2) DESC;

# 7 Which staff should be rewarded or trained? Who influences the most revenue per store?
SELECT staffs.first_name, staffs.last_name, staffs.email, staffs.phone, s.store_name,
CONCAT("$ ", ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))/1000),2), " thousand") AS revenue
FROM staffs
JOIN orders o ON o.staff_id=staffs.staff_id
JOIN order_items ort ON ort.order_id=o.order_id
JOIN stores s ON s.store_id=staffs.store_id
GROUP BY staffs.staff_id 
ORDER BY ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))/1000),2) DESC;

# 8 Which stores are underperforming, and why? Should we consider location-based promotions, openings, or closures?
SELECT s.store_name,
CONCAT("$ ", ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))/1000),2), " thousand") AS revenue
FROM stores s
JOIN orders o ON o.store_id=s.store_id
JOIN order_items ort ON ort.order_id=o.order_Id
GROUP BY s.store_name 
ORDER BY ROUND(((SUM(ort.quantity*(ort.list_price*(1-ort.discount))))/1000),2) DESC;

# 9 What stores do we have to focus on currently concerning our stock?
SELECT store_name, state, COUNT(products_out_of_stock) AS Amount_out_of_stock 
FROM (
    SELECT st.store_name, st.state, p.product_name AS products_out_of_stock 
    FROM products p
    JOIN stocks s ON s.product_id=p.product_id
    JOIN stores st ON st.store_id=s.store_id
    WHERE s.quantity=0
    ) as t
GROUP BY store_name, state
ORDER BY Amount_out_of_stock DESC;

# This represents the products that are out of stock for specific store.
SELECT st.store_name, st.state, p.product_name  AS products_out_of_stock 
FROM products p
JOIN stocks s ON s.product_id=p.product_id
JOIN stores st ON st.store_id=s.store_id
WHERE s.quantity=0 AND st.store_name="Santa Cruz Bikes";



# dispaly all dept that no employee
select d.dept_id, d.dept_name
from dept d
left join emp_table e on e.dept_id = d.dept_id
where emp_id is null
group by d.dept_id;

select dept_id, dept_name
from dept
where dept_id not in (select dept_id from employees);

# WAQ to label emp as high salary when salary is > 80k else regular
select emp_id, emp_name,salary,
case
	when salary>80000 then "High salary"
    else "Regular salary"
end as salary_class
from emp_table
order by emp_id;

# WAQ display all cust even if they dont have placed any orders also placed orders
select cust.cust_id, cust.cust_name
from customers cust
left join orders o on o.cust_id = cust.cust_id
order by cust_id;