# [Median Google Search Frequency](https://datalemur.com/questions/median-search-freq)

## Description
Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: the median number of searches a person made last year.

However, at Google scale, querying the 2 trillion searches is too costly. Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

Write a query to report the median of searches made by a user. Round the median to one decimal point.

`search_frequency` Table:
| Column Name | Type    |
|------------|---------|
| searches   | integer |
| num_users  | integer |

`search_frequency` Example Input:

| searches | num_users |
|----------|-----------|
| 1        | 2         |
| 2        | 2         |
| 3        | 3         |
| 4        | 1         |

## Approach
Learn 2 news functions: 
`generate_series(1,__)` to generate a series of value  

`percentile_cont(0.50) within group (order by __)` to return median of a list of a series
[table 9.62](https://www.postgresql.org/docs/current/functions-aggregate.html#FUNCTIONS-ORDEREDSET-TABLE)

## Keywords

## Solution
```
with searches_expanded as 
(
SELECT searches
FROM search_frequency
GROUP BY 
  searches, 
  GENERATE_SERIES(1, num_users) -- to turn 2 columns in to a series of value
order by searches
)

select 
  round(percentile_cont(0.50) within group 
  (order by searches)::Decimal, 1 ) as median  
from searches_expanded
```