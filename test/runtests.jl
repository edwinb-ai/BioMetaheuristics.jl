using Newtman
using Test

@testset "Newtman.jl" begin
    # Array version
    @test Sphere(zeros(4)) ≈ 0.0
    @test Sphere(ones(4)) ≈ 4.0
    # Scalar version
    @test Sphere(0.0) ≈ 0.0
    @test Sphere(5.0) ≈ 25.0
    # Evaluate the function with a scalar
    @test evaluate(:Sphere, 0.0) == 0.0
    # Evaluate the function with an array
    @test evaluate(:Sphere, zeros(10)) == 0.0
end
