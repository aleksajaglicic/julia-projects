mutable struct Node
   index::Int64
   d::Float64
   pred::Union{Nothing, Int}
end

mutable struct Graph
   AdjMatrix::Array{Int, 2}
   V::Array{Node, 1}
end

function nonEmptyGraph(AdjMat)
    n = size(AdjMat, 1)
    V = Array{Node}(undef, n)
    for i in 1:n
        V[i] = Node(i, 0, 0)
    end
    return Graph(copy(AdjMat), V)
end

function printGraph(G)
    n = size(G.AdjMatrix, 1)
    for i in 1:n
        for j in 1:n
            print(" $(G.AdjMatrix[i,j])")
        end
    println()
    end
    for i in 1:n
        println("$(G.V[i].index) $(G.V[i].d) $(G.V[i].pred)")
    end
end

function printList(list, src)
    for i in 1:10
        if i == src
            print("Starter number: $i. Its previous doesn't exist.\n")
        else
            print("Path length from start to number $i is: $(Int(list[i].d)). Its previous is: $(list[i].pred)\n")
        end
    end
end

function init(G, src)
    for v in 1:length(G.V)
       G.V[v].d = Inf
       G.V[v].pred = nothing
    end
    G.V[src].d = 0
end

function relax(G, u, v)
    if G.V[v].d > G.V[u].d + G.AdjMatrix[u, v]
        G.V[v].d = G.V[u].d + G.AdjMatrix[u, v]
        G.V[v].pred = u
    end
end

function bellmanFord(G, src)
    init(G, src)
    for i in 1:length(G.V) - 1
        G.V[i].index = i
        for u in 1:length(G.V)
            for v in findall(G.AdjMatrix[u, :].!= 0)
                relax(G, u, v)
            end
            if G.V[u].d < 0
                error("Negative weight-cycle.")
                return [],[]
            end
        end
    end

    graph = zeros(Int, 10, 10)
    for i in 1:length(G.V)
        for u in 1:length(G.V)
            for v in 1:length(G.V)
                if u == G.V[v].pred
                    graph[u, v] = G.V[v].d
                end
            end
        end
    end
    list = deepcopy(G.V)
    return list, graph
end
