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
    for(pattern in patterns){
        print pattern
    }
}

BEGIN{
    line_counter = 0
    patterns["sqlite"] = "templates/sqlite_template"
    patterns["flask"] = "templates/flask_template"
    patterns["requests"] = "templates/requests_template"
    patterns["pyunit"] = "templates/pyunit_template"
    patterns["read_file"] = "templates/read_file_template"
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
    }
}

END{
    if(failed == 1){
        exit 1
    }
    # Print all the import statements
    for(i in imports){
        print i
    }
    # Give it some space
    print ""
    print ""
    # Print the not-imports
    for(j = 0; j < line_counter; j++){
        print lines[j]
    }
}
