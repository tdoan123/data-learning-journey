# [Patient Support Analysis (Part 1)](https://datalemur.com/questions/frequent-callers)



## Solution 
```
select
count(policy_holder_id) as policy_holder_count
from
(SELECT 
policy_holder_id,
count(DISTINCT case_id) as policy_holder_count
FROM callers
group by policy_holder_id
HAVING count (DISTINCT case_id) >= 3) as filter1;
```