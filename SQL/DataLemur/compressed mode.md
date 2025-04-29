# [Compressed Mode](https://datalemur.com/questions/alibaba-compressed-mode)


## Description
You're given a table containing the item count for each order on Alibaba, along with the frequency of orders that have the same item count. Write a query to retrieve the mode of the order occurrences. Additionally, if there are multiple item counts with the same mode, the results should be sorted in ascending order.

Clarifications:

item_count: Represents the number of items sold in each order.
order_occurrences: Represents the frequency of orders with the corresponding number of items sold per order.
For example, if there are 800 orders with 3 items sold in each order, the record would have an item_count of 3 and an order_occurrences of 800.

| Column Name | Type |
|------------|-------|
| item_count | integer |
| order_occurrences | integer |

| item_count | order_occurrences |
|------------|-------------------|
| 1 | 500 |
| 2 | 1000 |
| 3 | 800 |

| mode |
|------|
| 2    |

## Approach  
- search for the highest value in column order_occurrences 


## Keywords 
- `mode() within group ()`
- `max()`  

## solution
```
-- using mode()  
select item_count
from items_per_order
where order_occurrences = 
  (
  SELECT 
    MODE() WITHIN GROUP (ORDER BY order_occurrences DESC)
  FROM items_per_order
  )
order by item_count
```


```
-- using max() 
select item_count
from items_per_order
where order_occurrences = 
  (
  select max(order_occurrences)
  from items_per_order
  )
order by item_count
```


