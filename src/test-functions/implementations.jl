export Sphere

struct Sphere{T<:AbstractFloat} <: Unconstrained
    cost::T
    Sphere{T}(cost) where {T<:AbstractFloat} = new(cost)
end

function _sphere(x)
    return sum(x .^ 2)
end

Sphere(x::T) where T = _sphere(x)
