
LG.ne(g::VStaticGraph) = g.ne

LG.nv(::VStaticGraph{T,N}) where {T,N} = N

LG.vertices(::VStaticGraph{T,N}) where {T,N} = Base.OneTo(N)

LG.is_directed(::Type{<:VStaticGraph{T,N,D}}) where {T,N,D} = D

LG.edgetype(::VStaticGraph{T}) where {T} = LG.SimpleEdge{T}

Base.eltype(::VStaticGraph{T}) where {T} = T

function LG.has_edge(g::VStaticGraph, e::LG.AbstractEdge)
    LG.has_edge(g, LG.src(e), LG.dst(e))
end

function LG.has_edge(g::VStaticGraph{T,N,false}, s, d) where {T,N}
    verts = LG.vertices(g)
    (s in verts && d in verts) || return false # edge out of bounds
    @inbounds list_s = g.fadjlist[s]
    @inbounds list_d = g.fadjlist[d]
    if length(list_s) > length(list_d)
        d = s
        list_s = list_d
    end
    return LG.insorted(d, list_s)
end

function LG.has_edge(g::VStaticGraph{T,N,true}, s, d) where {T,N}
    verts = LG.vertices(g)
    (s in verts && d in verts) || return false  # edge out of bounds
    @inbounds list = g.fadjlist[s]
    return LG.insorted(d, list)
end

function LG.outneighbors(g::VStaticGraph{T,N}, v::Integer) where {T,N}
    @boundscheck v in LG.vertices(g) || return T[]
    flist = fadj(g)
    @inbounds list = flist[v]
    return list
end

function LG.inneighbors(g::VStaticGraph{T,N}, v::Integer) where {T,N}
    @boundscheck v in LG.vertices(g) || return T[]
    blist = badj(g)
    @inbounds list = blist[v]
    return list
end

function Base.zero(::Type{VStaticGraph{T,N,D}}) where {T,N,D}
    return VStaticGraph{T,0,D}()
end
