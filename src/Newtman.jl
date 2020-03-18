module Newtman

using RandomNumbers.Xorshifts
using RandomNumbers.PCG
using Base.Printf

include("test-functions/functions.jl")
include("population/types.jl")
export Particle, Population
include("solvers/solvers.jl")
export OptimizationResults, PopulationBase, Metaheuristic
include("solvers/pso.jl")
export PSO
include("solvers/simulated_annealing.jl")
export SimulatedAnnealing

end
