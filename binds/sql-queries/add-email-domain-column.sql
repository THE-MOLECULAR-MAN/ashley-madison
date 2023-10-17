-- create the new column for email domains, set default value to NULL
ALTER TABLE aminno_member_email
ADD COLUMN email_domain varchar(255) NULL;

-- see how many rows will need to get updated
-- query took 17 seconds
-- table has 36,397,896 rows
select count(*) from aminno_member_email;

-- see how many rows have mail addresses
-- query took 27 seconds
-- table has 36,396,146 rows that have an @ symbol in them
-- only 1,750 rows do not have an @ symbol in the email
-- 99.5% of the rows have an '@' symbol in the email
select count(*) from aminno_member_email
where email like '%@%';

-- assign values for email domain if an '@' is in the email field
-- Query OK, 36396146 rows affected (51 min 8.85 sec)
-- Rows matched: 36396146  Changed: 36396146  Warnings: 0
update aminno_member_email 
set email_domain=TRIM(LOWER(RIGHT(email, LENGTH(email) - LOCATE( '@', email))))
where email like '%@%';

-- create an index on email domain for faster queries in the future
CREATE INDEX index_email_domain
    ON aminno_member_email(email_domain);

-- took 5 min:
CREATE INDEX index_email
    ON aminno_member_email(email);

-- run a quick test to see if there are any email domains that aren't blank
-- took 4 minutes before the index 1 second after creating the index
select
    email_domain
from aminno_member_email
where email_domain <> ''
limit 20;

-- generate a list of most common email domains
select
    email_domain,
    count(DISTINCT(LOWER(TRIM(email)))) as number_of_unique_email_addresses,
    count(email) as total_number_of_profiles
from aminno_member_email
where email_domain <> ''
GROUP BY email_domain
ORDER by total_number_of_profiles desc
INTO OUTFILE '/tmp/ashley-madison-domains-list.csv' 
LINES TERMINATED BY '\n';

-- find improper email addresses:
SELECT email FROM aminno_member_email
    WHERE 
        email NOT REGEXP '^[^@]+@[^@]+\.[^@]{2,}$';

-- create a new column to denote if the email is valid
-- set the default to false
ALTER TABLE aminno_member_email
ADD COLUMN is_valid_email_address boolean not null default 0;

-- change the columns for ones with valid email addresses
update aminno_member_email
    set is_valid_email_address=1
    where email REGEXP '^[^@]+@[^@]+\.[^@]{2,}$';
