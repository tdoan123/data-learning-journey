# [Odd and Even Measurements](https://datalemur.com/questions/odd-even-measurements)
- [Odd and Even Measurements](#odd-and-even-measurements)
  - [Description](#description)
  - [Solution](#solution)
  - [keywords:](#keywords)



## Description
Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. Refer to the Example Output below for the desired format.

Definition:

Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.

`measurements` Table:
| Column Name | Type |
|------------|------|
| measurement_id | integer |
| measurement_value | decimal |
| measurement_time | datetime |

`measurements` Example Input:
| measurement_id | measurement_value | measurement_time |
|---------------|-----------------|-------------------|
| 1312331 | 109.51 | 07/10/2022 09:00:00 |
| 1352111 | 662.74 | 07/10/2022 11:00:00 |
| 5235421 | 246.24 | 07/10/2022 13:15:00 |
| 1435621 | 124.50 | 07/11/2022 15:00:00 |
| 3464621 | 234.14 | 07/11/2022 16:45:00 |

`Example` Output:
| measurement_day | odd_sum | even_sum |
|-----------------|---------|----------|
| 07/10/2022 00:00:00 | 2355.75 | 662.74 |
| 07/11/2022 00:00:00 | 1124.50 | 1234.14 |

## Solution
```
with daily_rank as (
  select 
  date(measurement_time) as measurement_day,
  measurement_value,
  measurement_time,  
  row_number() over (
        PARTITION BY date(measurement_time) 
        ORDER BY measurement_time) AS measurement_num  
  from measurements
  )
  
select 
measurement_day,
sum(case when measurement_num % 2 != 0 then measurement_value else null end) as odd_num, 
sum(case when measurement_num % 2 = 0 then measurement_value else null end) as even_num
from daily_rank
group by measurement_day
```

## keywords:  
`with [ ] as` ,  `date()`,  `row_number() over ( [] order by )` , `partition by`   