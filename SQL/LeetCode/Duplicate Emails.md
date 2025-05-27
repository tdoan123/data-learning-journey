
## Solution

```sql
with temp as 
(
select email,
row_number() over(partition by email) as rnk
from person
)

select distinct email 
from temp 
where rnk > 1
```