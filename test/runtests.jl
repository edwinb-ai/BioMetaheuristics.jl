using Newtman
using Test

@testset "Newtman.jl" begin
    include("functests.jl")
    include("populationtests.jl")
    include("solvers-tests/pso.jl")
end
