using Newtman
using Test

@testset "Newtman.jl" begin
    # Array version
    @test Sphere(zeros(4)) ≈ 0.0
    # Scalar version
    @test Sphere(0.0) ≈ 0.0
end
