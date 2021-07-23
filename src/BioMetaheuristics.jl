module BioMetaheuristics

import RandomNumbers.Xorshifts
using Printf: @printf
using StaticArrays
using Random
import Base: isless

# Benchmark functions module
export TestFunctions
include(joinpath("TestFunctions", "TestFunctions.jl"))

# Types
export Particle, Population, OptimizationResults, PopulationBase, Metaheuristic,
TrajectoryBase
include(joinpath("types", "population.jl"))
include(joinpath("types", "solvers.jl"))

# Some utilities
include("utils.jl")

# Solvers
export PSO, SimulatedAnnealing, GeneralSimulatedAnnealing
include(joinpath("solvers", "pso.jl"))
include(joinpath("solvers", "simulated_annealing.jl"))

# Common API
export optimize
include("optimize.jl")

end
