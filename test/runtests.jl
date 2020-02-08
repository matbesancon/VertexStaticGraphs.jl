using VertexStaticGraphs
using Test
using LightGraphs
const LG = LightGraphs

@testset "VStaticGraph constructor" begin
    g = VStaticGraph{Int,6,false}()
    @test length(g.fadjlist) == 6
    @test g.ne == 0
    @test all(isempty.(g.fadjlist))
    g2 = VStaticGraph{Int}(Val{6}())
    @test length(g2.fadjlist) == 6
    @test g2.ne == 0
    @test all(isempty.(g2.fadjlist))
end

@testset "LG interface" begin
    g = VStaticGraph{Int,6,false}()
    dg = VStaticGraph{Int,6,true}()
    @test ne(g) == ne(dg) == 0
    @test nv(g) == nv(dg) == 6
    @test !is_directed(g)
    @test is_directed(dg)
end

@testset "badjlist and neighbors" begin
    g = VStaticGraph{Int,6,false}()
    dg = VStaticGraph{Int,6,true}()
    @test g.badjlist === nothing
    @test length(dg.badjlist) == 6
    @test LG.SimpleGraphs.badj(g) === g.fadjlist
    @test LG.SimpleGraphs.badj(dg) !== dg.fadjlist
end

@testset "Edge addition and presence" begin
    g = VStaticGraph{Int,6,false}()
    dg = VStaticGraph{Int,6,true}()
    @test add_edge!(g, 1, 2)
    @test add_edge!(dg, 1, 3)
    @test !add_edge!(g, 1, 2)
    @test !add_edge!(dg, 1, 3)
    @test ne(g) == ne(dg) == 1
    @test length(outneighbors(g, 1)) == length(outneighbors(dg, 1)) == 1
    @test inneighbors(dg, 3) == [1]
    @test isempty(outneighbors(dg, 3))
    @test_broken add_edge!(g, LightGraphs.Edge(1,4))
    @test_broken add_edge!(dg, LightGraphs.Edge(1,4))
    # checking vertices bounds
    @test !add_edge!(g, 1, 7)
    @test !add_edge!(dg, 1, 10)
end

@testset "Edge addition and presence" begin
    g = VStaticGraph{Int,6,false}()
    dg = VStaticGraph{Int,6,true}()
    @test add_edge!(g, 1, 2)
    @test add_edge!(dg, 1, 3)
    @test ne(g) == ne(dg) == 1
    @test rem_edge!(g, 1, 2)
    @test rem_edge!(dg, 1, 3)
    @test ne(g) == ne(dg) == 0
    @test !rem_edge!(g, 1, 2)
    @test !rem_edge!(dg, 1, 3)

    # checking vertices bounds
    @test !rem_edge!(g, 1, 7)
    @test !rem_edge!(dg, 1, 10)
end

@testset "Edge iterator" begin
    g = VStaticGraph{Int,6,false}()
    dg = VStaticGraph{Int,6,true}()

    !in(Edge(1, 2), edges(g))
    add_edge!(g, 1, 2)
    add_edge!(dg, 1, 3)
    @test Edge(1, 2) in edges(g)
    @test Edge(1, 3) in edges(dg)
    @test Edge(2, 1) in edges(g)
    @test Edge(3, 1) in edges(dg)
end
