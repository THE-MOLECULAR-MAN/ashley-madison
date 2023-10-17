CREATE INDEX index_last_name
    ON am_am_member(last_name);

SELECT 
    aam.last_name, aam.first_name
FROM
    am_am_member as aam
WHERE 
    aam.last_name like '%smith%'\G
