# [Y-on-Y Growth Rate](https://datalemur.com/questions/yoy-growth-rate)

## Description
Assume you're given a table containing information about Wayfair user transactions for different products. Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.

The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.

`user_transactions` Table:
| Column Name | Type |
|-------------|------|
| transaction_id | integer |
| product_id | integer |
| spend | decimal |
| transaction_date | datetime |

`user_transactions` Example Input:
| transaction_id | product_id | spend | transaction_date |
|--------------|------------|--------|-----------------|
| 1341 | 123424 | 1500.60 | 12/31/2019 12:00:00 |
| 1423 | 123424 | 1000.20 | 12/31/2020 12:00:00 |
| 1623 | 123424 | 1246.44 | 12/31/2021 12:00:00 |
| 1322 | 123424 | 2145.32 | 12/31/2022 12:00:00 |

## Approach
- use lag to extract value from prior year  

## Keywords
- `date_part('year', __)` 
- `lag(__) over (partition by __ order by __)`

## Solution
```
Select 
date_part('year', transaction_date) as year
,product_id
,spend as curr_year_spend
,lag(spend) over (PARTITION by product_id order by transaction_date) as prev_year_spend
,round(100 *  (spend / lag(spend) over (PARTITION by product_id order by transaction_date) - 1),2) as yoy_rate 
from user_transactions
```