# Chapter 10 Transactions and Concurrency

## 1. Transactions
A transaction is a unit of work. Might query data, modify data, and change the data definition.  
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

## 2.Locks and blocking
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

Use KILL <session_id> to terminate a blocker. It will cause a rollback.  
Use LOCK_TIMEOUT to restrict the amount of time a session waits for a lock.

## 3.Isolation levels
Isolation levels determine the level of consistency.
The user cannot determine how the writer uses exclusive locks, but can control the behavior of the reader either on session level or query level.

```
SET TRANSACTION ISOLATION LEVEL <isolation name>
```

```
SELECT ... FROM <table> WITH <isolation name>
```

4 isolation levels that based on the pure locking model:
- READ UNCOMMITTED
- READ COMMITTED (default)
- REPEATABLE READ
- SERIALIZABLE

2 isolation levels that based on locking + row versioning:
- SNAPSHOT
- READ COMMITTED SNAPSHOT (default in Azure SQL Database)

### READ UNCOMMITTED
lowest isolation level  
The reader doesn't ask for a shared lock - leading to reading uncommited changes (dirty reads)

For example, in a transaction, connection 1 sets A from 19 to 20, then rolls back at some point. Connection 2 might read the uncommitted data A = 20.

### READ COMMITTED
prevents dirty reads  
Require the reader to obtain a shared lock  
Can lead to **unrepeatable read**: Another transaction might change a resource in between 2 reads in the current transaction, because no lock is held on that resource.

### REPEATABLE READ
Need a shared lock to read, and need to hold the lock until the end of the transaction.
Can also prevent **lost update**. In lower isolations, both transactions can update the resource, so the first update will be overwritten by the second.  
Can lead to a deadlock.  

### SERIALIZABLE
Under REAPEATABLE READ, the transaction locks only the resources that the query found the first time it ran. Therefore, a second read in the transaction might return new rows. This is called **phantom reads**.
Use SERIALIZABLE to prevent phantom reads.  
SERIALIZABLE causes a reader to lock the whole range of keys that qualify for the query's filter, which blocks attempts made by other transactions to add rows that qualify for the reader's query filter.

### SNAPSHOT
Guaranteed to get committed reads, repeatable reads, and no phantom reads.   
Relies on row versioning instead of shared locks.


