# Chapter 5 Table Expressions 
A table expression is an expression that conceptually returns a table result and as such can be nested as an operand of another table expression.

Because it's supposed to represent a table, there are three requirements for an inner query in a table-expression definition:
- all relation attributes must have names
- all attribute names must be unique
- there's no order

## Common Table Expressions
```{sql}
WITH <CTE_NAME 1> [(target column list 1)]
AS 
(
   <inner query 1> 
),
WITH <CTE_NAME 2> [(target column list 2)]
AS 
(
   <inner query 2> 
),
...
<outer query>
```
Each CTE can refer to all previously defined CTEs, but it cannot be nested.

The same CTE can be referred to multiple times in the outer query (useful in situations like self join).

### Recursive CTEs
The general form of a basic recursive CTE:
```{sql}
WITH <CTE name>[(target column list)] AS (
    <anchor member> -- invoked only once
    UNION ALL
    <recursive member> -- invoked repeatedly until it returns an empty set
) 
<outer query against CTE>

```

A real life example: Find the greatest grandparent of a child

```{sql}
WITH parent(child_id, parent_id, num_level) AS (
    SELECT child_id, parent_id, 1
    FROM child
    WHERE parent_id IS NOT NULL
    UNION ALL
    SELECT c.child_id, p.parent_id, p.num_level + 1
    FROM child AS c
    JOIN parent p ON c.parent_id = p.child_id
)
SELECT child_id, parent_id AS greatest_grandparent_id, num_levels
FROM parent
WHERE parent_id NOT IN (
    SELECT child_id 
    FROM child
    WHERE parent_id IS NOT NULL
)
```
## Views