select 
	year(website_sessions.created_at) AS yr,  
    week(website_sessions.created_at) as wk,
    min(Date(website_sessions.created_at)) as week_start, 
	count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.order_id) as orders
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < '2013-01-01'
group by 1, 2;