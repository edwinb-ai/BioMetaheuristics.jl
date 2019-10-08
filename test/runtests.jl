import Newtman
using Test

@testset "Newtman.jl" begin
    # Array version
    @test Newtman.sphere(zeros(4)) ≈ 0.0
    # Scalar version
    @test Newtman.sphere(0.0) ≈ 0.0
end
