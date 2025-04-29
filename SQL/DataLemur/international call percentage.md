# [International Call Percentage](https://datalemur.com/questions/international-call-percentage)

## Description  
A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

What percentage of phone calls are international? Round the result to 1 decimal.

Assumption:

The caller_id in phone_info table refers to both the caller and receiver.

| Column Name | Type |
|------------|------|
| caller_id | integer |
| receiver_id | integer |
| call_time | timestamp |

| caller_id | receiver_id | call_time |
|-----------|-------------|-----------|
| 1 | 2 | 2022-07-04 10:13:49 |
| 1 | 5 | 2022-08-21 23:54:56 |
| 5 | 1 | 2022-05-13 17:24:06 |
| 5 | 6 | 2022-03-18 12:11:49 |

| Column Name | Type |
|------------|------|
| caller_id | integer |
| country_id | integer |
| network | integer |
| phone_number | string |

| caller_id | country_id | network | phone_number |
|-----------|------------|---------|--------------|
| 1 | US | Verizon | +1-212-897-1964 |
| 2 | US | Verizon | +1-703-346-9529 |
| 3 | US | Verizon | +1-650-828-4774 |
| 4 | US | Verizon | +1-415-224-6663 |
| 5 | IN | Vodafone | +91 7503-907302 |
| 6 | IN | Vodafone | +91 2287-664895 |

| international_calls_pct |
|-----------------------|
| 50.0 |


## Approach  
- double join (i.e. join 2 tables two times to get assign values from the right table to 2 columns in the left table)
- mindful of the data type in postgree, 

## Keyword
- `:numeric` 


## Solution
```
with map as 
(
select 
p.caller_id 
,p.receiver_id  
,p.call_time
,i.country_id as caller_country
,i.network as caller_network
from phone_calls as p 
left join phone_info as i
on p.caller_id = i.caller_id
),

map2 as
(
select 
m.caller_id
,m.receiver_id 
,m.call_time
,m.caller_network 
,m.caller_country
,i2.country_id as receiver_country
,i2.network as receiver_network
from map as m
left join phone_info as i2
on m.receiver_id = i2.caller_id
)

SELECT
round(100* sum(CASE WHEN caller_country <>receiver_country THEN 1 ELSE 0 END)::NUMERIC /count(*), 1) as international_call_ratio
FROM map2
```