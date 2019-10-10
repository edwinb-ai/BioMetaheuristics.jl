abstract type Individual end

export Particle, Population

mutable struct Particle{T<:AbstractArray, V<:AbstractFloat} <: Individual
    x::T
    v::T
    x_best::T
    min_dim::V
    max_dim::V

    Particle{T, V}(x::T, v::T, x_best::T, a::V, b::V) where
        {T<:AbstractArray, V<:AbstractFloat} =
        new(x, v, x_best, a, b)
end

Particle(x::T, v::T, x_best::T, a::V, b::V) where {T<:AbstractArray, V<:AbstractFloat} =
    Particle{T, V}(x, v, x_best, a, b)

function _particle(a, b, n::Int)
    @assert n > 0 "Dimension is always positive"

    x = a .+ (rand(Float64, n) * (b - a))
    v = a .+ (rand(Float64, n) * (b - a))
    x_best = rand(Float64, n)
    new_particle = Particle(x, v, x_best, a, b)

    return new_particle
end

mutable struct Population end

function Population(dim, a, b)
    container = Vector{Particle}(undef, dim)
    for idx in eachindex(container)
        container[idx] = _particle(a, b, dim)
    end
    return container
end
