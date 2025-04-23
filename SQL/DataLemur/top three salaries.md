# [Top Three Salaries](https://datalemur.com/questions/sql-top-three-salaries)
- [Top Three Salaries](#top-three-salaries)
  - [Description](#description)
  - [Approach](#approach)
  - [Solution](#solution)

## Description
As part of an ongoing analysis of salary distribution within the company, your manager has requested a report identifying high earners in each department. A 'high earner' within a department is defined as an employee with a salary ranking among the top three salaries within that department.

You're tasked with identifying these high earners across all departments. Write a query to display the employee's name along with their department name and salary. In case of duplicates, sort the results of department name in ascending order, then by salary in descending order. If multiple employees have the same salary, then order them alphabetically.

Note: Ensure to utilize the appropriate ranking window function to handle duplicate salaries effectively.

`employee` Schema:

| column_name | type | description |
|-------------|------|-------------|
| employee_id | integer | The unique ID of the employee. |
| name | string | The name of the employee. |
| salary | integer | The salary of the employee. |
| department_id | integer | The department ID of the employee. |
| manager_id | integer | The manager ID of the employee. |

`employee` Example Input:
| employee_id | name | salary | department_id | manager_id |
|------------|----------------|--------|--------------|------------|
| 1 | Emma Thompson | 38001 | 6 | 2 |
| 2 | Daniel Rodriguez | 22301 | 7 | 3 |
| 3 | Olivia Smith | 20001 | 8 | 4 |
| 4 | Noah Johnson | 68002 | 9 | 5 |
| 5 | Sophia Martinez | 17501 | 11 | 6 |
| 6 | Liam Brown | 13000 | 3 | 7 |
| 7 | Ava Garcia | 12500 | 3 | 8 |
| 8 | William Davis | 6800 | 2 | 9 |
| 9 | Isabella Wilson | 11000 | 3 | 10 |
| 10 | James Anderson | 40001 | 1 | 1 |


`department` Schema:
| column_name | type | description |
|------------|--------|--------------------------------|
| department_id | integer | The department ID of the employee. |
| department_name | string | The name of the department. |

`department` Example Input:
| department_id | department_name |
|--------------|----------------|
| 1 | Data Analytics |
| 2 | Data Science |

`Example` Output:
| department_name | name | salary |
|----------------|----------------|-------|
| Data Analytics | James Anderson | 40001 |
| Data Analytics | Emma Thompson | 38001 |
| Data Analytics | Daniel Rodriguez | 22301 |
| Data Science | Noah Johnson | 68002 |
| Data Science | William Davis | 6800 |
## Approach
- dimension: department_name, name, salary  
- left join table to get department_name from `employee` table 
- assign ranking for salary of each row.
   - row_number() assign each row an order  
   - rank() assign dupplicate row as the same order and yet skip the order # of dupplicate value  
   - dense_rank() assign duplicate row with the same order and **DO NOT SKIPP** order value on the next order 
- LEARN NEW FUCNTION - DENSE_RANK()  
  ```
  -- use `dense_rank()
  SELECT 
        d.department_name,
        e.name,
        e.salary,
        dense_rank() OVER (PARTITION BY d.department_name ORDER BY e.salary DESC) AS rnk
    FROM employee e
    LEFT JOIN department d ON e.department_id = d.department_id
  ```
  | department_name | name | salary | rnk |
  |-----------------|------|--------|-----|
  | Data Analytics | Olivia Smith | 7000 | 1 |
  | Data Analytics | Amelia Lee | 4000 | 2 |
  | Data Analytics | James Anderson | 4000 | 2 |
  | Data Analytics | Emma Thompson | 3800 | 3 |
  | Data Analytics | Daniel Rodriguez | 2230 | 4 |
  | Data Analytics | Sophia Martinez | 1750 | 5 |
  | Data Engineering | Liam Brown | 13000 | 1 |
  | Data Engineering | Ava Garcia | 12500 | 2 |
  | Data Engineering | Isabella Wilson | 11000 | 3 |
  | Data Engineering | Mia Taylor | 10800 | 4 |
  | Data Engineering | Benjamin Hernandez | 9500 | 5 |
  | Data Science | Logan Moore | 8000 | 1 |
  | Data Science | Charlotte Miller | 7000 | 2 |
  | Data Science | Noah Johnson | 6800 | 3 |
  | Data Science | William Davis | 6800 | 3 |

   ```
   -- use `rank()`
   SELECT 
          d.department_name,
          e.name,
          e.salary,
          rank() OVER (PARTITION BY d.department_name ORDER BY e.salary DESC) AS rnk
      FROM employee e
      LEFT JOIN department d ON e.department_id = d.department_id
   ```
  | department_name | name | salary | rnk |
  |-----------------|------|--------|-----|
  | Data Analytics | Olivia Smith | 7000 | 1 |
  | Data Analytics | Amelia Lee | 4000 | 2 |
  | Data Analytics | James Anderson | 4000 | 2 |
  | Data Analytics | Emma Thompson | 3800 | 4 |
  | Data Analytics | Daniel Rodriguez | 2230 | 5 |
  | Data Analytics | Sophia Martinez | 1750 | 6 |
  | Data Engineering | Liam Brown | 13000 | 1 |
  | Data Engineering | Ava Garcia | 12500 | 2 |
  | Data Engineering | Isabella Wilson | 11000 | 3 |
  | Data Engineering | Mia Taylor | 10800 | 4 |
  | Data Engineering | Benjamin Hernandez | 9500 | 5 |
  | Data Science | Logan Moore | 8000 | 1 |
  | Data Science | Charlotte Miller | 7000 | 2 |
  | Data Science | Noah Johnson | 6800 | 3 |
  | Data Science | William Davis | 6800 | 3 |

   ```
   -- use `rank()`
   SELECT 
          d.department_name,
          e.name,
          e.salary,
          row_number() OVER (PARTITION BY d.department_name ORDER BY e.salary DESC) AS rnk
      FROM employee e
      LEFT JOIN department d ON e.department_id = d.department_id
   ```

  | department_name | name | salary | rnk |
  |-----------------|------|--------|-----|
  | Data Analytics | Olivia Smith | 7000 | 1 |
  | Data Analytics | Amelia Lee | 4000 | 2 |
  | Data Analytics | James Anderson | 4000 | 3 |
  | Data Analytics | Emma Thompson | 3800 | 4 |
  | Data Analytics | Daniel Rodriguez | 2230 | 5 |
  | Data Analytics | Sophia Martinez | 1750 | 6 |
  | Data Engineering | Liam Brown | 13000 | 1 |
  | Data Engineering | Ava Garcia | 12500 | 2 |
  | Data Engineering | Isabella Wilson | 11000 | 3 |
  | Data Engineering | Mia Taylor | 10800 | 4 |
  | Data Engineering | Benjamin Hernandez | 9500 | 5 |
  | Data Science | Logan Moore | 8000 | 1 |
  | Data Science | Charlotte Miller | 7000 | 2 |
  | Data Science | Noah Johnson | 6800 | 3 |
  | Data Science | William Davis | 6800 | 4 |


## Solution
```
SELECT department_name, name, salary
FROM (
    SELECT 
        d.department_name,
        e.name,
        e.salary,
        dense_rank() OVER (PARTITION BY d.department_name ORDER BY e.salary DESC) AS rnk
    FROM employee e
    LEFT JOIN department d ON e.department_id = d.department_id
) ranked
WHERE rnk <= 3
ORDER BY department_name, rnk;
```