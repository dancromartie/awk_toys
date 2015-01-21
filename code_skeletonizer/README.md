## Python Skeletonizer ##

I write a lot of really little apps and prototypes of things, sometimes several in a day.

I spend a lot of time copy pasting Python code from old projects because I can't remember exactly:
 - how to set up an sqlite connection and what the multi-row insert function is called
 - whether or not the requests library needs a JSON string or a dictionary for the GET parameters
 - that unittest needs to have some class that inherits from some other class, and that tests have
to start with "test"

If I had a fancy IDE or Java etc, I might get some hints about some of these, but you would still
have to do a lot of typing.  

This lets me just do a real quick hit and run: "I have a project that needs an sqlite connection, is
going to make some get requests, is going to have some Flask endpoints, and is going to use a python
shelf".

Does it take _that_ long to copy paste these things from online docs or from old projects?  No.  But
sometimes there's a certain "activation energy" or motivational hump you have to get over before
saying "hey, let me try that thing out that I've been thinking about all week".  

Is it _that_  hard to go to the deli downstairs and buy an apple?  No, but you're 100X more likely
to eat an apple if your company puts one in the kitchen 10ft away from your desk.  The interesting
question is whether or not a developer would go 3 months without eating any fruit or if they would
spend the extra time each day.  In my experience the former is more likely...

I hope to add stuff for JS (the most painful setup-wise for me), shell scripts, and R some day.

## Usage ##

Entering something it doesn't know about will tell you the available options:

```
08:18 PM [.../awk_toys/code_skeletonizer] $ awk -f skeletonize.awk
asdfklasdfkjdsaf
Couldnt find anything related to asdfklasdfkjdsaf
Your options are: 

flask
sqlite
requests
pyunit
read_file
^C
```

Since it will just wait for STDIN, you can either pass a file of options to the script, or 
you can enter them on the command line, and tell it you're done with a CTRL-d like below:

```
08:22 PM [.../awk_toys/code_skeletonizer] $ awk -f skeletonize.awk > python_starter_code        
sqlite
requests
read_file
```

This gives you output like:

```python
import json
import requests
import sqlite3
import sys


########### templates/sqlite_template ################

db_conn = sqlite3.connect('some_example.db')
db_conn.row_factory = sqlite3.Row
db_cursor = db_conn.cursor()

db_cursor.execute('CREATE TABLE stocks (date text, trans text, qty real)')
for row in db_cursor.execute('SELECT * FROM some_table ORDER BY my_col'):
    print row

# Pass a list of tuples to insert multiple rows, can pass one tuple to execute for single insert
db_cursor.executemany('INSERT INTO other_table VALUES (?,?,?,?,?)', data_tuples)
db_conn.commit()

########### templates/requests_template ################

payload = {'key1': 'value1', 'key2': 'value2'}
r = requests.get("http://httpbin.org/get", params=payload)
# If JSON response, can use r.json() to get Python object out
print r.url, r.text
```

Note how imports are all put at the top.  If the same import line is detected across multiple 
templates, it will deduplicate them.  Each section is marked off by its own string of hashes.

One more example of setting up some "unit" tests that are going to use some GET requests.

```python
import unittest
import json
import requests
import my_app


########### templates/requests_template ################

payload = {'key1': 'value1', 'key2': 'value2'}
r = requests.get("http://httpbin.org/get", params=payload)
# If JSON response, can use r.json() to get Python object out
print r.url, r.text

########### templates/pyunit_template ################

class TestMyApp(unittest.TestCase):

    def test_data_fetch(self):
        results = my_app.fetch_by_id("453")
        self.assertTrue(results[0].state = "MA")

    def test_other_func(self):
        self.assertTrue(5 == 5)
```

## Configuration ##

Of course, my templates probably aren't of much use to you. Your own organization will have its own
proprietary stuff and its own use cases.

There's a section in the script that you can modify.

```
patterns["sqlite"] = "templates/sqlite_template"
patterns["flask"] = "templates/flask_template"
patterns["requests"] = "templates/requests_template"
patterns["pyunit"] = "templates/pyunit_template"
patterns["read_file"] = "templates/read_file_template"
```

This means "if regex /sqlite/ is passes, use the following template file".
