# [Histogram of Users and Purchases](https://datalemur.com/questions/histogram-users-purchases)

## Description  

Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

Output the user's **most recent transaction date**, **user ID**, and **the number of products**, **sorted in chronological order by the transaction date**.

`user_transactions` Table:

| Column Name | Type |
|------------|-------|
| product_id | integer |
| user_id | integer |
| spend | decimal |
| transaction_date | timestamp |

`user_transactions` example input:  

| product_id | user_id | spend | transaction_date |
|------------|---------|-------|------------------|
| 367 | 123 | 68.90 | 07/08/2022 12:00:00 |
| 962 | 123 | 274.10 | 07/08/2022 12:00:00 |
| 146 | 115 | 19.90 | 07/08/2022 12:00:00 |
| 251 | 159 | 25.00 | 07/08/2022 12:00:00 |
| 145 | 159 | 74.50 | 07/10/2022 12:00:00 |

Example Output:

| transaction_date | user_id | purchase_count |
|------------------|---------|----------------|
| 07/08/2022 12:00:00 | 115 | 1 |
| 07/08/2022 12:00:00 | 123 | 2 |
| 07/10/2022 12:00:00 | 159 | 1 |


## Approach  
- use  rank() or row_number() over (partition by user_id order by transaction_date desc) to get the value of the latest transaction of each user 
- then assign the table to CTE 
- then search the count for the number of `spend` with condition of ranking = 1 

## keyword
`row_number() over (partition by ____ order by ___ )` or 
`rank() over (partition by __ order by __`

## Solution
```
with date_sort as 
(
select  
user_id, 
spend,
transaction_date,
rank() over (PARTITION by user_id order by transaction_date desc) as date_sort
from user_transactions 
)

select 
transaction_date
,user_id
,count(spend) as purchase_count
from date_sort  
where date_sort = 1
group by transaction_date, user_id
```
