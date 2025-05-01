select  
year(w.created_at) as year 
,month(w.created_at) as month
-- ,primary_product_id as product
,count(w.website_session_id) as total_session
,count(o.website_session_id) as order_session
,round(100 * count(o.website_session_id) / count(w.website_session_id),2) as conversion_rate 
,sum(price_usd) / count(distinct o.website_session_id) as avg_revenue_session 
,sum(price_usd) / count(distinct w.website_session_id) as avg_revenue_session 
,sum(case when primary_product_id = 1 then o.price_usd else 0 end) as revenue_product_1 
,sum(case when primary_product_id = 2 then o.price_usd else 0 end) as revenue_product_2 
,count(distinct case when primary_product_id = 1 then o.order_id else null end) as sale_product_1 
,count(distinct case when primary_product_id = 2 then o.order_id else null end) as sale_product_2 
,count(order_id) as  monthly_order_volumn
,sum(price_usd) as revenue 
from website_sessions as w  
left join orders as o
on w.website_session_id = o.website_session_id
where 
	w.created_at > '2012-04-01' 
and w.created_at < '2013-04-05' 
group by year, month

-- select 
-- year(created_at) as year 
-- ,month(created_at) as month
-- ,sum(price_usd) as revenue 
-- ,count(order_id) as  monthly_order_volumn
-- ,sum(price_usd) / count(order_id) as avg_revenue_session
-- from orders
-- where created_at between '2012-04-01' and '2013-01-06'
-- group by year, month ; 