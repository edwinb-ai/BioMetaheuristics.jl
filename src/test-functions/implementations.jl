export Sphere

struct Sphere <: UncGlobal
    cost
end

function _sphere(x::AbstractArray)
    return sum(x .^ 2)
end

function _sphere(x::Real)
    return sum(x ^ 2)
end

Sphere(x) = _sphere(x)
