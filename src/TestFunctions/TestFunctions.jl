module TestFunctions

export Benchmark, Unconstrained

"""
    Benchmark

Abstract supertype for all benchmark functions.
"""
abstract type Benchmark <: Function end

"""
    Unconstrained

Abstract supertype for all unconstrained benchmark functions.
"""
abstract type Unconstrained <: Benchmark end

export evaluate, Sphere, Ackley, Rosenbrock, Easom
include("implementations.jl")

end
