# [Active User Retention](https://datalemur.com/questions/user-retention)

## Description  
Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

Hint:

An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.
`user_actions` Table:
| Column Name | Type |
|------------|------|
| user_id | integer |
| event_id | integer |
| event_type | string ("sign-in", "like", "comment") |
| event_date | datetime |

`user_actionsExample` Input:
| user_id | event_id | event_type | event_date |
|---------|---------|-----------|------------|
| 445776 | 5 | sign-in | 05/31/2022 12:00:00 |
| 742645 | 8 | sign-in | 06/03/2022 12:00:00 |
| 445363 | 4 | like | 06/05/2022 12:00:00 |
| 742137 | 4 | comment | 06/05/2022 12:00:00 |
| 648312 | 4 | like | 06/18/2022 12:00:00 |

## Approach 
- first create partition by month and user_id  
- filter the timeline to July and check for ranking more than 1. Notes: this solution is only work for this simple data set as if the sample is larger

## Keywords
`date_part('Month',__)`
`rank() over (partition by __ orderby __ ) `

## Solution
```
with filter_1 as  
(select
date_part('MONTH',event_date) as month,  
user_id,
rank() over (PARTITION by user_id order by date_part('MONTH',event_date)) as ranking
from user_actions
group by date_part('MONTH',event_date),user_id
order by user_id)

select
month
,count(DISTINCT user_id)
from filter_1
where ranking >= 2
and month = 7
group by month;
```
