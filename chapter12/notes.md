# Chapter 12. Programmable Objects

## Temporary tables 
### Table Variables
User `DECLARE` to declare a table variable.
Has a physical presence as a table in the tempdb database.
The scope is only the current batch.
If an explicit transaction is rolled back, changes made to table variables by statements that completed in the transaction aren’t rolled back. 
For only a few rows, use table variable; Otherwise use local temporary tables.

### Table Types
Use a table type to preserve a table definition, or metadata, as an object in the database. 