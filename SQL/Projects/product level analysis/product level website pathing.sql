
create temporary table products_pageviews 
select  
	website_session_id
    ,website_pageview_id
    ,created_at  
    ,case 
		when created_at < '2013-01-06' then 'A. Pre_Product_2'
        when created_at >= '2013-01-06' then 'B. Post_Product_2'   
        else null  
	end as time_period 
from website_pageviews
where created_at < '2013-04-06'  
	and created_at > '2012-10-06'
    and pageview_url = '/products';
    
create temporary table sessions_w_next_pageview_id    
select 
	products_pageviews.time_period, 
    products_pageviews.website_session_id, 
    min(website_pageviews.website_pageview_id) as min_next_pageview_id 
from products_pageviews
	left join website_pageviews 
		on website_pageviews.website_session_id = products_pageviews.website_session_id
        and website_pageviews.website_pageview_id > products_pageviews.website_pageview_id 
group by 1, 2;

-- step3: finf a pageview_url assosicated with any applicable next pageview id 
create temporary table sessions_w_next_pageview_url
select 
sessions_w_next_pageview_id.time_period
,sessions_w_next_pageview_id.website_session_id
,website_pageviews.pageview_url as next_pageview_url
from sessions_w_next_pageview_id
	left join website_pageviews
		on website_pageviews.website_pageview_id = sessions_w_next_pageview_id.min_next_pageview_id;

-- step 4: summarize the data and analyze the pre & post periods 
select 
	time_period 
    ,count(distinct website_session_id) as sessions
    ,count(distinct case when next_pageview_url is not null then website_session_id else null end) as w_next_pg
    ,count(distinct case when next_pageview_url is not null then website_session_id else null end) / count(distinct website_session_id) as pct_w_next_pg 
    ,count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end) as to_mrfuzzy
    ,count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end) / count(distinct website_session_id) as pct_to_mrfuzzy
    ,count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else null end) as to_lovebear
    ,count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else null end) / count(distinct website_session_id) as pct_to_lovebear
from sessions_w_next_pageview_url
group by time_period

        
        