# [Second Highest Salary](https://datalemur.com/questions/sql-second-highest-salary)

## Description 
magine you're an HR analyst at a tech company tasked with analyzing employee salaries. Your manager is keen on understanding the pay distribution and asks you to determine the second highest salary among all employees.

It's possible that multiple employees may share the same second highest salary. In case of duplicate, display the salary only once.

`employee` Schema:

| column_name | type | description |
|-------------|------|-------------|
| employee_id | integer | The unique ID of the employee. |
| name | string | The name of the employee. |
| salary | integer | The salary of the employee. |
| department_id | integer | The department ID of the employee. |
| manager_id | integer | The manager ID of the employee. |



| employee_id | name | salary | department_id | manager_id |
|-------------|------|--------|--------------|------------|
| 1 | Emma Thompson | 3800 | 1 | 6 |
| 2 | Daniel Rodriguez | 2230 | 1 | 7 |
| 3 | Olivia Smith | 2000 | 1 | 8 |

## Learning note 
- use `offset ` to select `n`th order value 

## Solution  
```
SELECT 
salary as second_highest_salary
FROM employee
order by salary desc
LIMIT 1 OFFSET 1;
```
