SELECT 
    DISTINCT(LOWER(TRIM(email)))
FROM
    aminno_member_email
where email <> ''
ORDER BY email desc
INTO OUTFILE '/tmp/ashley-madison-email-list.csv' 
LINES TERMINATED BY '\n';
