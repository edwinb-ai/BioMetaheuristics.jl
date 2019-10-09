using Newtman
using Test

@testset "Newtman.jl" begin
    # Simple constructor calls
    @test Sphere(zeros(4)) ≈ 0.0
    @test Sphere(ones(4)) ≈ 4.0
    @test Sphere(0.0) ≈ 0.0
    @test Sphere(5.0) ≈ 25.0
    # Using symbols
    @test evaluate(:Sphere, 0.0) == 0.0
    @test evaluate(:Sphere, zeros(10)) == 0.0
    # Using multiple dispatch
    @test evaluate(Sphere(), 0.0) == 0.0
end
