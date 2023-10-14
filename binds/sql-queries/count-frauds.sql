SELECT 
    fraud_flag,
    count(*) as row_count
FROM
    aminno_member as am
GROUP by fraud_flag
ORDER by row_count desc;

