# [Compressed Mean](https://datalemur.com/questions/alibaba-compressed-mean)

## Description 
You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes information on the count of items in each order (item_count table) and the corresponding number of orders for each item count (order_occurrences table).

## items_per_order Table:
Column Name	Type
item_count	integer
order_occurrences	integer
items_per_order Example Input:
item_count	order_occurrences
1	500
2	1000
3	800
4	1000

## Thoughts 
- Learn something new. As DataLemur use PostgreSQL14, not MySQL therefore Round() is different. For PostgreSQL, i need to insert `::numeric` right after the numerator to enforce the datatype being used for the function. Without `::numeric` there will be error as below
   
```Error
function round(double precision, integer) does not exist (LINE: 2) 
```
## Solution


```
SELECT
ROUND(SUM(total_item)::numeric  / sum(order_occurrences),1) as mean 
from (SELECT 
item_count,
order_occurrences,
item_count * order_occurrences as total_item 
FROM items_per_order) as filter1;
```