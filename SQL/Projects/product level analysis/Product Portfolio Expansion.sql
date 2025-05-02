/* 
assignment: Product Portfolio Expansion 
- launch new product on 2013-12-12 to target birthday gift market 
- compare one month before 2013-11-12 and one month after 2014-01-12  
- metrix: 
	- session to order converstion rate: total order devided by total session  
    - average order value:  total revenue devided by total order 
    - products per order: how many product being sold per order. total product sold devided by total order  
    - revenue per session: total revenue devided by total session 
*/

/*
information will get from: 
- website_sessions:  
	- created_at: filter time window to the request 
		=> add condition to separate pre and post 
	- website_session_id: no_of_session  
- orders:
	- `items_purchased` purchase product sell per order => total_product_purchased 
    - `website_session_id`: website session associated with order => no_of_session_order
    - `price_usd`: order revenue => total_revenue 
    - `order_id`: no_of_order 
*/

/*
filter the time window 
create time category - `pre`/'post`
*/

create temporary table session_order 
select 
left_table.website_session_id
,time_period
,order_id
,price_usd
,items_purchased 
from
(select 
website_session_id
,case when created_at < '2013-12-12' then 'A.Pre_Birthday_Bear' else 'B.Post_Birthday_Bear' end as time_period
from website_sessions
where website_sessions.created_at >= '2013-11-12' 
and website_sessions.created_at < '2014-01-12'
) as left_table
left join orders as right_table
on left_table.website_session_id = right_table.website_session_id;

select 
time_period
,count(distinct website_session_id) as total_session  
,count(distinct order_id) as total_order   
,count(distinct order_id) / count(distinct website_session_id) as order_conversion_rate 
,sum(price_usd) as total_revenue 
,sum(price_usd) / count(distinct order_id) as avg_revenue_order
,sum(items_purchased) as total_item
,sum(items_purchased) / count(distinct order_id) as avg_product_order
,sum(price_usd) / count(distinct website_session_id) as avg_rev_session
from session_order
group by time_period;

-- draft 
select 
time_period
,count(distinct website_session_id) 
from 
(
select 
website_session_id
,case when created_at < '2013-12-12' then 'A.Pre_Birthday_Bear' else 'B.Post_Birthday_Bear' end as time_period
from website_sessions
where created_at >= '2013-11-12' 
	and created_at < '2014-01-12'
) as filter1
group by time_period;

/*
A.Pre_Birthday_Bear		17343
B.Post_Birthday_Bear	13383
*/

select 
website_session_id
,case when created_at < '2013-12-12' then 'A.Pre_Birthday_Bear' else 'B.Post_Birthday_Bear' end as time_period
from website_sessions
where created_at >= '2013-11-12' 
	and created_at < '2014-01-12'