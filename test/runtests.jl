using Newtman
using Test

@testset "Newtman.jl" begin
    # Array version
    @test Sphere(zeros(4)) ≈ 0.0
    # Scalar version
    @test Sphere(0.0) ≈ 0.0
    # Default value
    @test x = begin
                val = Sphere()
                val.cost == 0.0
    end
    # Evaluate the function with a scalar
    @test evaluate(Sphere(), 0.0) == 0.0
    # Evaluate the function with an array
    @test evaluate(Sphere(), zeros(10)) == 0.0
end
