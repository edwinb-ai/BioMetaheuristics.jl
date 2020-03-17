"""
    TestFunctions

Abstract supertype for all benchmark functions.
"""
abstract type TestFunctions <: Function end

"""
    Unconstrained

Abstract supertype for all unconstrained benchmark functions.
"""
abstract type Unconstrained <: TestFunctions end

include("implementations.jl")

# Build a dictionary of test functions and their implementations
test_functions = Dict([:Sphere => :_sphere, :Easom => :_easom, :Ackley => :_ackley])

for (k, v) in test_functions
    # Create the methods for the given test functions
    @eval $k(x::T) where T = $v(x)
    # Create a special method for the `TestFunction` type
    @eval evaluate(b::$k, x::T) where T = $v(x)
end

export evaluate
