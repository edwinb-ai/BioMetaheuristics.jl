module Newtman

import RandomNumbers.Xorshifts
using Printf: @printf
using StaticArrays
using Random

include(joinpath("TestFunctions", "TestFunctions.jl"))
export TestFunctions

include("types/population.jl")
export Particle, Population

include("types/solvers.jl")
export OptimizationResults, PopulationBase, Metaheuristic

include("solvers/pso.jl")
export PSO

include("solvers/simulated_annealing.jl")
export SimulatedAnnealing, GeneralSimulatedAnnealing

end
