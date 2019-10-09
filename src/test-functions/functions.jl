abstract type TestFunctions end

abstract type Unconstrained <: TestFunctions end

include("implementations.jl")

export evaluate

test_functions = Dict([(:Sphere, :_sphere), (:Easom, :_easom)])

function create_methods(functions::Dict)
    for (k, v) in functions
        @eval $k(x::T) where T = $v(x)
        @eval evaluate(b::$k, x) = $v(x)
    end
    return nothing
end

create_methods(test_functions)
