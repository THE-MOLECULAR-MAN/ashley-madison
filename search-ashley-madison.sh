#!/bin/bash
# Tim H 2023

export LC_CTYPE=C 
export LANG=C

ASHLEY_EMAIL_LIST_ORIGINAL="ashley_madison_email_sql_export.txt"
# GMAIL_CONTACTS_CSV_ORIGINAL="tim-gmail-contacts.csv"
GMAIL_CONTACTS_CSV_ORIGINAL="/Users/tim/Downloads/Google Contacts Archiving 2014-12-05.csv"

SEARCHABLE_ASHLEY_LIST="ashley_madison_email_searchable.txt"
SEARCHABLE_ADDRESS_BOOK="tim_gmail_contacts_searchable.txt"

TEST_EMAIL='knownworking@timstest.com'

# add test email to verify it is working.
sudo chmod u+w "$ASHLEY_EMAIL_LIST_ORIGINAL"
echo "$TEST_EMAIL" >> "$ASHLEY_EMAIL_LIST_ORIGINAL"
chmod -w "$ASHLEY_EMAIL_LIST_ORIGINAL"

wc -l "$ASHLEY_EMAIL_LIST_ORIGINAL"

# clean up original Ashley Madison list file:
echo "Cleaning up Ashley Madison list, prepping it for search..."
if [[ -f "$SEARCHABLE_ASHLEY_LIST" ]]; then
    echo "Ashley list already done, skipping."
else
    grep -E "^[[:alnum:]]" "$ASHLEY_EMAIL_LIST_ORIGINAL" | sort --unique > "$SEARCHABLE_ASHLEY_LIST"
fi

wc -l "$SEARCHABLE_ASHLEY_LIST"

# extract emails from Google contracts export
wc -l "$GMAIL_CONTACTS_CSV_ORIGINAL"
echo "Cleaning up Gmail Contacts list, prepping it for search..."
# in new versions it is fields cut -d ',' -f31,33,35
cut -d ',' -f29,31,33 "$GMAIL_CONTACTS_CSV_ORIGINAL" | grep --text \@ |  tr ':::' ',' | tr , '\n' | tr -d '[:blank:]' | grep --text \@  > "$SEARCHABLE_ADDRESS_BOOK"
# tail -n3 "$SEARCHABLE_ADDRESS_BOOK"
echo "$TEST_EMAIL" >> "$SEARCHABLE_ADDRESS_BOOK"
# tail -n3 "$SEARCHABLE_ADDRESS_BOOK"
sort --unique --output "$SEARCHABLE_ADDRESS_BOOK" "$SEARCHABLE_ADDRESS_BOOK" 

wc -l "$SEARCHABLE_ADDRESS_BOOK"

echo "Comparing the two lists..."
comm -12 "$SEARCHABLE_ASHLEY_LIST" "$SEARCHABLE_ADDRESS_BOOK" 




# grep -i 'wayfair\|honker\|rapid7\|ziften\|gemalto\|shopify\|motsenbocker\|harvard'  "$ASHLEY_EMAIL_LIST_ORIGINAL" > emailresults.csv
# grep -i 'harvard.edu'  "$ASHLEY_EMAIL_LIST_ORIGINAL" > ashley-madison-harvard.csv
# grep -i 'utexas.edu'  "$ASHLEY_EMAIL_LIST_ORIGINAL" > ashley-madison-utexas.csv
