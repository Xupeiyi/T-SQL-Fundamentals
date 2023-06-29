# Chapter 10 Transactions and Concurrency

## Transactions
example:
```
BEGIN TRAN
    INSERT INTO ...
    INSERT INTO ...
COMMIT TRAN
```
By default, SQL Server automatically begins a transaction before each statement starts and commits the transaction at the end of each statement.

Four properties of transactions: ACID
- Atomictity. Some errors are not considered severe enough to justify an automatic rollback.
- Consistency. Transition the database from one consistent state to another.
- Isolation. The user controls what consistency means through isolation levels.
- Durability. Depends on the recovery architecture.