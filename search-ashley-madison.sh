#!/bin/bash
# Tim H 2023

export LC_CTYPE=C 
export LANG=C

ASHLEY_EMAIL_LIST_ORIGINAL="ashley_madison_email_sql_export.txt"
GMAIL_CONTACTS_CSV_ORIGINAL="/home/thrawn/tim-gmail-contacts-others-2023-10-14.csv"

SEARCHABLE_ASHLEY_LIST="ashley_madison_email_searchable.txt"
SEARCHABLE_ADDRESS_BOOK="tim-gmail-contacts-others-2023-10-14_searchable.txt"

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
    grep -E "^[[:alnum:]]" "$ASHLEY_EMAIL_LIST_ORIGINAL" | sort --unique --output "$SEARCHABLE_ASHLEY_LIST" 
fi

wc -l "$SEARCHABLE_ASHLEY_LIST"

# extract emails from Google contracts export
wc -l "$GMAIL_CONTACTS_CSV_ORIGINAL"
echo "Cleaning up Gmail Contacts list, prepping it for search..."
# in new versions it is fields cut -d ',' -f31,33,35
# cut -d ',' -f29,31,33 "$GMAIL_CONTACTS_CSV_ORIGINAL" | grep --text \@ |  tr ':::' ',' | tr , '\n' | tr -d '[:blank:]' | grep --text \@  > "$SEARCHABLE_ADDRESS_BOOK"
cut -d ',' -f31,33,35 "$GMAIL_CONTACTS_CSV_ORIGINAL" | grep --text \@ |  tr ':::' ',' | tr , '\n' | tr -d '[:blank:]' | grep --text \@  > "$SEARCHABLE_ADDRESS_BOOK"
# tail -n3 "$SEARCHABLE_ADDRESS_BOOK"
echo "$TEST_EMAIL" >> "$SEARCHABLE_ADDRESS_BOOK"
# tail -n3 "$SEARCHABLE_ADDRESS_BOOK"
sort --unique --output "$SEARCHABLE_ADDRESS_BOOK" "$SEARCHABLE_ADDRESS_BOOK" 

wc -l "$SEARCHABLE_ADDRESS_BOOK"

echo "Comparing the two lists..."
comm -12 "$SEARCHABLE_ASHLEY_LIST" "$SEARCHABLE_ADDRESS_BOOK" 
