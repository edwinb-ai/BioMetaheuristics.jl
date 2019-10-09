using Newtman
using Test

@testset "Newtman.jl" begin
    # Simple constructor calls
    @test Sphere(zeros(4)) ≈ 0.0
    @test Sphere(ones(4)) ≈ 4.0
    @test Sphere(0.0) ≈ 0.0
    @test Sphere(5.0) ≈ 25.0
    # Using multiple dispatch
    @test evaluate(Sphere(), 0.0) == 0.0
    @test Easom(fill(3.0, 2)) ≈ -0.94156415
    @test_throws AssertionError Easom(zeros(4))
end
