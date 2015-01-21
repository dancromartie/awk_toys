# FAWKQL
FAWKQL is the "Fuzzy Awk Query Language"

This works ok for searching a small dataset for a value that could be slightly off.

I might use this when debugging an app to get a second view / sanity check on 
my Postgres or Solr searching.

# Usage
If we have a file like:
```
name|address|zip
lockheed martin corp|123 some st|51551
us govt|1234 some st|51550
raytheon corp|1234 some st|21212
northrop grumman|4321 our st|21214
lululemon|76 n. main st|99922
```
Then a query like:

```
awk -F '|' -f fawkql.awk -v query='name:raithion corp:4^zip:21212:0' test_data 
```

will give results like

```
raytheon corp|1234 some st|21212
```

This query means "the column 'name' should have an edit distance of no more
than 4 from 'raithion corp', and column 'zip' should be exactly equal to 21212".

That's about it.  Yep, searching on multiple columns is caret delimited, and 
info pertaining to each column is colon delimited. Not so elegant :(  .  Maybe it will get wrapped 
in something pretty some day.
