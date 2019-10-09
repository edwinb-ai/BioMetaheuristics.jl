export Sphere

struct Sphere <: UncGlobal
    cost::Real
end

Sphere(x::Real) = sum(x ^ 2)

Sphere(x::AbstractArray) = sum(x .^ 2)
