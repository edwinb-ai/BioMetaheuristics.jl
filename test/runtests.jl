using Newtman
using Test

@testset "Newtman.jl" begin
    include("impltests.jl")
    include("solvers/pso.jl")
end
