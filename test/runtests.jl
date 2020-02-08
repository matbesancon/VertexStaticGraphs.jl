using VertexStaticGraphs: VStaticGraph

using Test
import Random

using LightGraphs
const LG = LightGraphs
import LightGraphs.SimpleGraphs: SimpleEdge


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
    @test !in(Edge(3, 1), edges(dg))
end

@testset "SimpleGraphs test suite" begin
    @testset "collection operations" begin
        Random.seed!(33)
        ga = VStaticGraph{Int,10,false}()
        gb = VStaticGraph{Int,10,false}()
        dga = VStaticGraph{Int,10,true}()
        dgb = VStaticGraph{Int,10,true}()
        for _ in 1:20
            s = rand(1:10)
            d = rand(1:10)
            add_edge!(ga, s, d)
            s = rand(1:10)
            d = rand(1:10)
            add_edge!(dga, s, d)
        end
        Random.seed!(33)
        for _ in 1:20
            s = rand(1:10)
            d = rand(1:10)
            add_edge!(gb, s, d)
            s = rand(1:10)
            d = rand(1:10)
            add_edge!(dgb, s, d)
        end
        @test @inferred(edges(ga)) == edges(gb)
        @test @inferred(edges(ga)) == collect(Edge, edges(gb))
        @test edges(ga) != collect(Edge, Base.Iterators.take(edges(gb), 5))
        @test collect(Edge, edges(gb)) == edges(ga)
        @test Set{Edge}(collect(Edge, edges(gb))) == edges(ga)
        @test @inferred(edges(ga)) == Set{Edge}(collect(Edge, edges(gb)))

        @test @inferred(edges(dga)) == edges(dgb)
        @test @inferred(edges(dga)) == collect(SimpleEdge, edges(dgb))
        @test edges(dga) != collect(Edge, Base.Iterators.take(edges(dgb), 5))
        @test collect(SimpleEdge, edges(dgb)) == edges(dga)
        @test Set{Edge}(collect(SimpleEdge, edges(dgb))) == edges(dga)
        @test @inferred(edges(dga)) == Set{SimpleEdge}(collect(SimpleEdge, edges(dgb)))
    end

    ga = VStaticGraph{Int,10,false}()
    add_edge!(ga, 3, 2)
    add_edge!(ga, 3, 10)
    add_edge!(ga, 5, 10)
    add_edge!(ga, 10, 3)

    dga = VStaticGraph{Int,10,true}()
    add_edge!(dga, 3, 2)
    add_edge!(dga, 3, 10)
    add_edge!(dga, 5, 10)
    add_edge!(dga, 10, 3)

    e1 = Edge(3, 10)
    e2 = (3, 10)
    @testset "membership operations" begin
        @test e1 ∈ edges(ga)
        @test e2 ∈ edges(ga)
        @test (3, 9) ∉ edges(ga)

        for u in 1:12, v in 1:12
            b = has_edge(ga, u, v)
            @test b == @inferred (u, v) ∈ edges(ga)
            @test b == @inferred (u => v) ∈ edges(ga)
            @test b == @inferred Edge(u, v) ∈ edges(ga)

            db = has_edge(dga, u, v)
            @test db == @inferred (u, v) ∈ edges(dga)
            @test db == @inferred (u => v) ∈ edges(dga)
            @test db == @inferred Edge(u, v) ∈ edges(dga)
        end
    end

    @testset "iterator protocol" begin
        eit = edges(ga)
        # @inferred not valid for new interface anymore (return type is a Union)
        @test collect(eit) == [Edge(2, 3), Edge(3, 10), Edge(5, 10)]

        eit = @inferred(edges(dga))
        @test collect(eit) == [
            SimpleEdge(3, 2), SimpleEdge(3, 10),
            SimpleEdge(5, 10), SimpleEdge(10, 3)
        ]
    end


end