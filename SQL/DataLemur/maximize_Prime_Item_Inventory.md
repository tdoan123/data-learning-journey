
## Solution 
```
with summary as 
(
SELECT 
item_type,
sum(square_footage) as total_prime_sqft,
count(*) as item_count
FROM inventory
group by item_type
),
prime_occupied_area AS 
(
select
  item_type, 
  total_prime_sqft,  
  floor(500000.00/total_prime_sqft) as  prime_item_batch_count,
  (floor(500000.00/total_prime_sqft) * item_count) as primary_item_count
From summary 
where item_type = 'prime_eligible'
)

SELECT
  item_type,
  CASE 
    WHEN item_type = 'prime_eligible' 
      THEN (FLOOR(500000/total_prime_sqft) * item_count)
    WHEN item_type = 'not_prime' 
      THEN FLOOR((500000 - (SELECT FLOOR(500000/total_prime_sqft) * total_prime_sqft FROM prime_occupied_area)) / total_prime_sqft) * item_count
  END AS item_count
FROM summary
ORDER BY item_type DESC;
```
