abstract type TestFunctions end

abstract type Unconstrained <: TestFunctions end

abstract type UnconstrainedGlobal <: Unconstrained end

export evaluate

function evaluate(f::UnconstrainedGlobal, x)
    val = f(x)
    return val
end
