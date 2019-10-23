using Newtman
using Test
using Base.Threads

@testset "Newtman.jl" begin
    include("functests.jl")
    include("populationtests.jl")
    include("solvers-tests/pso.jl")
end
