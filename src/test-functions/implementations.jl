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
