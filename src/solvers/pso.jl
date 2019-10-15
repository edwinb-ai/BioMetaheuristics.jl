"""
    PSO

`PSO` is the type associated with the implementation for the
Particle Swarm Optimization as implemented in the
[Algorithms for Optimization](Kochenderfer, M. J., & Wheeler, T. A. (2019). Algorithms for optimization. MIT Press.
) book.
"""
struct PSO <: PopulationBase end

"""
    PSO

Method that implements `PSO` for a `Function` type.

# Examples
```jldoctest
using Newtman

# Define the Sphere function
function f_sphere(x)
    return sum(x .^ 2)
end

# Implement PSO for a 3-dimensional Sphere function, with
# 100 iterations and 30 particles in the population.
val = PSO(f_sphere, Population(30, 3, -5.0, 5.0), 100;
    w=0.5, c1=0.25, c2=1.5)

val ≈ zeros(3)

# output
true
```
"""
function PSO(f::Function, population::AbstractArray, k_max::Int;
    w=1.0, c1=1.0, c2=1.0)

    _pso!(f, population, k_max; w=w, c1=c1, c2=c2)
end

"""
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
