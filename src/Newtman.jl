module Newtman

using RandomNumbers.Xorshifts
using RandomNumbers.PCG
using Base.Printf
using StaticArrays

export TestFunctions
include(joinpath("TestFunctions", "TestFunctions.jl"))

export Particle, Population
include("population/types.jl")

export OptimizationResults, PopulationBase, Metaheuristic
include("solvers/solvers.jl")

export PSO
include("solvers/pso.jl")

export SimulatedAnnealing, GeneralSimulatedAnnealing
include("solvers/simulated_annealing.jl")

end
