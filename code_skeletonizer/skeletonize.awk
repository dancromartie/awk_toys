function import(f){
    lines[line_counter++] = "########### " f " ################"
    while(getline x < f > 0){
        if(x ~ /^import/ || x ~ /^from.*import/){
            # Make the key the full line, so we can skip duplicates later
            imports[x] = x
        }else{
            lines[line_counter++] = x
        }
    }
    lines[line_counter++] = ""
}

function show_options(){
    print "Your options are: "
    print ""
    i = 0
    for(pattern in patterns){
        names[i] = pattern
        i = i + 1
    }
    n = asort(names)
    for(i = 1; i <= n; i++){
        print names[i]
    }
    print "\n***"
    print "Hit ctrl+d to end input"
    print "***\n"
}

BEGIN{
    line_counter = 0
    out_file = "/tmp/awk_skeletonizer.out"
    patterns["csv"] = "templates/csv_template"
    patterns["flask"] = "templates/flask_template"
    patterns["read_file"] = "templates/read_file_template"
    patterns["requests"] = "templates/requests_template"
    patterns["selenium"] = "templates/selenium_template"
    patterns["sqlite"] = "templates/sqlite_template"
    patterns["unittest"] = "templates/unittest_template"
    show_options()
}

{
    found = 0
    for(pattern in patterns){
        if($1 ~ pattern){
            found = 1
            import(patterns[pattern])
        }
    }
    if(found == 0){
        print "Couldnt find anything related to " $1
        show_options()
        # An "exit 1" here would simply stop processing records and put us at END
        # So, just set a variable here, and exit at the beginning of END if set
        failed = 1
        exit 1
    }
}

END{
    if(failed == 1){
        exit 1
    }
    # Print all the import statements
    print "Your output is in " out_file
    print "########### made by awk skeletonizer ###########" > out_file
    for(i in imports){
        print i >> out_file
    }
    # Give it some space
    print ""
    print ""
    # Print the not-imports
    for(j = 0; j < line_counter; j++){
        print lines[j] >> out_file
    }
}
