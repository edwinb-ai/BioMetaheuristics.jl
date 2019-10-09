export Sphere, evaluate

struct Sphere <: Unconstrained end

function _sphere(x)
    return sum(x .^ 2)
end

Sphere(x::T) where T = _sphere(x)

function evaluate(f::Sphere, x)
    return _sphere(x)
end

function evaluate(f::Symbol, x)
    @eval val = $f($x)
    return val
end

struct Easom <: Unconstrained end

function _easom(x)
    term_1 = -cos.(x[1]) * cos.(x{2})
    term_2 = exp.(-(x[1] - π) .^ 2 - (x[2] - π) .^ 2)

    return term_1 * term_2
end
