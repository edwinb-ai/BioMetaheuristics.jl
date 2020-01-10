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

test_functions = Dict([:Sphere => :_sphere, :Easom => :_easom, :Ackley => :_ackley])

function _create_methods(d::Dict)
    for (k, v) in d
        @eval $k(x::T) where T = $v(x)
        @eval evaluate(b::$k, x::T) where T = $v(x)
    end
    return nothing
end

# TODO: Document these methods!

_create_methods(test_functions)

export evaluate
