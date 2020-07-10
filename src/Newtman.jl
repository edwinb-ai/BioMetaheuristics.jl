module Newtman

using RandomNumbers.Xorshifts
using RandomNumbers.PCG
using Printf
using StaticArrays

include(joinpath("TestFunctions", "TestFunctions.jl"))
export TestFunctions

include("population/types.jl")
export Particle, Population

include("solvers/solvers.jl")
export OptimizationResults, PopulationBase, Metaheuristic

include("solvers/pso.jl")
export PSO

include("solvers/simulated_annealing.jl")
export SimulatedAnnealing, GeneralSimulatedAnnealing

end
