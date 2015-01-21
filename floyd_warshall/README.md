This is a pretty straightforward AWK implementation of the pseudocode on Wikipedia, with some of my personal comments.

The Floyd-Warshall algorithm can be used for finding shortest path _distances_ in weighted graphs.  This will 
find the shortest path distance between all pairs of nodes.  

The algorithm generally doesn't tell you the _path_ itself, just how long it is.  The script includes 
a function to reconstruct the path for a requested pair of nodes.

It can also be used to find transitive closures, etc.  i.e. tell me all nodes that are reachable 
from node A, or from node B, etc. I imagine that's done by setting some weights to infinity and 
checking which pairs have a non-infinite shortest path distance.

This does not use any kind of sparse matrix representation for the inputs.

## Usage ##
You can run the code with something like:

```
awk -f fw.awk sample_distances
```
, where sample_distances is a space delimited N by N matrix, if
you have N nodes in the network.
