select
yearweek(created_at) as yrwk,  
count(distinct website_session_id) as total_sessions 
from website_sessions 
where created_at >  '2012-08-22' 
	and created_at < '2012-11-29'  
    and utm_campaign = 'nonbrand'
group by yrwk;