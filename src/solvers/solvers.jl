"""
    Solver

Abstract super-type for every algorithm implementation.
"""
abstract type Solver end

"""
    Metaheuristic

Abstract type for metaheuristic algorithms, this makes a clear
distinction between different classifications of metaheuristic algorithms.
"""
abstract type Metaheuristic <: Solver end

"""
    PopulationBase

Type for population-based algorithms that employ [`Population`](@ref), i.e.
subroutines that _mutate_ an array of possible candidates in-place.
An example of this type is [`PSO`](@ref).
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
