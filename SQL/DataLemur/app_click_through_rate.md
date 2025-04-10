Assume you have an events table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.

Definition and note:

- Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
- To avoid integer division, multiply the CTR by 100.0, not 100.

'**events**' Table:

| Column Name| Type | 
|--| -- |
| app_id | 	integer
| event_type |	string
| timestamp | 	datetime

**events Example Input**:
| app_id |	event_type | timestamp |
| -- | -- | -- |
| 123 |	impression |	07/18/2022 11:36:12|
|123    |	impression |	07/18/2022 11:37:12
|123    |	click   |	07/18/2022 11:37:42
|234    |	impression  |	07/18/2022 14:15:12
|234    |	click   |	07/18/2022 14:16:12

Example Output:
|app_id	|ctr
|--|  -- |
|123	 |50.00
|234	|100.00


## Requirement analysis: 
- agg: 
  1) number of impression
  2) number click
  3) number of click / number of imressions. make sure to round 2 decimals 
- dim: 
  - group by `app_id` 
- others: 
  - check for timestamp = 2022

## Solution:
```
PostgreSQL14 

SELECT
  app_id
  ,ROUND(
    (SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) * 100.0) /
    NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 0),
    2
  ) AS ctr
FROM events
WHERE EXTRACT(Year from TIMESTAMP) = 2022
GROUP BY app_id;
```