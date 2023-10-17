-- find emails from specific dmains
-- MySQL's LIKE operator is automatically case insensitive

SELECT
    email_domain,
    email,
    pnum as primary_key
FROM
    aminno_member_email
where
    email_domain LIKE '%utexas.edu'
order by email_domain, email

INTO OUTFILE '/tmp/ashley-madison-list8.csv' 
LINES TERMINATED BY '\n';
