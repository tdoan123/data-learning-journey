/* 
assigment requirements: 
- request date: Nov 22,2013 
- starting from Sep 25,2013 user allowed to add 2nd product into /cart page 
- timing: 
	- compare 1 month before Sep 25,2013 => Aug 25,2013 => A.Pre_Cross_Sell
	- and 1 month after Sep 25,2013 => Oct 25,2013 => B.Post_Cross_Sell
- agg:  
	- convertion rate from `/cart` page 
    - average products per order 
    - average order value (AOV)  
    - revenue per /cart page view  
*/ 

/* approach: 
- total number of website session in `/cart` page 
- after I get the website session that have `/cart` how Io find if the website_session that process to the next url?  
	=> search for website_session_id with created_at > than created_at of website_session_id that is also in `cart` 
*/

/*
query to: 
- filter data for the required time window and landing page 
- catergory the data into pre and post experiment period 
*/

select  
website_pageview_id
,created_at
,website_session_id
,case when created_at < '2013-09-25' then 'A.Pre_Cross_Sell' else 'B.Post_Cross_Sell' end as time_period
from website_pageviews
where created_at between '2013-08-25' and '2013-10-25'
and pageview_url = '/cart';

/*
query to: 
- filter data for the required time window and landing page 
- catergory the data into pre and post experiment period 
- left join the filtered table to  `website_pageviews` table to map:
	- website_session_id with `cart` that has `created_at` equal and larger than `created_at` of website_session_id with `cart`  
    => check website_session after landing `cart` page 
*/

select  
l_pageviews.website_pageview_id
,l_pageviews.created_at
,l_pageviews.website_session_id
,r_pageviews.pageview_url
,case when l_pageviews.created_at < '2013-09-25' then 'A.Pre_Cross_Sell' else 'B.Post_Cross_Sell' end as time_period
from website_pageviews as l_pageviews 
left join website_pageviews as r_pageviews 
on l_pageviews.website_session_id = r_pageviews.website_session_id
and l_pageviews.created_at <= r_pageviews.created_at
where l_pageviews.created_at between '2013-08-25' and '2013-10-25'
and l_pageviews.pageview_url = '/cart';

/*
assigned the below query into a temporary table: 
- filter data for the required time window and landing page 
- catergory the data into pre and post experiment period 
- left join the filtered table to  `website_pageviews` table to map:
	- website_session_id with `cart` that has `created_at` equal and larger than `created_at` of website_session_id with `cart`  
    => check website_session after landing `cart` page 
*/
create temporary table p_cart_performance
select  
l_pageviews.website_pageview_id
,l_pageviews.created_at
,l_pageviews.website_session_id
,r_pageviews.pageview_url
,case when l_pageviews.created_at < '2013-09-25' then 'A.Pre_Cross_Sell' else 'B.Post_Cross_Sell' end as time_period
from website_pageviews as l_pageviews 
left join website_pageviews as r_pageviews 
on l_pageviews.website_session_id = r_pageviews.website_session_id
and l_pageviews.created_at <= r_pageviews.created_at
where l_pageviews.created_at between '2013-08-25' and '2013-10-25'
and l_pageviews.pageview_url = '/cart';

/* 
query to:  
- get the no. of website session landed in `cart` page 
- get the no. of website session landed in other pages but not `cart`  
- calculate the pct of click through  
- dimenssion: time_period   
*/
select 
time_period 
,count(distinct case when pageview_url = '/cart' then website_session_id else null end) as total_session_cart 
,count(distinct case when pageview_url != '/cart' then website_session_id else null end) as total_session_click_through
,round(100 * count(distinct case when pageview_url != '/cart' then website_session_id else null end) / count(distinct case when pageview_url = '/cart' then website_session_id else null end), 2) as click_thorugh_rate
from p_cart_performance
group by 1;

/* 
join the temporately table to `orders` table to get information on 
- `items_purchased`
- `price_usd`
- `order_id` 
*/ 
select
l_table.website_session_id
,l_table.pageview_url
,l_table.time_period
,r_table.items_purchased
,r_table.order_id 
,r_table.price_usd 
from p_cart_performance as l_table
left join orders as r_table  
on l_table.website_session_id = r_table.website_session_id;

/* 
join the temporately table to `orders` table to get information on 
- `items_purchased`
- `price_usd`
- `order_id` 

return value 
- dim: time_period 
- get the no. of website session landed in `cart` page 
- get the no. of website session landed in other pages but not `cart`  
- calculate the pct of click through  
- total order number 
- total ordered products
- total revenue 
- avg product per order 
- avg order value 
- revenue per cart session 
*/ 

select
time_period 
,count(distinct case when pageview_url = '/cart' then l_table.website_session_id else null end) as total_session_cart 
,count(distinct case when pageview_url != '/cart' then l_table.website_session_id else null end) as total_session_click_through
,round(100 * count(distinct case when pageview_url != '/cart' then l_table.website_session_id else 0 end) / count(distinct case when pageview_url = '/cart' then l_table.website_session_id else null end), 2) as click_thorugh_rate
,count(distinct order_id) as total_order
,sum(case when pageview_url = '/cart' then items_purchased else 0 end) as no_ordered_product 
,sum(case when pageview_url = '/cart' then price_usd else 0 end) as total_revenue
,sum(case when pageview_url = '/cart' then items_purchased else 0 end) / count(distinct order_id) as product_per_order
,sum(case when pageview_url = '/cart' then price_usd else 0 end) / count(distinct order_id) as avg_order_value
,sum(case when pageview_url = '/cart' then price_usd else 0 end) / count(distinct case when pageview_url = '/cart' then l_table.website_session_id else null end) as rev_per_cart
from p_cart_performance as l_table
left join orders as r_table  
on l_table.website_session_id = r_table.website_session_id
group by 1;


-- draft session  
select  
website_pageview_id
,created_at
,website_session_id
,pageview_url
,case when created_at < '2013-09-25' then 'A.Pre_Cross_Sell' else 'B.Post_Cross_Sell' end as time_period
from website_pageviews
where created_at between '2013-08-25' and '2013-10-25';

select * 
from p_cart_performance; 

select
time_period
,l_table.website_session_id
,sum(distinct items_purchased)
,count(distinct order_id)
,sum(distinct price_usd)
from p_cart_performance as l_table
left join orders as r_table  
on l_table.website_session_id = r_table.website_session_id
group by time_period, l_table.website_session_id;

select * 
from orders
where created_at between '2013-08-25' and '2013-10-25';

select
l_table.website_session_id
,l_table.pageview_url
,l_table.time_period
,r_table.items_purchased
,r_table.order_id 
,r_table.price_usd 
from p_cart_performance as l_table
right join orders as r_table  
on l_table.website_session_id = r_table.website_session_id;

select
l_table.website_session_id
,l_table.pageview_url
,l_table.time_period
,r_table.items_purchased
,r_table.order_id 
,r_table.price_usd 
from p_cart_performance as l_table
left join orders as r_table  
on l_table.website_session_id = r_table.website_session_id;

create temporary table sample
select
l_table.website_session_id
,l_table.pageview_url
,l_table.time_period
,r_table.items_purchased
,r_table.order_id 
,r_table.price_usd 
from p_cart_performance as l_table
left join orders as r_table  
on l_table.website_session_id = r_table.website_session_id;

select * 
from sample;

select 
time_period
,items_purchased
,count(distinct website_session_id) as total_session
,count(distinct order_id) as total_order
,sum(items_purchased)
,sum(price_usd)
from sample
group by 1, 2;