"""
    Metaheuristic

Abstract type for metaheuristic algorithms, this makes a clear
distinction between different classifications of metaheuristic algorithms.
"""
abstract type Metaheuristic end

"""
    PopulationBase <: Metaheuristic

Type for population-based algorithms that employ [`Population`](@ref), i.e.
subroutines that _mutate_ an array of possible candidates in-place.
An example of this type is [`PSO`](@ref).
"""
abstract type PopulationBase <: Metaheuristic end

"""
    OptimizationResults{T, U}

Type that formats the output of [`Metaheuristic`](@ref) to get better information
from it.

# Fields
- `x::T`: Stores the _solution_ array from the solver, i.e. the solution that minimizes
    the cost function.
- `min::U`: Stores the value obtained from evaluating the cost function with
    `x`, i.e. the minima found.
- `impl::AbstractString`: Stores the name of the `Metaheuristic` used, i.e. the name or identifier of the
    optimization algorithm.
- `iterations::Integer`: Stores the number of maximum iterations that the solver was run.
"""
mutable struct OptimizationResults{T,U}
    x::T
    min::U
    impl::AbstractString
    iterations::Integer
end

function Base.show(io::IO, r::OptimizationResults)
    println("Results from Optimization")
    @printf(io, "\tAlgorithm: %s\n", r.impl)
    @printf(io, "\tSolution: [%s]\n", join(r.x, ", "))
    @printf(io, "\tMinimum: %.4f\n", r.min)
    @printf(io, "\tMaximum iterations: %d\n", r.iterations)
end
