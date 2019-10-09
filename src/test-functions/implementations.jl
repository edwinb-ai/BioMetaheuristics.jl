export Sphere

struct Sphere <: UnconstrainedGlobal
    cost::Real
    Sphere() = new(0.0)
end

function _sphere(x)
    return sum(x .^ 2)
end

Sphere(x::T) where T = _sphere(x)

(::Sphere)(x::T) where T = _sphere(x)
