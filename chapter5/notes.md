# Chapter 5 Table Expressions 
A table expression is an expression that conceptually returns a table result and as such can be nested as an operand of another table expression.

Because it's supposed to represent a table, there are three requirements for an inner query in a table-expression definition:
- all relation attributes must have names
- all attribute names must be unique
- there's no order

## Common Table Expressions
```{sql}
WITH <CTE_NAME> [(target column list)]
AS 
(
   <inner query> 
)
<outer query>
```
