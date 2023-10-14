select 
    tab.table_name,
    sta.column_name
from information_schema.tables as tab
inner join information_schema.statistics as sta
        on sta.table_schema = tab.table_schema
        and sta.table_name = tab.table_name
        and sta.index_name = 'primary'
where tab.table_schema = 'aminno'
    and tab.table_type = 'BASE TABLE'
order by tab.table_name;
