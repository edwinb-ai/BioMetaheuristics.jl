"""
    function optimize(f, sol, range, method::PopulationBase;
        rng=nothing,
        iters=2_000,
        pop_size=30,
        kwargs...
    ) -> OptimizationResults

The `optimize` constitutes an interface to quickly dispatch over all the possible implementations.

In particular, this function dispatches over all `PopulationBase` implementations.

# Arguments

- `f`: The function to optimize.
- `sol`: A candidate solution, should be an `AbstractArray`. The dimension of this array will determine the dimension of the problem.
- `range`: A collection that contains just two elements, regarding the global bounds of the search space.
- `method`: A `PopulationBase`, e.g. `PSO` for Particle Swarm Optimization.

# Keyword arguments

- `rng`: An `AbstractRNG` object. This will be used for creating the population of solutions as well as for the implementation itself. If you wish to enforce reproducibility of results, create an RNG object with a set seed. If you do not pass an RNG object, a `Xorshifts.Xoroshiro128Plus` RNG will be created, using a truly random seed taken from the system.
- `iters`: The total number of iterations for the main loop in the implementation.
- `pop_size`: The total size of the population. The larger the population, the longer it will take to converge. A good population size is somewhere between 20-35.
- `kwargs`: Keyword arguments passed on to the particular implementation. Each implementation has its own keyword arguments so check the documentation for a specific implementation in order to modify these arguments.
"""
function optimize(f, sol, range, method::PopulationBase;
    rng=nothing,
    iters=2_000,
    pop_size=35,
    kwargs...
)
    @assert length(range) == 2 "No more than two global bounds."
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

    # Dispatch to the PopulationBase method
    val = optimize(f, pops, iters, rng, method; kwargs...)

    return val
end

"""
    function optimize(f, sol, range, method::TrajectoryBase;
        rng=nothing,
        iters=2_000,
        kwargs...
    ) -> OptimizationResults

The `optimize` constitutes an interface to quickly dispatch over all the possible implementations.

In particular, this function dispatches over all `TrajectoryBase` implementations.

# Arguments

- `f`: The function to optimize.
- `sol`: A candidate solution, should be an `AbstractArray`. The dimension of this array will determine the dimension of the problem.
- `range`: A collection that contains just two elements, regarding the global bounds of the search space.
- `method`: A `TrajectoryBase` object, e.g. `SimulatedAnnealing` for the simulated annealing implementation.

# Keyword arguments

- `rng`: An `AbstractRNG` object. This will be used for creating the population of solutions as well as for the implementation itself. If you wish to enforce reproducibility of results, create an RNG object with a set seed. If you do not pass an RNG object, a `Xorshifts.Xoroshiro128Plus` RNG will be created, using a truly random seed taken from the system.
- `iters`: The total number of iterations for the main loop in the implementation.
- `kwargs`: Keyword arguments passed on to the particular implementation. Each implementation has its own keyword arguments so check the documentation for a specific implementation in order to modify these arguments.
"""
function optimize(f, sol, range, method::TrajectoryBase;
    rng=nothing,
    iters=2_000,
    pop_size=35,
    kwargs...
)
    @assert length(range) == 2 "No more than two global bounds."
    # If no RNG is passsed, create a randomly seeded one
    if isnothing(rng)
        rng = Xorshifts.Xoroshiro128Plus()
    end

    # Dispatch to the TrajectoryBase method
    val = optimize(f, range, length(sol), iters, rng, method; kwargs...)

    return val
end
