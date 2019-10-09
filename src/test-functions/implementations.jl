export Sphere

struct Sphere <: UnconstrainedGlobal
    cost::Real
end

Sphere(x::Real) = sum(x ^ 2)

Sphere(x::AbstractArray) = sum(x .^ 2)
