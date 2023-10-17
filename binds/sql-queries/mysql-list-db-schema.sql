-- lists all the tables and columns in the current database
-- orders it in a way to find duplicate columns easily
select 
    tab.table_name as table_name,
    col.column_name as column_name,
    col.data_type as data_type
from information_schema.tables as tab
    inner join information_schema.columns as col
        on col.table_schema = tab.table_schema
        and col.table_name = tab.table_name
where tab.table_type = 'BASE TABLE'
    and tab.table_schema not in ('information_schema','mysql',
        'performance_schema','sys')
    and tab.table_schema = database() 
order by column_name;
