abstract type TestFunctions end

abstract type Unconstrained <: TestFunctions end

include("implementations.jl")

export evaluate

test_functions = Dict([(:Sphere, :_sphere), (:Easom, :_easom)])

for (k, v) in test_functions
    @eval $k(x::T) where T = $v(x)
    @eval evaluate(b::$k, x) = $v(x)
end
