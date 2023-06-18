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



