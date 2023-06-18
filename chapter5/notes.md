# Chapter 5 Table Expressions 
A table expression is an expression that conceptually returns a table result and as such can be nested as an operand of another table expression.
  
T-SQL supports 4 types of named table expressions: 
- derived tables
- common table expressions (CTEs)
- views
- inline table-valued functions (inline TVFs)

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
Explicitly list the column names you need in the definition of the view.  
Like mentioned above, ORDER BY is not allowed in the definition of a view, unless TOP or OFFSET-FETCH is also specified. Even one managed to use ORDER BY in the definition, or created a seemingly ordered view, the order is not guaranteed.

### View Options
1. ENCRYPTION    
The ENCRYPTION option will return the user a NULL or an error when the user is trying to get the DDL of the view.  

2. SCHEMABINDING   
The object or column referenced by the view cannot be dropped or altered.  
Generally a good practice to turn it on, but can make things hard to change.  

3. CHECK OPTION  
The user can insert new rows to tables via views. CHECK OPTION prevent modifications that conflict with the view's definition (i.e., filter).

## Inline table-valued functions
Inline TVFs an be thought of as parameterized views.  
There's also a type of TVF called multi-statement TVF, which is not considerd a table expression because it's not based on a query.

### APPLY
APLLY operates on 2 input tables ("left" and "right"). Unlike JOIN, which gives no order to left and right, the left side is evaluated first, and the right side is evaluated per row from the left.   
```
SELECT C.custid, A.orderid, A.orderdate
FROM Sales.Customers AS C
CROSS APPLY
(SELECT TOP(3) orderid, empid, orderdate, requireddate
FROM Sales.Order AS O
WHERE O.custid = C.custid
ORDER BY orderdate DESC, orderid DESC) AS A;

```

CROSS APPLY does not return the corresponding left row if right returns an empty set, but OUTER APPLY does.


