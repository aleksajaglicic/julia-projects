include("bellmanFord.jl")

#    1  2  3  4  5  6  7  8  9  10
M = [0  1  2  0  0  0  0  0  0  0;
     0  0  0 -1  0  0  0  0  0  0;
     0  0  0  3  0  0 -2  0  0  0;
     0  0  0  0  5  0  0  0  0  0;
     0  0  0  0  0  3  0  0  0  0;
     0  0  0  0  0  0  1  0  0  0;
     0  0  0  0  0  0  0  4  2  0;
     0  0  0  0  0  0  0  0  0 -2;
     0  0  0  0  0  0  0  0  0 -1;
     0  0  0  0  0  0  0  0  0  0]

G = nonEmptyGraph(M)
list, graph = bellmanFord(G, 1)
print("Originalan graf: \n")
printGraph(G)
print("\n")
display(list)
print("\n")
printList(list, 1)
print("\n")
display(graph)