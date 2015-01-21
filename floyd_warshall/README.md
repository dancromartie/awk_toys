This is a pretty straightforward AWK implementation of the pseudocode on Wikipedia, with some of my personal comments.

The Floyd-Warshall algorithm can be used for finding shortest path _distances_ in weighted graphs.  This will 
find the shortest path distance between all pairs of nodes.  

The algorithm generally doesn't tell you the _path_ itself, just how long it is.  The script includes 
a function to reconstruct the path for a requested pair of nodes.

It can also be used to find transitive closures, etc.  i.e. tell me all nodes that are reachable 
from node A, or from node B, etc. I imagine that's done by setting some weights to infinity and 
checking which pairs have a non-infinite shortest path distance.

This does not use any kind of sparse matrix representation for the inputs.

I have no idea if this properly accounts for different kinds of cycles in the graph.

## Usage ##
You can run the code with something like:

```
awk -f fw.awk sample_distances
```
, where sample_distances is a space delimited N by N matrix, if
you have N nodes in the network.

The distance file might look like:

```
0 6 5 1 9
6 0 9 12 4
5 9 0 1 2
1 12 1 0 4
9 4 2 4 0
```

where the first row and 3rd column represents the distance/weight from node 1 to 3.

This outputs something like:

```
min dist for 5,5 is 0
min dist for 1,1 is 0
min dist for 1,2 is 6
min dist for 1,3 is 2
min dist for 1,4 is 1
min dist for 1,5 is 4
min dist for 2,1 is 6
min dist for 2,2 is 0
min dist for 2,3 is 6
min dist for 2,4 is 7
min dist for 2,5 is 4
min dist for 3,1 is 2
min dist for 3,2 is 6
min dist for 3,3 is 0
min dist for 3,4 is 1
min dist for 3,5 is 2
min dist for 4,1 is 1
min dist for 4,2 is 7
min dist for 4,3 is 1
min dist for 4,4 is 0
min dist for 4,5 is 3
min dist for 5,1 is 4
min dist for 5,2 is 4
min dist for 5,3 is 2
min dist for 5,4 is 3

path for 4 and 2 is 4-->1-->2
```

I'm not so sure if it's right but it's right on the few cases I've checked.



