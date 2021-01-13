module Newtman

import RandomNumbers.Xorshifts
using Printf: @printf
using StaticArrays

include(joinpath("TestFunctions", "TestFunctions.jl"))
export TestFunctions

include("population/types.jl")
export Particle, Population

include("solvers/solvers.jl")
export Solver, OptimizationResults, PopulationBase, Metaheuristic

include("solvers/pso.jl")
export PSO

include("solvers/simulated_annealing.jl")
export SimulatedAnnealing, GeneralSimulatedAnnealing

end
