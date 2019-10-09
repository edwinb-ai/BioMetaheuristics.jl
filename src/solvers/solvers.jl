abstract type Solver end

abstract type Metaheuristic <: Solver end

abstract type PopulationBase <: Metaheuristic end

include("pso.jl")
