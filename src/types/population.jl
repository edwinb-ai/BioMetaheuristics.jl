"""
    Individual

Abstract super-type for types that contain their own information.
"""
abstract type Individual end

mutable struct Particle{T<:Real} <: Individual
    x::AbstractArray{T}
    v::AbstractArray{T}
    x_best::AbstractArray{T}
    min_dim::T
    max_dim::T

    function Particle{T}(
        x::AbstractArray{T},
        v::AbstractArray{T},
        x_best::AbstractArray{T},
        a::T,
        b::T
    ) where {T <: AbstractFloat}

        @assert length(x) == length(v) == length(x_best) "Dimension must be unique"

        return new(x, v, x_best, a, b)
    end
end

"""
    Particle(
        x::AbstractArray{T},
        v::AbstractArray{T},
        x_best::AbstractArray{T},
        a::T,
        b::T
    ) where {T <: Real}

A type that can hold information about current position, current velocity,
the _best_ candidate to a solution, as well as defining the bounds.
The dimensions of the `Particle` are inferred from the length of the arrays.

# Arguments
- `x`: Array that holds the **positions** of possible solutions.
- `v`: Array that holds **velocities** related to `x`.
- `x_best`: An element of `x` that determines the best position for the particle.
- `a`: lower bound for `x`
- `b`: upper bound for `v`

# Example
```julia
p = Particle(zeros(3), rand(3), zeros(3), -1.0, 1.0)
```
"""
Particle(
    x::AbstractArray{T},
    v::AbstractArray{T},
    x_best::AbstractArray{T},
    a::T,
    b::T
) where {T <: Real} =
    Particle{T}(x, v, x_best, a, b)

"""
    Particle(a, b, n::Int)

`Particle` that can be created randomly using the bounds and the dimension needed.

# Arguments
- `a`: _lower_ bound for `x` and `v`.
- `b`: _upper_ bound for `x` and `v`.
- `n`: dimension for `x`, `v`, and `x_best`.

# Example
```julia
p = Particle(-1.0, 1.0, 3)
```
"""
function Particle(a, b, n::Int; seed = nothing)
    @assert n > 0 "Dimension is always positive"

    if isnothing(seed)
        rng = Xorshifts.Xoroshiro128Plus()
    else
        rng = Xorshifts.Xoroshiro128Plus(seed)
    end

    T = typeof(a)
    x = a .+ (rand(rng, T, n) * (b - a))
    v = a .+ (rand(rng, T, n) * (b - a))
    x_best = rand(rng, T, n)

    return Particle(x, v, x_best, a, b)
end

mutable struct Population end

"""
    Population(num_particles::T, dim::T, a::V, b::V)
        where {T<:Int, V<:AbstractFloat} -> Vector{Particle}(undef, num_particles)

An array of `Particle`s where each of them are bounded and are given a dimension. This is
essentially a multi-dimensional array. It makes handling `Particle`s much easier.

# Arguments
- `num_particles`: Number of particles in the `Population`.
- `dim`: Dimension for every `Particle`.
- `a`: Lower bound for every `Particle`, this is shared across every instance.
- `b`: Upper bound for every `Particle`, this is shared across every instance.

# Example
```julia
pop = Population(35, 4, -1.0, 1.0)
```
"""
function Population(num_particles::T, dim::T, a, b; seed = nothing) where {T <: Int}
    @assert dim > 0 "Dimension is always positive"
    @assert num_particles > 0 "There must be at least 1 Particle in the Population"

    container = Vector{Particle}(undef, num_particles)
    for idx in eachindex(container)
        container[idx] = Particle(a, b, dim; seed = seed)
    end

    return container
end

"""
    Population(num_particles::Integer, dim::Integer, x...)
        -> Vector{Particle}(undef, num_particles)

An array of `Particle`'s where each of them are bounded and are given a dimension.
`x` is a tuple of ranges for each *dimension* for the `Particle`'s specified.

# Arguments
- `num_particles`: Number of particles in the `Population`.
- `dim`: Dimension for every `Particle`.
- `x`: Tuple of ranges for each dimension.

# Example
```julia
# Two ranges, one for each dimension
range_a = SVector(-10.0, 10.0)
range_b = SVector(-2.5, 2.0)
pops = Population(2, 20, ranges_a, range_b)
```
"""
function Population(
    num_particles::T,
    dim::T,
    x...;
    seed = nothing
) where {T <: Int}
    @assert dim > 0 "Dimension is always positive"
    @assert num_particles > 0 "There must be at least 1 Particle in the Population"

    container = Vector{Particle}(undef, num_particles)

    # Loop over each number of particles and dimension
    for (idx, jdx) in zip(eachindex(container), 1:dim)
        # Splat the ranges, considering they're AbstractArray's
        container[idx] = Particle(x[jdx]..., dim; seed = seed)
    end

    return container
end
