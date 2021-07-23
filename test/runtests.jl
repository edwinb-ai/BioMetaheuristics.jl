using BioMetaheuristics
using BioMetaheuristics.TestFunctions
using Test
using StaticArrays
using Random

@testset "BioMetaheuristics.jl" begin
    include("functests.jl")
    include("populationtests.jl")
    include("solvers-tests/pso.jl")
    include("solvers-tests/results.jl")
    include("solvers-tests/simulated_annealing.jl")
    include("apitests.jl")
end
