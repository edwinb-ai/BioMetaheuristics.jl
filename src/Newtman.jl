module Newtman

using RandomNumbers.Xorshifts
using RandomNumbers.PCG
using Base.Threads
using Statistics
using Base.Printf

include("test-functions/functions.jl")
include("population/types.jl")
export Particle, Population
include("solvers/solvers.jl")
export OptimizationResults, PopulationBase
include("solvers/pso.jl")
export PSO

end
