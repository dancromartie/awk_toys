function path(u, v){
    the_path = u
    while(u != v){
        u = paths[u "," v]
        the_path = the_path "-->" u
    }
    return the_path
}

{
    for(i= 1; i <= NF; i++){
        dist[NR "," i] = $i
        # We kind of assume that we can end up here, but might not be true?
        paths[NR "," i] = i
    }
}

END{
    # I think it's best to think of this as graying out all N-1 nodes at first, and slowly 
    # ungraying one node per outermost iteration.  For each outermost iteration,
    # we consider all edges, with the full set of nodes.

    for(k = 1; k <= NR; k++){
        for(i = 1; i <= NR; i++){
            for(j = 1; j <= NR; j++){
                # Path either contains node k or not
                # Is the one that does shorter than our current best guess?
                if(dist[i "," j] > dist[i "," k] + dist[k "," j]){
                    dist[i "," j] = dist[i "," k] + dist[k "," j]
                    # We just know that the path contains k.
                    # If we say "the path from D to M contains A", we still don't know how to
                    # get to M, but we can use the fact that the shortest path from A to M
                    # contains some other node.
                    # The first time one of these gets set, it will be a "one step stepping stone".
                    # The RHS is a node number, and it is initialized to the terminal node
                    # So at first assignment, we are saying "to get from i to j, you must go 
                    # through k, and the path starts with k"
                    # But how do we know that k will remain the first step?  
                    # Well, we might find out later that we need to go through k'.
                    # If k is on the way from i to k', then paths[i "," k'] will already
                    # point to k.
                    paths[i "," j] = paths[i "," k]
                }
            }
        }
    }
    for(i in dist){
        print "min dist for " i " is " dist[i]
    }
    print "path for 4 and 2 is " path(4, 2)
}
