/* Assignment: Landing page trend analysis  Landing page trend analysis  
requirement:  
- data period: from jun 1st to aug 31th 2012 
- condition: 
	table `website_sessions`: paid search (i.e. 'gsearch') and utm_campaign = 'nonbrand'  
    table `website_pageviews`: landed on  `/home' or '/land-1' only
- metrics: 
	week_start_date:  
    total_bounce_rate: total_website_session_id with only 1 value (has only one website_pageview_id) / total_website_session_id  
	home_sessions: total session that land on `/home` 
    lander_sessions: total session that land on `/lander'  
    add two more columns: bounce rate per land page => extra request I put in
*/

/*Step 1: queries data that match the condition and within this period*/ 
create temporary table tb_condition_filter
select 
wp.website_pageview_id,
wp.created_at,
wp.website_session_id,
wp.pageview_url
from website_pageviews as wp 
inner join website_sessions as ws
on ws.website_session_id = wp.website_session_id
where wp.created_at between '2012-06-01' and '2012-08-31'
and ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand'
and wp.pageview_url in ('/home', '/lander-1');


create temporary table tb_condition_filter2
select 
wp.website_pageview_id,
wp.created_at,
wp.website_session_id,
wp.pageview_url
from website_pageviews as wp 
inner join website_sessions as ws
on ws.website_session_id = wp.website_session_id
where wp.created_at between '2012-06-01' and '2012-08-31'
and ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand';

/* get website_session_id that landed on either '/home' or '/lander-1' then create a new table for this value */
create temporary table tb_condition_filter3
select 
website_session_id,
min(created_at) as first_pageview
from tb_condition_filter2 as left_table
where pageview_url in ('/home', '/lander-1')
group by website_session_id;

/* map the website_session_id in tb_condition_filter3 back to as website_pageview table */ 
create temporary table tb_condition_clean
select 
wp.website_pageview_id,
wp.created_at,
wp.website_session_id,
wp.pageview_url
from website_pageviews as wp
join tb_condition_filter3 as filter3  
on wp.website_session_id = filter3.website_session_id;

/* count the number webpage per session */  
select
yearweek(created_at) as year_week,
min(date(created_at)) as week_start_date, 
count(distinct website_session_id) as Total_Session,  
round(count(Bounce = 'Yes') / count(distinct website_session_id) * 100, 2) as Total_Bounce_Rate,
sum(Landed_on_Home) as Total_Landed_on_Home,
sum(Landed_on_Lander_1) as Total_Landed_on_Lander_1   
from (select
website_session_id,
created_at,
case when count(website_pageview_id) = 1 then 'Yes' else 'No' end as 'Bounce', 
max(case when pageview_url = '/home' then 1 else 0 end) as 'Landed_on_Home', 
max(case when pageview_url = '/lander-1' then 1 else 0 end) as 'Landed_on_Lander_1', 
count(website_pageview_id) as pageview_count_by_session
from tb_condition_clean
group by website_session_id, created_at) as final_table
group by year_week;

-- draft: checking work  
-- how many website_session_id? total there were 8862 sessions in the period. This exclude web session landed 1st time on other urls that is not either /home or /lander-1
select
year_week,
min(week_start_date)  as week_start_date, 
count(distinct website_session_id) as Total_Session,
sum(Bounce) as Bounce_Count,  
round(sum(Bounce) / count(distinct website_session_id) * 100, 2) as Total_Bounce_Rate,
sum(Landed_on_Home) as Total_Landed_on_Home,
sum(Landed_on_Lander_1) as Total_Landed_on_Lander_1   
from (select
yearweek(created_at) as year_week,
website_session_id,
min(date(created_at)) as week_start_date,
case when count(website_pageview_id) = 1 then 1 else 0 end as 'Bounce', 
max(case when pageview_url = '/home' then 1 else 0 end) as 'Landed_on_Home', 
max(case when pageview_url = '/lander-1' then 1 else 0 end) as 'Landed_on_Lander_1', 
count(website_pageview_id) as pageview_count_by_session
from tb_condition_clean
group by yearweek(created_at), website_session_id) as final_table
group by year_week;



select
yearweek(created_at) as year_week,
-- created_at,
website_session_id,
case when count(website_pageview_id) = 1 then 1 else 0 end as 'Bounce', 
max(case when pageview_url = '/home' then 1 else 0 end) as 'Landed_on_Home', 
max(case when pageview_url = '/lander-1' then 1 else 0 end) as 'Landed_on_Lander_1', 
count(website_pageview_id) as pageview_count_by_session
from tb_condition_clean
group by yearweek(created_at), website_session_id ;



select * 
from website_pageviews
where website_pageview_id = 18606;

select * 
from website_pageviews
where website_session_id = 9351;

select
website_session_id,
date_sub(min(created_at), Interval weekday(min(created_at)) day) as week_start_date,
case when count(website_pageview_id) = 1 then 'Yes' else 'No' end as 'Bounce', 
max(case when pageview_url = '/home' then 1 else 0 end) as 'Landed on Home', 
max(case when pageview_url = '/lander-1' then 1 else 0 end) as 'Landed on Lander-1', 
count(website_pageview_id) as pageview_count_by_session
from tb_condition_clean
group by website_session_id;


select * 
from tb_condition_clean;

-- how many website_session_id? total there were 11625 sessions in the period. This include web session landed 1st time on other urls that is not either /home or /lander-1
select
count(distinct website_session_id) as total_website_session
from tb_condition_filter2;

select 
pageview_url,
count(pageview_url)
from tb_condition_filter2
group by pageview_url;

select * 
from tb_condition_filter2; 

select
utm_source
from website_sessions
group by utm_source;

select
utm_campaign
from website_sessions
group by utm_campaign;

-- to check if there are other values in pageview_url that are different with the one being requested
select 
pageview_url,
count(pageview_url)
from tb_condition_filter
group by pageview_url;

select 
week(created_at) as week_no,
min(created_at) as week_start_date,
count(website_session_id)
from tb_condition_filter
group by week_no;


select * 
from tb_condition_filter;
