mutable struct Particle{T <: Real}
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
p = Particle(zeros(3), rand(3), zeros(3), 0.0, 1.0)
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
function Particle(a, b, n::Int, rng)
    @assert n > 0 "Dimension is always positive"

    a, b = promote(a, b)
    x = a .+ (rand(rng, n) * (b - a))
    v = a .+ (rand(rng, n) * (b - a))
    x_best = rand(rng, n)

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
function Population(num_particles::T, dim::T, a, b, rng) where {T <: Int}
    @assert dim > 0 "Dimension is always positive"
    @assert num_particles > 0 "There must be at least 1 Particle in the Population"

    container = Vector{Particle}(undef, num_particles)
    for idx in 1:num_particles
        container[idx] = Particle(a, b, dim, rng)
    end

    return container
end

"""
    Population(num_particles::Int, ranges; seed=nothing)
        -> Vector{Particle}(undef, num_particles)

An array of `Particle`'s where each of them are bounded and are given a dimension.
`x` is a collection of ranges for each *dimension* for the `Particle`'s specified.

# Arguments
- `num_particles`: Number of particles in the `Population`.
- `dim`: Dimension for every `Particle`.
- `x`: Should be a collection of ranges, for instance a tuple or a vector.

# Example
```julia
# Two ranges, one for each dimension
range_a = SVector(-10.0, 10.0)
range_b = SVector(-2.5, 2.0)
pops = Population(2, 20, [ranges_a, range_b])
```
"""
function Population(num_particles::Int, ranges, rng)
    dim = length(ranges)
    @assert dim > 0 "Dimension is always positive"
    @assert num_particles > 0 "There must be at least 1 Particle in the Population"

    container = Vector{Particle}(undef, num_particles)
    element_type_range = eltype(ranges[1]) # Use the type from the first range's elements
    random_values = Matrix{element_type_range}(undef, dim, num_particles)
    rand!(rng, random_values)

    @assert length(ranges) == length(eachrow(random_values))

    @inbounds for (r, idx) in zip(ranges, eachrow(random_values))
        a, b = r # Upper and lower bounds
        # Apply the boundaries for each dimension
        @. idx *= b - a
        @. idx += a
    end

    # Now that each row has random values for each boundary range, we loop over
    # each particle and each row and create the corresponding array
    @inbounds for i in 1:num_particles
        a, b = extrema(random_values[:, i])
        container[i] = Particle(random_values[:, i],
            random_values[:, i], randn(rng, dim), a, b)
    end

    return container
end
