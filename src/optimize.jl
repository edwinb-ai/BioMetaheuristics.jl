function optimize(f, sol, range, method::PopulationBase;
    rng=nothing,
    iters=1_000,
    ftol=1e-6,
    pop_size=35,
    kwargs...
)
    # If no RNG is passsed, create a randomly seeded one
    if isnothing(rng)
        rng = Xorshifts.Xoroshiro128Plus()
    end

    # Create a population
    dim = length(sol)
    lower, upper = range
    pops = Population(pop_size, dim, lower, upper, rng)
    for p in pops
        p.x_best = copy(sol)
    end

    # Send to the PopulationBase method
    val = optimize(f, pops, iters, rng, method; kwargs...)

    return val
end
