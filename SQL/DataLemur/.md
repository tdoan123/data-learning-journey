# [Server Utilization Time](https://datalemur.com/questions/total-utilization-time)

## Description
Amazon Web Services (AWS) is powered by fleets of servers. Senior management has requested data-driven solutions to optimize server usage.

Write a query that calculates the total time that the fleet of servers was running. The output should be in units of full days.

Assumptions:

Each server might start and stop several times.
The total time in which the server fleet is running can be calculated as the sum of each server's uptime.

`server_utilization` Table:
| Column Name | Type |
|------------|------|
| server_id | integer |
| status_time | timestamp |
| session_status | string |

`server_utilization` Example Input:
| server_id | status_time | session_status |
|-----------|-------------------|---------------|
| 1 | 08/02/2022 10:00:00 | start |
| 1 | 08/04/2022 10:00:00 | stop |
| 2 | 08/17/2022 10:00:00 | start |
| 2 | 08/24/2022 10:00:00 | stop |

## Approach  
- separate the current table into 2 different tables. one is for start_time, another is stop_time  
- merge the two tables together with conditions that stop_time table has to higher than the start_time table. then in the select, use min() to get the earlies stop_time in the same role with the start_time  
- use extract(hour from __) to get the hours from each start_time and stop_time row  

## Keyword
extract(hour from ___)


## Solution
```
WITH starts AS (
  SELECT server_id, status_time
  FROM server_utilization
  WHERE session_status = 'start'
),
stops AS (
  SELECT server_id, status_time
  FROM server_utilization
  WHERE session_status = 'stop'
)

SELECT 
  s.server_id,
  s.status_time AS start_time,
  MIN(e.status_time) AS stop_time
FROM starts s
JOIN stops e
  ON s.server_id = e.server_id
  AND e.status_time > s.status_time
GROUP BY s.server_id, s.status_time
ORDER BY s.server_id, start_time;

select
sum(EXTRACT(HOUR from stop_time - start_time)) as total_uptime_days
from total_time;

```