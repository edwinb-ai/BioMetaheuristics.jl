"""
"""
struct PSO <: PopulationBase end

"""
"""
function PSO(f, population, k_max; w=1.0, c1=1.0, c2=1.0)

    n = length(population[1].x) # dimension
    x_best = similar(population[1].x_best)
    y_best = Inf

    for P in population
        y = f(P.x)
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
            y = f(P.x)

            if y < y_best
                x_best[:] = P.x
                y_best = y
            end

            if y < f(P.x_best)
                P.x_best[:] = P.x
            end
        end
    end
end
