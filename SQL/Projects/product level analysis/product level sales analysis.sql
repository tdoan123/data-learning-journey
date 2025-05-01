select 
year(created_at) as year 
,month(created_at) as month
,count(order_id) as number_sales
,sum(price_usd) as total_revenue
,sum(price_usd) - sum(cogs_usd) as total_margin
from orders
where created_at < '2013-01-04'
group by year, month 
;