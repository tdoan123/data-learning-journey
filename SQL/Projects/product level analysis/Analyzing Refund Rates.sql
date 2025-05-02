/*
Assignment: Analyzing Refund Rates 

Business situation: 
- having new supplier on '2014-09-16'  
- '2014-10-15' want to see return rate of each product 
*/

/*
`order_items` table 
	- `order_id`
    - `product_id` 
    - `created_at` 
    - `order_item_id`   - join   
`order_item_refunds` table
	- `order_id` 
    - `order_item_id`   - join 
    - `created_at`
*/

create temporary table product_return_info 
select 
o.created_at
,o.order_id as order_id
,o.order_item_id as total_item_id
,o.product_id as product_id
,r.order_item_id as return_item_id 
from order_items as o 
left join order_item_refunds as r 
on o.order_item_id = r.order_item_id  
where o.created_at < '2014-10-15' ;

create temporary table product_return_filter
select
year(created_at) as yr
,month(created_at) as mth
,product_id
,count(distinct order_id) as total_order
,count(distinct total_item_id) as total_item
,count(distinct return_item_id) as total_return_item
from product_return_info
group by 1, 2, 3;

select 
yr
,mth
,sum(case when product_id = 1 then total_item else null end ) as p1_order 
,round(100 * sum(case when product_id = 1 then total_return_item else null end) / sum(case when product_id = 1 then total_item else null end),2) as p1_return_rate
,sum(case when product_id = 2 then total_item else null end ) as p2_order 
,round(100 * sum(case when product_id = 2 then total_return_item else null end) / sum(case when product_id = 2 then total_item else null end),2) as p2_return_rate
,sum(case when product_id = 3 then total_item else null end ) as p3_order 
,round(100 * sum(case when product_id = 3 then total_return_item else null end) / sum(case when product_id = 3 then total_item else null end),2) as p3_return_rate
,sum(case when product_id = 4 then total_item else null end ) as p4_order 
,round(100 * sum(case when product_id = 4 then total_return_item else null end) / sum(case when product_id = 4 then total_item else null end),2) as p4_return_rate
from product_return_filter
group by 1, 2;

-- draft 
select 
year(o.created_at) as yr
,month(o.created_at) as mth
,count(distinct o.order_id) as total_order
,count(distinct o.order_item_id) as total_item
,count(distinct r.order_item_id) as total_return_item
from order_items as o 
left join order_item_refunds as r 
on o.order_item_id = r.order_item_id  
where o.created_at < '2014-10-15'
group by 1, 2 ;

select 
* 
from order_item_refunds;

select 
*
from order_items;