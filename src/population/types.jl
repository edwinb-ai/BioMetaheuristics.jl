"""
    Individual

Abstract super-type for types that contain their own information.
"""
abstract type Individual end

mutable struct Particle{T <: AbstractArray,V <: AbstractFloat} <: Individual
    x::T
    v::T
    x_best::T
    min_dim::V
    max_dim::V

    function Particle{T,V}(x::T, v::T, x_best::T, a::V, b::V) where
        {T <: AbstractArray,V <: AbstractFloat}

        @assert length(x) == length(v) == length(x_best) "Dimension must be unique"

        return new(x, v, x_best, a, b)
    end
end

"""
    Particle(x::T, v::T, x_best::T, a::V, b::V)
        where {T<:AbstractArray, V<:AbstractFloat}

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
Particle(x::T, v::T, x_best::T, a::V, b::V) where {T <: AbstractArray,V <: AbstractFloat} =
    Particle{T,V}(x, v, x_best, a, b)

"""
    Particle(a::T, b::T, n::V)
        where {T<:AbstractFloat, V<:Int}

`Particle` that can be created randomly using the bounds and the dimension needed.

# Arguments
- `a`: lower bound for `x`
- `b`: upper bound for `v`
- `n`: dimension for `x`, `v`, and `x_best`.

# Example
```julia
p = Particle(-1.0, 1.0, 3)
```
"""
function Particle(
    a::T, b::T, n::V; seed = nothing
) where {T <: AbstractFloat, V <: Int}
    @assert n > 0 "Dimension is always positive"

    if isnothing(seed)
        rng = Xoroshiro128Plus()
    else
        rng = Xoroshiro128Plus(seed)
    end

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
function Population(
    num_particles::T, dim::T, a::V, b::V; seed = nothing
) where {T <: Int,V <: AbstractFloat}
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
    num_particles::Integer,
    dim::Integer,
    x...;
    seed = nothing
)
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
