
-- generate a list of most common email domains
select
    email_domain,
    count(DISTINCT(LOWER(TRIM(email)))) as number_of_unique_email_addresses,
    count(email) as total_number_of_profiles
from aminno_member_email
GROUP BY email_domain
ORDER by total_number_of_profiles desc
INTO OUTFILE '/tmp/ashley-madison-domains-by-prevalence.csv' 
LINES TERMINATED BY '\n';

-- then truncate it to Google Sheet's limit of 40k rows:
-- leave one row for header
-- echo "email domain,number of unique email addresses, total number of profiles" > ashley-madison-domains-top-40k.csv
-- head -n39999 ashley-madison-domains-by-prevalence.csv >> ashley-madison-domains-top-40k.csv
-- wc -l ashley-madison-domains-top-40k.csv

