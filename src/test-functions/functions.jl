abstract type TestFunctions end

abstract type Unconstrained <: TestFunctions end

abstract type UnconstrainedGlobal <: Unconstrained end

export evaluate

function evaluate(f::Symbol, x)
    @eval val = $f($x)
    println(typeof(val))
    return val
end
