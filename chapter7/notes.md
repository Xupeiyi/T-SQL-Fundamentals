# Chapter 7 T-SQL for data analysis
## Window functions
For each row, compute a scalar result value based on a calculation against a subset of rows (a window) **from the underlying query**.  
 
Order can be defined as part of the specification of the calculation. This does not conflict with the relational aspects of the result because it's not presentation ordering.

example:
```
SELECT empid, ordermonth, val, 
    SUM(val) OVER (PARTITION BY empid
                   ORDER BY ordermonth
                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runval
FROM Sales.EmpOrders;
```
Three parts in OVER:
- window-partition clause
- window-order clause
- window-frame clause

Window functions are only allowed in the SELECT and ORDER BY clauses of a query.

### Ranking window functions
- ROW_NUMBER - nondeterministic when there are ties
- RANK/DENSE_RANK - deterministic
- NTILE  
Window functions are logically evaluated as part of the SELECT list, before the distinct clause is evaluated. Therefore DISCTINCT would be useless for ROW_NUMBER unless using GROUP BY value first.

### Offset window functions
Return an element from a row that is at a certain offset from the current row, or at the beginning or end of a window frame.
- LAG/LEAD
- FIRST_VALUE/LAST_VALUE
RESPECT/IGNORE NULLS: keep or ignore NULLs until a result is found

### Aggregate window functions
- SUM without a window-frame clause: same value for all rows in a window
- SUM with a window-frame clause: running and moving aggregates, YTD and MTD calculations

### The window clause
Place
```
WINDOW W AS (PARTITION BY ..., ORDER BY, ROWS BETWEEN ...)
```
between HAVING and ORDER BY.
The WINDOW clause can name part of the window 

## Pivoting Table
Every pivoting request involves 3 logical processing phases:  
1. A grouping phase with an associated grouping or on rows elements
2. A spreading phase with an associated spreading or on cols element
3. An aggregation phase with an associated aggregation element and aggregate function

```
SELECT empid, A, B, C, D
FROM (SELECT empid, custid, qty, FROM dbo.Orders) AS O
    PIVOT (SUM(qty) FOR custid IN (A, B, C, D)) AS P
```
produces the same result as
```
SELECT empid,
    SUM(CASE WHEN custid = 'A' THEN qty END) AS A,
    SUM(CASE WHEN custid = 'B' THEN qty END) AS B,
    SUM(CASE WHEN custid = 'C' THEN qty END) AS C,
    SUM(CASE WHEN custid = 'D' THEN qty END) AS D,
FROM dbo.Orders
GROUP BY empid
```

custid is the spreading element, qty is the aggregation element, while the rest columns (empid in this case) is the grouping elements. That's why a table expression is needed as the best practice to control which column(s) to group by. 

## Unpivoting data
### Unpivoting with the APPLY operator
Three logical processing phases:
1. Producing copies
2. Extracting values
3. Eliminating irrelevant rows 

For the pivoted table dbo.EmpCustOrders: 

| empid | A | B | C | D |    
|-------|---|---|---|---|    
|1      |100|200|300|400|  
|2      |500|600|700|800|
|...    |...|...|...|...|

1. Create the cartesian product of empid and VALUES(('A'), ('B'), ('C'), ('D'))
```
SELECT * FROM dbo.EmpCustOrders
CROSS JOIN (VALUES ('A'), ('B'), ('C'), ('D')) AS C(custid);
```
2. Extract a value from one of A, B, C, D columns and return a single value column called qty
```
SELECT empid, custid, qty
FROM dbo.EmpCustOrders
    CROSS APPLY (VALUES ('A', A), ('B', B), ('C', C), ('D', D)) AS C(custid, qty)
```