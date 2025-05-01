
create temporary table sessions_seeing_product_pages
select  
	website_session_id
    ,website_pageview_id
    ,case 
		when pageview_url = '/the-original-mr-fuzzy' then 'mrfuzzy'
        when pageview_url = '/the-forever-love-bear' then 'lovebear'  
        else null  
	end as product_seen 
from website_pageviews
where created_at < '2013-04-10'  
	and created_at > '2013-01-06'
    and pageview_url in ('/the-original-mr-fuzzy','/the-forever-love-bear');
    
create temporary table sessions_seeing_product_pages_url_path
select 
	sessions_seeing_product_pages.product_seen 
    ,sessions_seeing_product_pages.website_session_id 
    ,website_pageviews.website_pageview_id as next_pageview_id 
    ,website_pageviews.pageview_url
from sessions_seeing_product_pages
	left join website_pageviews 
		on website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        and website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id 
group by 1, 2, 3,4;

/*
# pageview_url
'/cart'
'/shipping'
'/billing-2'
'/thank-you-for-your-order'
*/  

select 
product_seen
,count(distinct website_session_id) as total_session 
,sum(case when pageview_url = '/cart' then 1 else null end) as to_cart
,sum(case when pageview_url = '/shipping' then 1 else null end) as to_shipping
,sum(case when pageview_url = '/billing-2' then 1 else null end) as to_billing
,sum(case when pageview_url = '/thank-you-for-your-order' then 1 else null end) as to_thank_you
from sessions_seeing_product_pages_url_path
group by 1;

select 
product_seen
,round(100 * sum(case when pageview_url = '/cart' then 1 else null end) / count(distinct website_session_id), 2) as product_page_click_rt
,round(100 * sum(case when pageview_url = '/shipping' then 1 else null end) / sum(case when pageview_url = '/cart' then 1 else null end), 2) as shipping_click_rt
,round(100 * sum(case when pageview_url = '/billing-2' then 1 else null end) / sum(case when pageview_url = '/shipping' then 1 else null end), 2) as billing_click_rt
,round(100 * sum(case when pageview_url = '/thank-you-for-your-order' then 1 else null end) / sum(case when pageview_url = '/billing-2' then 1 else null end), 2)  as thankyou_click_rt
from sessions_seeing_product_pages_url_path
group by 1;






