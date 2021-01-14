module Newtman

import RandomNumbers.Xorshifts
using Printf: @printf
using StaticArrays
using Random

include(joinpath("TestFunctions", "TestFunctions.jl"))
export TestFunctions

# Types
include("types/population.jl")
include("types/solvers.jl")
export Particle, Population, OptimizationResults, PopulationBase, Metaheuristic

# Solvers
include("solvers/pso.jl")
include("solvers/simulated_annealing.jl")
export PSO, SimulatedAnnealing, GeneralSimulatedAnnealing

end
