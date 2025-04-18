/* Assignment: Landing page trend analysis  Landing page trend analysis  
- condition: 
	table `website_sessions`: paid search (i.e. 'gsearch')  
    table `website_pageviews`: start from  '/lander-1' to '/thank you'
    table `website_sessions`: from AUG 05 to SEP 05 2012 
- metrics: 
	total number of session 
    total number of session for each 'page' for each column  
    convertion rate:  total visited of each page devided by the total visited of the prior page 
*/

-- queries  

/* table `filter1` filter information required in the condition documented above */ 
CREATE temporary TABLE FILTER1
select  
wp1.website_pageview_id,
wp1.created_at, 
wp1.website_session_id,
wp1.pageview_url
from website_pageviews as wp1
join 
(select 
wp.website_session_id,
min(wp.website_session_id) as min_website_session_id
from website_pageviews as wp
left join website_sessions as ws
on wp.website_session_id = ws.website_session_id
where ws.utm_source = 'gsearch'
and ws.created_at between '2012-08-05' and '2012-09-05'
group by wp.website_session_id) as right_table 
on wp1.website_session_id = right_table.website_session_id ; 

/* check for 1st landing that is not /lander-1 then assigned the final table into web_pageview_clean */  
CREATE temporary TABLE web_pageview_clean 
select 
wp.website_pageview_id,
wp.created_at,
wp.website_session_id,
wp.pageview_url
from website_pageviews as wp
join (select 
website_session_id,
min(created_at) as first_session 
from filter1
where pageview_url = '/lander-1' 
group by website_session_id) as right_table
on wp.website_session_id = right_table.website_session_id;

/* to check for a list of value from pageview_url */ 
select 
pageview_url,
count(distinct website_pageview_id)
from web_pageview_clean
group by pageview_url;
--  '/billing' - '/cart' - '/lander-1' - '/products' - '/shipping' - '/thank-you-for-your-order' - '/the-original-mr-fuzzy' 

select * 
from web_pageview_clean;

/* assign a value into it correponding value from pageview_url  */
CREATE temporary TABLE pivot_table
select 
website_pageview_id, 
created_at, 
website_session_id, 
pageview_url,
case when pageview_url = '/billing' then 1 else 0 end as p_billing,
case when pageview_url = '/cart' then 1 else 0 end as p_cart,
case when pageview_url = '/lander-1' then 1 else 0 end as p_lander,
case when pageview_url = '/products' then 1 else 0 end as p_products,
case when pageview_url = '/shipping' then 1 else 0 end as p_shipping,
case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as p_thank_you,
case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as p_mr_fuzzy
from web_pageview_clean;

select * 
from pivot_table; 

-- website_pageview_id, created_at, website_session_id, pageview_url, p_billing, p_cart, p_lander, p_products, p_shipping, p_thank_you, p_mr_fuzzy
select
website_session_id,
max(p_lander) as p_lander, 
max(p_mr_fuzzy) as p_mr_fuzzy,
max(p_products) as p_products,
max(p_cart) as p_cart, 
max(p_billing) as p_billing, 
max(p_shipping) as p_shipping, 
max(p_thank_you) as p_thank_you 
from pivot_table
group by website_session_id;


select
count(distinct case when p_lander = 1 then website_session_id else null end) as total_visit,
count(distinct case when p_products = 1 then website_session_id else null end) as p_products,
round(count(distinct case when p_products = 1 then website_session_id else null end) / count(distinct case when p_lander = 1 then website_session_id else null end) * 100, 2) as bounce_rate,
count(distinct case when p_mr_fuzzy = 1 then website_session_id else null end) as p_mr_fuzzy,
round(count(distinct case when p_mr_fuzzy = 1 then website_session_id else null end) / count(distinct case when p_products = 1 then website_session_id else null end) *100, 2) as bounce_rate,
count(distinct case when p_cart = 1 then website_session_id else null end) as p_cart,
round(count(distinct case when p_cart = 1 then website_session_id else null end) / count(distinct case when p_mr_fuzzy = 1 then website_session_id else null end) *100, 2) as bounce_rate,
count(distinct case when p_billing = 1 then website_session_id else null end) as p_billing,
round(count(distinct case when p_billing = 1 then website_session_id else null end) / count(distinct case when p_cart = 1 then website_session_id else null end) *100, 2) as bounce_rate,
count(distinct case when p_shipping = 1 then website_session_id else null end) as p_shipping,
round(count(distinct case when p_shipping = 1 then website_session_id else null end) / count(distinct case when p_billing = 1 then website_session_id else null end) * 100, 2) as bounce_rate,
count(distinct case when p_thank_you = 1 then website_session_id else null end) as p_thank_you,
round(count(distinct case when p_thank_you = 1 then website_session_id else null end) / count(distinct case when p_shipping = 1 then website_session_id else null end)*100, 2) as bounce_rate
from pivot_table;


/* check for 1st landing that is not /lander-1  */  
select
count(website_session_id) 
from
(select 
website_session_id,
min(created_at) as first_session 
from filter1
group by website_session_id) as checking;
-- without filtering first page landing is 'lander-1', there are 4699 unique web session 

select
count(website_session_id) 
from
(select 
website_session_id,
min(created_at) as first_session 
from filter1
where pageview_url = '/lander-1' 
group by website_session_id) as checking;
-- filtering first page landing is 'lander-1', there are 4493 unique web session 

/*just learned that approach above has created additional row for the dataset.  

-- checking  
select
*
from website_pageviews
where website_session_id = 18244;
-- count how many website_session_id 
select
count(distinct checking.website_session_id)
from
(select 
wp.website_pageview_id,
wp.created_at, 
wp.website_session_id,
wp.pageview_url
from website_pageviews as wp
join website_sessions as ws 
on wp.website_session_id = ws.website_session_id
where ws.utm_source = 'gsearch'
and ws.created_at between '2012-08-05' and '2012-09-05') as checking
-- return 4699 unique value.  