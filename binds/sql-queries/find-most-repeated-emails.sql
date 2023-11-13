-- find emails from specific dmains
-- MySQL's LIKE operator is automatically case insensitive
-- running a query to match 8 wildcards took 82 seconds.

SELECT
    trim(lower(email)) as fixed_email,
    count(pnum) as num_accounts
FROM
    aminno_member_email
GROUP BY fixed_email
having
    num_accounts > 2
order by num_accounts desc, fixed_email;
