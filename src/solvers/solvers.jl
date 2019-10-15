"""
"""
abstract type Solver end

"""
"""
abstract type Metaheuristic <: Solver end

"""
"""
abstract type PopulationBase <: Metaheuristic end

function _evaluate_cost(f::TestFunctions, population::T) where {T<:AbstractArray}
    return evaluate(f, population)
end

function _evaluate_cost(f::Function, population::T) where {T<:AbstractArray}
    return f(population)
end

include("pso.jl")

export PSO
