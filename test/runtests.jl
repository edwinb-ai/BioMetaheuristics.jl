using Newtman
using Newtman.TestFunctions
using Test
using Base.Threads
using StaticArrays

@testset "Newtman.jl" begin
    # include("functests.jl")
    # include("populationtests.jl")
    # include("solvers-tests/pso.jl")
    # include("solvers-tests/results.jl")
    include("solvers-tests/simulated_annealing.jl")
end
