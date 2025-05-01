
/* understanding each table  
- table `orders`: 
	-`order_id`
    -`primary_product_id`:   
    -`items_purchased`:   
	- what are the information that this table content? 
		- recording transaction happen when a user make an order.  
        - at a certain point in time (`created_at`) , from certain website session(`website_session_id`), an user (`user_id`)  make an order (`order_id`) with the first product  as `primary_product_id`. 
        - when was an order place? `created_at` 
        - what is the order unique identification? `order_id` 
        - what is the website_session that execute this order?  `website_session_id`  
        - who is the one making this order? `user_id`  
        - what is the first product that being purchase in this order? `user_id`
        - how many items being purchased in this order? 
        - what is price value of a particular order? `price_usd` 
        - what is the costs of a particular order? `cogs_usd` 
        
- table `order_items`:  
	-  `is_primary_item`:  
    - `order_id`:  
    - 'order_item_id`: 
    - what are the information that this table content?  
		- breakdown detail of each order_id 
		- a unqie order item id for each transaction in the record 
        - when was each order item being recorded/ordered? `created_at` 
        - what was the order identification?  `order_id` 
        - what are the products being ordered by a particular order_id? `product_id` 
        - whether the item (product_id) of this record is a primary_item (i.e. the 1st product being placed) `is_primary_item`  
        - what is the price value of a particular product? `price_usd` 
        - what is the costs value of a particular product? `cogs_usd` 
*/
	
/* query to create a table showing:  
- order_id 
- the primary_product_id of each order_id 
- other product_id of each order_id (if any)  
*/ 
select  
	orders.order_id
    ,orders.primary_product_id
    ,order_items.product_id as cross_sell_product
from orders  
	left join order_items  
		on order_items.order_id = orders.order_id 
        and order_items.is_primary_item = 0  -- to filter product that is not a primary order -> create a table with order_id that map with another table with any product_id that is not a primary
where orders.order_id between 10000 and 11000; -- sample;

/* query to create a table showing: breakdown of number of orders being made for each primary_product_id by cross_sell_product */ 
select  
    orders.primary_product_id
    ,order_items.product_id as cross_sell_product
	,count(distinct orders.order_id) as total_order 
from orders  
	left join order_items  
		on order_items.order_id = orders.order_id 
        and order_items.is_primary_item = 0
where orders.order_id between 10000 and 11000
group by orders.primary_product_id, cross_sell_product;

/* query to create a table showing: breakdown of number of orders being made for each primary_product_id by cross_sell_product with each variable of cross_sell_product displayed in the column */ 
select  
    orders.primary_product_id
    ,count(distinct orders.order_id) as total_order 
	,count(distinct case when order_items.product_id  = 1 then orders.order_id else null end) as cross_sell_1 
	,count(distinct case when order_items.product_id  = 2 then orders.order_id else null end) as cross_sell_2 
	,count(distinct case when order_items.product_id  = 3 then orders.order_id else null end) as cross_sell_3 
from orders  
	left join order_items  
		on order_items.order_id = orders.order_id 
        and order_items.is_primary_item = 0
where orders.order_id between 10000 and 11000
group by 1;

/* query to create a table showing: 
- breakdown of number of orders being made for each primary_product_id by cross_sell_product with each variable of cross_sell_product displayed in the column 
- percentage of cross_sell from total order*/ 
select  
    orders.primary_product_id
    ,count(distinct orders.order_id) as total_order 
	,count(distinct case when order_items.product_id  = 1 then orders.order_id else null end) as cross_sell_1 
	,count(distinct case when order_items.product_id  = 2 then orders.order_id else null end) as cross_sell_2 
	,count(distinct case when order_items.product_id  = 3 then orders.order_id else null end) as cross_sell_3 
    ,round(100 * count(distinct case when order_items.product_id  = 1 then orders.order_id else null end) /  count(distinct orders.order_id), 2) as cross_sell_1_rate
	,round(100 * count(distinct case when order_items.product_id  = 2 then orders.order_id else null end) /  count(distinct orders.order_id), 2) as cross_sell_2_rate
	,round(100 * count(distinct case when order_items.product_id  = 3 then orders.order_id else null end) /  count(distinct orders.order_id), 2) as cross_sell_3_rate
from orders  
	left join order_items  
		on order_items.order_id = orders.order_id 
        and order_items.is_primary_item = 0
where orders.order_id between 10000 and 11000
group by 1;


-- lesson learn: forgot to use argg function to display values for cross_sell_1, cross_sell_2, cross_sell_3 
/* query to create a pivot table with columns as variables of cross_sell_product */  
-- select  
--     primary_product_id
--     ,case when cross_sell_product = 1 then cross_sell_product else null end as cross_sell_1 
--     ,case when cross_sell_product = 2 then cross_sell_product else null end as cross_sell_2 
--     ,case when cross_sell_product = 3 then cross_sell_product else null end as cross_sell_3 
-- 	,total_order 
-- from 
-- (select  
--     orders.primary_product_id
--     ,order_items.product_id as cross_sell_product
-- 	,count(distinct orders.order_id) as total_order 
-- from orders  
-- 	left join order_items  
-- 		on order_items.order_id = orders.order_id 
--         and order_items.is_primary_item = 0
-- where orders.order_id between 10000 and 11000) as filter_1
-- group by 1, 2, 3, 4,;

