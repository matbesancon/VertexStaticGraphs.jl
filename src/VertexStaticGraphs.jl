module VertexStaticGraphs

import LightGraphs
const LG = LightGraphs

import LightGraphs.SimpleGraphs: badj
import LightGraphs.SimpleGraphs: fadj

using StaticArrays
using StaticArrays: SVector, @SVector

export VStaticGraph

include("vstaticgraph.jl")
include("lg_interface.jl")
include("simplegraph_interface.jl")

end # module
