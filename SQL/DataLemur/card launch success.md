# [Card Launch Success](https://datalemur.com/questions/card-launch-success)

## Description
Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.

Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.

Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued amount.

| Column Name | Type |
|------------|-------|
| issue_month | integer |
| issue_year | integer |
| card_name | string |
| issued_amount | integer |


| issue_month | issue_year | card_name | issued_amount |
|-------------|------------|-----------|---------------|
| 1 | 2021 | Chase Sapphire Reserve | 170000 |
| 2 | 2021 | Chase Sapphire Reserve | 175000 |
| 3 | 2021 | Chase Sapphire Reserve | 180000 |
| 3 | 2021 | Chase Freedom Flex | 65000 |
| 4 | 2021 | Chase Freedom Flex | 70000 |

| card_name | issued_amount |
|-----------|---------------|
| Chase Sapphire Reserve | 170000 |
| Chase Freedom Flex | 65000 |
## Approach
- Combine month and year columns into one  
- then rank the first issuance of each card type 
  
## Keywords
`MAKE_DATE( year int, month int, day int )` → date

## Solutions

```
with filter as
(
SELECT 
card_name
,issued_amount
,TO_CHAR(MAKE_DATE(issue_year, issue_month, 1), 'YYYY-MM') AS year_month
FROM monthly_cards_issued
),

filter_2 as
(
select 
card_name
,issued_amount
,rank() over (PARTITION by card_name order by year_month) as ranking
from filter
)

select 
card_name
,issued_amount
from filter_2
where ranking = 1
order by issued_amount DESC
```