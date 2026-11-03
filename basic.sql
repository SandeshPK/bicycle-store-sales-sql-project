create database bicycle_sales_db;
use bicycle_sales_db;

select * from brands;
select * from categories;
select * from customers;
select * from order_items;
select * from orders;
select * from products;
select * from staffs;
select * from stocks;
select * from stores;

alter table brands add primary key (brand_id);
alter table categories add primary key (category_id);
alter table customers add primary key (customer_id);
alter table orders add primary key (order_id);
alter table products add primary key (product_id);
alter table staffs add primary key (staff_id);
alter table stores add primary key (store_id);

alter table order_items 
add constraint fk_order_items_orders foreign key (order_id) references orders(order_id),
add constraint fk_order_items_products foreign key (product_id) references products(product_id);

alter table orders
add constraint fk_orders_customers foreign key (customer_id) references customers(customer_id),
add constraint fk_orders_stores foreign key (store_id) references stores(store_id),
add constraint fk_orders_staffs foreign key (staff_id) references staffs(staff_id);

alter table products 
add constraint fk_products_brands foreign key (brand_id) references brands(brand_id),
add constraint fk_products_categories foreign key (category_id) references categories(category_id);

alter table staffs
add constraint fk_staffs_stores foreign key (store_id) references stores(store_id);

alter table stocks
add constraint fk_stocks_stores foreign key (store_id) references stores(store_id),
add constraint fk_stocks_products foreign key (product_id) references products(product_id);