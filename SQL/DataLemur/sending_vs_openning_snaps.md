# [Sending vs. Opening Snaps](https://datalemur.com/questions/time-spent-snaps)

## Description
Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

Notes:

Calculate the following percentages:
- time spent sending / (Time spent sending + Time spent opening)
- Time spent opening / (Time spent sending + Time spent opening)
- To avoid integer division in percentages, multiply by 100.0 and not 100.

## Thoughts

`activities` Table
| Column Name   | Type                            |
|---------------|---------------------------------|
| activity_id   | integer                         |
| user_id       | integer                         |
| activity_type | string ('send', 'open', 'chat') |
| time_spent    | float                           |
| activity_date | datetime                        |



`activities` Example Input
| activity_id | user_id | activity_type | time_spent | activity_date       |
|-------------|---------|---------------|------------|---------------------|
| 7274        | 123     | open          | 4.50       | 06/22/2022 12:00:00 |
| 2425        | 123     | send          | 3.50       | 06/22/2022 12:00:00 |
| 1413        | 456     | send          | 5.67       | 06/23/2022 12:00:00 |
| 1414        | 789     | chat          | 11.00      | 06/25/2022 12:00:00 |
| 2536        | 456     | open          | 3.00       | 06/25/2022 12:00:00 |

`age_breakdown` Table
| Column Name | Type                               |
|-------------|------------------------------------|
| user_id     | integer                            |
| age_bucket  | string ('21-25', '26-30', '31-25') |

`age_breakdown` Example Input
| user_id | age_bucket |
|---------|------------|
| 123     | 31-35      |
| 456     | 26-30      |
| 789     | 21-25      |


`Example` Output
| age_bucket | send_perc | open_perc |
|------------|-----------|-----------|
| 26-30      | 65.40     | 34.60     |
| 31-35      | 43.75     | 56.25     |


## Thoughts
- left join table `age_breakdown` to table `activties` to identify the age_group of each user 
- remove `chat` activity in `activity_type` column. 
```
  SELECT
  DISTINCT(activity_type) 
  from activities;
```
to confirm different type of activities recorded in this column  

- `group by` age_bucket as dimension 
- sum(time spent sending) / (sum(Time spent sending) + sum(Time spent opening)) as agreegate 1
- sum(Time spent opening) / (sum(Time spent sending) + sum(Time spent opening)) as agreegate 2


```
-- To get the total_time_spent for both activities (open and send)
SELECT
user_id, 
sum(time_spent) as total_time_spent
FROM
(SELECT *
FROM activities
WHERE activity_type != 'chat') AS filter_1
group by user_id;

output: 
| user_id | total_time_spent |
|---------|------------------|
| 789     | 11.49            |
| 456     | 16.91            |
| 123     | 9.25             |

--  apporach 2: using this, i dont have to filter activity_type
select  
user_id, 
SUM(CASE 
        WHEN activity_type IN ('open', 'send') THEN time_spent
        ELSE 0
    END) AS total_time_spent
FROM activities
group by user_id;
```


```
select
age_bucket,
send_perc,
open_perc
from
(select 
a.user_id, 
CASE WHEN activity_type = 'send' then round(time_spent/total_time_spent * 100.0,2) else 0 end as send_perc,
CASE WHEN activity_type = 'open' then round(time_spent/total_time_spent * 100.0,2) else 0 end as open_perc
from activities as a 
left JOIN  
(select  
user_id, 
SUM(CASE 
        WHEN activity_type IN ('open', 'send') THEN time_spent
        ELSE 0
    END) AS total_time_spent
FROM activities
group by user_id) as b
on a.user_id = b.user_id
where activity_type != 'chat') as filter1
left join age_breakdown
on filter1.user_id = age_breakdown.user_id
;


| age_buckets | send_perc | open_perc |
|-------------|-----------|-----------|
| 31-35       | 0         | 13.51     |
| 31-35       | 37.84     | 0         |
| 31-35       | 0         | 48.65     |
| 26-30       | 48.73     | 0         |
| 26-30       | 0         | 17.74     |
| 26-30       | 33.53     | 0         |
| 21-25       | 0         | 45.69     |
| 21-25       | 54.31     | 0         |

!!! this is happening because I didnot use max() function before the case when to instruct sql to select only 1 value. currently sql is understanding that there are two values of age_buckets `31-35`, which are `0` and `37.84`. using `max()` tell sql to only select the highest value for dim `31-35` for column `send_perc`. same as `open_perc` 

!!! there are more than one ocassion where activity_type is either `open` or `send` => I need to get the total value by using group by get the total_time_spent of each activity_type
```

```
select 
a.user_id, 
activity_type,
sum(time_spent) as time_spent_by_activity,
b.total_time_spent
-- CASE WHEN activity_type = 'send' then round(time_spent/total_time_spent * 100.0,2) else 0 end as send_perc,
-- CASE WHEN activity_type = 'open' then round(time_spent/total_time_spent * 100.0,2) else 0 end as open_perc
from activities as a 
left JOIN  
(select  
user_id, 
SUM(CASE 
        WHEN activity_type IN ('open', 'send') THEN time_spent
        ELSE 0
    END) AS total_time_spent
FROM activities
group by user_id) as b
on a.user_id = b.user_id
where activity_type != 'chat'
group by a.user_id, activity_type, b.total_time_spent
order by a.user_id;

Output: 
| user_id | activity_type | time_spent_by_activity | total_time_spent |
|---------|---------------|------------------------|------------------|
| 123     | open          | 5.75                   | 9.25             |
| 123     | send          | 3.50                   | 9.25             |
| 456     | open          | 3.00                   | 16.91            |
| 456     | send          | 13.91                  | 16.91            |
| 789     | open          | 5.25                   | 11.49            |
| 789     | send          | 6.24                   | 11.49            |


```

## Solution 
```
select
age_bucket,
send_perc,
open_perc
from
(select
user_id, 
Max(case when activity_type = 'send' then round(time_spent_by_activity/total_time_spent *100.0, 2) else 0 end) as send_perc,
max(case when activity_type = 'open' then round(time_spent_by_activity/total_time_spent *100.0, 2) else 0 end) as open_perc
from(
select 
a.user_id, 
activity_type,
sum(time_spent) as time_spent_by_activity,
b.total_time_spent
from activities as a 
left JOIN  
(select  
user_id, 
SUM(CASE 
        WHEN activity_type IN ('open', 'send') THEN time_spent
        ELSE 0
    END) AS total_time_spent
FROM activities
group by user_id) as b
on a.user_id = b.user_id
where activity_type != 'chat'
group by a.user_id, activity_type, b.total_time_spent
order by a.user_id) as filter1
group by user_id) filter2
left join age_breakdown

Output

| age_buckets | send_perc | open_perc |
|-------------|-----------|-----------|
| 21-25       | 54.31     | 45.69     |
| 26-30       | 82.26     | 17.74     |
| 31-35       | 37.84     | 62.16     |
```