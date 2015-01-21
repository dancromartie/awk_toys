function minimum(a, b, c){
    min_a_b = a < b ? a : b
    min_b_c = b < c ? b : c
    full_min = min_a_b < min_b_c ? min_a_b : min_b_c
    return full_min
}

# To make the i and j variables "local", make them arguments.  You don't need to 
# supply them when calling.  The extra space is a convention to show that it's a local variable
# and not an argument.

function lev_distance(s, t, max_allowable,      i,      j){
    # degenerate cases
    if (s == t) return 0
    if (length(s) == 0) return length(t)
    if (length(t) == 0) return length(s)
    if(max_allowable == 0 && s != t) return 1000000
 
    # Have to clear out these arrays.  
    # Don't think v0 = [] will work...
    # HMMM....
    delete v0
    delete v1
    v0_length = length(t) + 1
    v1_length = length(t) + 1

    for(i = 0; i < v0_length; i++)
        v0[i] = i
 
    for(i = 0; i < length(s); i++){
        v1[0] = i + 1
 
        for(j = 0; j < length(t); j++){
            cost = substr(s, i, 1) == substr(t, j, 1) ? 0 : 1
            v1[j + 1] = minimum(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
        }
 
        for(j = 0; j < v0_length; j++)
            v0[j] = v1[j]
    }
 
    return v1[length(t)]
}

BEGIN{

}

NR == 1 {
    # "query" comes from script args
    # This command is kind of weird in that it uses an argument to say where the result ends up
    # AND!!! apparently the arrays are 1-indexed instead of 0-indexed, despite the docs im reading..
    split($0, headers, FS)
    for(key in headers)
        col_mapping[headers[key]] = key

    # This assigns a list to query_list AND a number to num_fields, watch out!
    num_fields = split(query, query_list, "\^")

    # See above notes for why starting at 1
    for(i = 1; i <= num_fields; i++){
        this_query_string = query_list[i]
        split(query_list[i], this_query, ":")
        col_names[i] = this_query[1]
        col_nums[i] = int(col_mapping[col_names[i]])
        comp_strings[i] = this_query[2]
        max_dists[i] = int(this_query[3])
    }
}

NR != 1 {
    should_print = 1
    # See above notes for why starting at 1
    for(i = 1; i <= num_fields; i++){
        if(lev_distance($col_nums[i], comp_strings[i], max_dists[i]) > max_dists[i]){
            should_print = 0 
            break
        }
    }
    if(should_print == 1){
        print
    }
}
