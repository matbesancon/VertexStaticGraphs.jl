
function LG.SimpleGraph(g::VStaticGraph{T,N,false}) where {T,N}
    
end

function LG.SimpleDiGraph(g::VStaticGraph{T,N,true}) where {T,N}
    
end

function LG.add_edge!(g::VStaticGraph{T,N}, s, d) where {T,N}
    LG.has_vertex(g, s) || return false
    LG.has_vertex(g, d) || return false
    flist = fadj(g)
    @inbounds list = flist[s]
    index = searchsortedfirst(list, d)
    @inbounds (index <= length(list) && list[index] == d) && return false  # edge already in graph
    insert!(list, index, d)

    g.ne += 1
    s == d && return true  # selfloop

    blist = badj(g)
    @inbounds list = blist[d]
    index = searchsortedfirst(list, s)
    insert!(list, index, s)
    return true  # edge successfully added
end

function LG.rem_edge!(g::VStaticGraph{T,N}, s, d) where {T,N}
    LG.has_vertex(g, s) || return false
    LG.has_vertex(g, d) || return false
    flist = fadj(g)
    @inbounds list = flist[s]
    index = searchsortedfirst(list, d)
    @inbounds (index <= length(list) && list[index] == d) || return false   # edge not in graph
    
    deleteat!(list, index)

    g.ne -= 1
    s == d && return true  # selfloop

    blist = badj(g)
    @inbounds list = blist[d]
    index = searchsortedfirst(list, s)
    deleteat!(list, index)
    return true  # edge successfully deleted
end
