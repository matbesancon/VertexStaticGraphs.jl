
"""
    VStaticGraph{T,N,D}

`LightGraphs.AbstractGraph` with fixed-number of vertices and varying number of edges.
The adjacency list is stored using an `SVector`.

`T` is the integer type, `N` the number of vertices, `D` is the directedness.

## Examples

```julia
julia> g = VStaticGraph{Int,6,false}()
julia> g2 = VStaticGraph{Int}(Val{6}())
```
"""
mutable struct VStaticGraph{T,N,D,BT <: Union{SVector{N, Vector{T}},Nothing}} <: LG.AbstractSimpleGraph{T}
    ne::Int
    fadjlist::SVector{N, Vector{T}} # [src]: (dst, dst, dst)
    badjlist::BT                    # [dst]: (src, src, src)
    function VStaticGraph{T,N,true}(ne, fadjlist) where {T,N}
        badjlist = SVector{N,Vector{T}}([Vector{T}() for _ = 1:N])
        return new{T,N,true,SVector{N, Vector{T}}}(ne, fadjlist, badjlist)
    end
    function VStaticGraph{T,N,false}(ne, fadjlist) where {T,N}
        return new{T,N,false,Nothing}(ne, fadjlist, nothing)
    end
end

badj(g::VStaticGraph{T,N,true}) where {T,N} = g.badjlist
badj(g::VStaticGraph{T,N,false}) where {T,N} = g.fadjlist

fadj(g::VStaticGraph) = g.fadjlist

function VStaticGraph{T,N,D}() where {T,N,D}
    fadjlist = SVector{N,Vector{T}}([Vector{T}() for _ = 1:N])
    return VStaticGraph{T,N,D}(0, fadjlist)
end

function VStaticGraph{T}(::Val{N}) where {T,N}
    return VStaticGraph{T,N,false}()
end

function VStaticGraph(::Val{N}) where {N}
    return VStaticGraph{Int,N,false}()
end

function VStaticGraph{T}(::Val{N}, ::Val{D}) where {T,N,D}
    return VStaticGraph{T,N,D}()
end

function VStaticGraph(::Val{N}, ::Val{D}) where {N,D}
    return VStaticGraph{Int,N,D}()
end
