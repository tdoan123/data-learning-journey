# [3-Topping Pizzas](https://datalemur.com/questions/pizzas-topping-cost)

## Description
You’re a consultant for a major pizza chain that will be running a promotion where all 3-topping pizzas will be sold for a fixed price, and are trying to understand the costs involved.

Given a list of pizza toppings, consider all the possible 3-topping pizzas, and print out the total cost of those 3 toppings. Sort the results with the highest total cost on the top followed by pizza toppings in ascending order.

Break ties by listing the ingredients in alphabetical order, starting from the first ingredient, followed by the second and third.

P.S. Be careful with the spacing (or lack of) between each ingredient. Refer to our Example Output.

Notes:

Do not display pizzas where a topping is repeated. For example, ‘Pepperoni,Pepperoni,Onion Pizza’.
Ingredients must be listed in alphabetical order. For example, 'Chicken,Onions,Sausage'. 'Onion,Sausage,Chicken' is not acceptable.

`pizza_toppings` Table:
| Column Name | Type |
|------------|-------------|
| topping_name | varchar(255) |
| ingredient_cost | decimal(10,2) |

`pizza_toppings` Example Input:
| topping_name | ingredient_cost |
|--------------|----------------|
| Pepperoni | 0.50 |
| Sausage | 0.70 |
| Chicken | 0.55 |
| Extra Cheese | 0.40 |

`Example` Output:
| pizza | total_cost |
|-------|-----------|
| Chicken,Pepperoni,Sausage | 1.75 |
| Chicken,Extra Cheese,Sausage | 1.65 |
| Extra Cheese,Pepperoni,Sausage | 1.60 |
| Chicken,Extra Cheese,Pepperoni | 1.45 |

## Approach
- Create 2 new columns for topping using information column `topping_name`. use `<` on join condition to avoid duplicate  
- create a new column to join data of the three columns  
- create a new column to sum the value of the three columns value
- sort the result by total value


## Keywords 
`concat()`  `inner join`  `cross join` `<`

## Solution 
### Option 1: Using Inner Join
```
SELECT 
    concat(pt1.topping_name,',', pt2.topping_name,',',pt3.topping_name) as pizza
    ,pt1.ingredient_cost + pt2.ingredient_cost + pt3.ingredient_cost as total_cost
FROM pizza_toppings as pt1
INNER join pizza_toppings as pt2 
    on pt1.topping_name < pt2.topping_name
INNER join pizza_toppings as pt3
    on pt2.topping_name < pt3.topping_name
order by total_cost DESC, pizza;
```

### Option 2: Using `cross_join` 
```
SELECT 
    concat(p1.topping_name,',', p2.topping_name,',',p3.topping_name) as pizza
    ,p1.ingredient_cost + p2.ingredient_cost + p3.ingredient_cost as total_cost
from pizza_toppings as p1 
cross join 
    pizza_toppings as p2, 
    pizza_toppings as p3
where p1.topping_name < p2.topping_name
and p2.topping_name < p3.topping_name
order by total_cost desc,  pizza;
```