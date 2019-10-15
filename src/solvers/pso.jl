"""
    PSO

`PSO` is the type associated with the implementation for the
Particle Swarm Optimization as implemented in the original paper
by Kennedy and Eberhart.[^1]

[^1]: Eberhart, R., & Kennedy, J. (1995, November).
Particle swarm optimization. In Proceedings of the IEEE
international conference on neural networks (Vol. 4, pp. 1942-1948).
"""
struct PSO <: PopulationBase end

"""
    PSO(f::Function, population::AbstractArray, k_max::Int;
        w=1.0, c1=1.0, c2=1.0)

Method that implements `PSO` for a function `f` of type `Function`.

# Arguments

- `population`: can be any `AbstractArray` that contains [`Particle`](@ref)
instances, but it is expected to be generated by [`Population`](@ref).
- `k_max`: number of maximum iterations until "convergence" of the algorithm.

# Keyword arguments
- `w`: value that controls how much of the initial velocity is retained, i.e.
an inertia term.
- `c1`: balance between the influence of the individual's knowledge, i.e. the
best inidividual solution so far.
- `c2`: balance between the influence of the population's knowledge, i.e. the
best global solution so far.

# Examples
```julia
using Newtman

# Define the Sphere function
function f_sphere(x)
    return sum(x .^ 2)
end

# Implement PSO for a 3-dimensional Sphere function, with
# 100 iterations and 30 particles in the population.
val = PSO(f_sphere, Population(25, 3, -15.0, 15.0), 45;
    w=0.5, c1=0.25, c2=1.5)
```
"""
function PSO(f::Function, population::AbstractArray, k_max::Int;
    w=1.0, c1=1.0, c2=1.0)

    _pso!(f, population, k_max; w=w, c1=c1, c2=c2)
end

"""
    PSO(f::TestFunctions, population::AbstractArray, k_max::Int;
        w=1.0, c1=1.0, c2=1.0)

Method that implements `PSO` for a function `f` of type `TestFunctions`.

# Arguments

- `population`: can be any `AbstractArray` that contains [`Particle`](@ref)
instances, but it is expected to be generated by [`Population`](@ref).
- `k_max`: number of maximum iterations until "convergence" of the algorithm.

# Keyword arguments

- `w`: value that controls how much of the initial velocity is retained, i.e.
an inertia term.
- `c1`: balance between the influence of the individual's knowledge, i.e. the
best inidividual solution so far.
- `c2`: balance between the influence of the population's knowledge, i.e. the
best global solution so far.

# Examples
```julia
using Newtman

# Implement PSO for a 3-dimensional Sphere function, with
# 100 iterations and 30 particles in the population.
val = PSO(Sphere(), Population(25, 3, -15.0, 15.0), 45;
    w=0.5, c1=0.25, c2=1.5)
```
"""
function PSO(f::TestFunctions, population::AbstractArray, k_max::Int;
    w=1.0, c1=1.0, c2=1.0)

    _pso!(f, population, k_max; w=w, c1=c1, c2=c2)
end

function _update!(f, population, w, c1, c2, n, x_best, y_best)
    for P in population
        r1 = rand(n)
        r2 = rand(n)
        # Update position
        P.x += P.v
        # Evaluate velocity
        P.v = (w * P.v) + (c1 * r1 .* (P.x_best - P.x)) +
            (c2 * r2 .* (x_best - P.x))
        # Clip upper bound
        broadcast!(x -> x > P.max_dim ? P.max_dim : x, P.x, P.x)
        # Clip lower bound
        broadcast!(x -> x < P.min_dim ? P.min_dim : x, P.x, P.x)
        y = _evaluate_cost(f, P.x)

        if y < y_best
            x_best[:] = P.x
            y_best = y
        end

        if y < _evaluate_cost(f, P.x_best)
            P.x_best[:] = P.x
        end
    end
end

function _pso!(f, population::AbstractArray, k_max::Int;
    w=1.0, c1=1.0, c2=1.0)

    n = length(population[1].x) # dimension
    x_best = similar(population[1].x_best)
    y_best = Inf
    for P in population
        y = _evaluate_cost(f, P.x)
        if y < y_best
            x_best[:] = P.x
            y_best = y
        end
    end

    @inbounds for k in 1:k_max
        _update!(f, population, w, c1, c2, n, x_best, y_best)
    end

    return population[1].x_best
end
