# VertexStaticGraphs

[![Build Status](https://travis-ci.com/matbesancon/VertexStaticGraphs.jl.svg?branch=master)](https://travis-ci.com/matbesancon/VertexStaticGraphs.jl)
[![Codecov](https://codecov.io/gh/matbesancon/VertexStaticGraphs.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/matbesancon/VertexStaticGraphs.jl)

Graph with fixed-number of vertices and varying number of edges.
The adjacency list is stored using an `SVector` from [StaticArrays.jl](https://github.com/JuliaArrays/StaticArrays.jl).
One notable difference from `LightGraphs.Simple(Di)Graph` is that the directedness
is stored as a type parameter.