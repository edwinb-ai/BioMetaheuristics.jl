struct Sphere <: GlobalFunctions
    cost
end

function sphere(x::AbstractArray)
    return sum(x .^ 2)
end

function sphere(x::Real)
    return sum(x ^ 2)
end

Sphere(x) = sphere(x)
