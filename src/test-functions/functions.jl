abstract type TestFunctions end

abstract type Unconstrained <: TestFunctions end

export evaluate

function evaluate(f::Symbol, x)
    @eval val = $f($x)
    return val
end
