-- show all running processes and queries:
show full processlist;

-- show the rate and progress of individual queries
-- look at the bottom for something that looks like this:
-- Number of rows inserted 109194910, updated 30378872, deleted 0, read 467571080
-- 0.00 inserts/s, 7617.34 updates/s, 0.00 deletes/s, 7617.39 reads/s
SHOW ENGINE INNODB STATUS \G

-- see the number of active connections
SHOW GLOBAL STATUS;

-- set the max number of connections
set global max_connections = 10;

-- calculate max memory that woul ever be used
-- is about 21 GB with 10 connections
SELECT ( @@key_buffer_size
+ @@query_cache_size
+ @@innodb_buffer_pool_size
+ @@innodb_log_buffer_size
+ @@max_connections * ( 
    @@read_buffer_size
    + @@read_rnd_buffer_size
    + @@sort_buffer_size
    + @@join_buffer_size
    + @@binlog_cache_size
    + @@thread_stack
    + @@tmp_table_size )
) / (1024 * 1024 * 1024) AS MAX_MEMORY_GB;
