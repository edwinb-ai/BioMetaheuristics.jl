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

abstract type Results end

"""
    OptimizationResults{T, U, V, W}

Type that formats the output of [`Solver`](@ref) to get better information
from it.

# Fields
- `x::T`: Stores the _solution_ array from the solver, i.e. the solution that minimizes
    the cost function.
- `min::U`: Stores the value obtained from evaluating the cost function with
    `x`, i.e. the minima found.
- `impl::AbstractString`: Stores the name of the `Solver` used, i.e. the name or identifier of the
    optimization algorithm.
- `iterations::Integer`: Stores the number of maximum iterations that the solver was run.
"""
mutable struct OptimizationResults{T, U} <: Results
    x::T
    min::U
    impl::AbstractString
    iterations::Integer
end

function Base.show(io::IO, r::OptimizationResults)
    println("Results from Optimization")
    Printf.@printf io "\tAlgorithm: %s\n" r.impl
    Printf.@printf io "\tDesign: [%s]\n" join(r.x, ", ")
    Printf.@printf io "\tMinimum: %.4f\n" r.min
    Printf.@printf io "\tMaximum iterations: %d\n" r.iterations
end

include("pso.jl")

export PSO
