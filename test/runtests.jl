using Newtman
using Test
using Statistics
using HypothesisTests

@testset "Newtman.jl" begin
    include("functests.jl")
    include("populationtests.jl")
    include("solvers-tests/pso.jl")
end
