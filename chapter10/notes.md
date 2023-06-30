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
- Isolation. The user controls what consistency means through isolation levels.SQL Server supports 2 models: pure locking & row versioning.
- Durability. Depends on the recovery architecture. Before SQL Server 2019, traditional architecture is used. In SQL Server 2019 or later, new architecture feature called ADR is supported.

## Locks and blocking
### Lock modes and compatibility
Two lock modes: Exclusive & Shared
|Request Mode|Granted Exclusive|Granted Shared|
|--|--|--|
|Exclusive|No|No|
|Shared|No|Yes|

### Lockable resource types
SQL Server can lock different types of resources: rows, pages, objects, databases...
To obtain a lock on a certain resource type, your transaction must first obtain intent locks of the same mode on higher levels of granularity.

|Requested mode| X | S |IX | IS|
|--------------|---|---|---|---|
|X             |No |No |No |No |
|S             |No |Yes|No |Yes|
|IX            |No |No |Yes|Yes|
|IS            |No |Yes|Yes|Yes|

Intent locks are compatible with one another. They won't necessarily comflict until they try to get real locks on the same resource.

SQL Server might first acquire fine-grained locks and, in certain circumstances, try to escalte the locks to preserve memory.

### Troubleshooting blocking
1. Get lock and session_id  
To get lock information, query the dynamic management view sys.dm_tran_locks in another connection.
2. Get most_recent_sql_handle
Use session_id to get a bianry value holding a handle to the most recent SQL batch run by the connection. Query sys.dm_exec_connections
3. Get the batch of SQL code represented by the handle
Query sys.dm_exec_connections
