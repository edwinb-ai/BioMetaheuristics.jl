"""
"""
struct PSO <: PopulationBase end

function _evaluate_cost(f::TestFunctions, population::T) where {T<:AbstractArray}
    return evaluate(f, population)
end

function _evaluate_cost(f::Function, population::T) where {T<:AbstractArray}
    return f(population)
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

    for k in 1:k_max
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
    return population[1].x_best
end

"""
"""
function PSO(f::Function, population::AbstractArray, k_max::Int;
    w=1.0, c1=1.0, c2=1.0)

    return _pso!(f, population, k_max; w=w, c1=c1, c2=2)
end

"""
"""
function PSO(f::TestFunctions, population::AbstractArray, k_max::Int;
    w=1.0, c1=1.0, c2=1.0)

    _pso!(f, population, k_max; w=w, c1=c1, c2=2)
end
