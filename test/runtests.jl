import Newtman
using Test

@testset "Newtman.jl" begin
    # Array version
    @test Newtman.Sphere(zeros(4)) ≈ 0.0
    # Scalar version
    @test Newtman.Sphere(0.0) ≈ 0.0
end
