import BioMetaheuristics.TestFunctions: Benchmark, evaluate

# Some useful constants
const ln2 = log(2.0)
const sqrtpi = √π

struct SimulatedAnnealing <: TrajectoryBase end

struct GeneralSimulatedAnnealing <: TrajectoryBase end

# To enable dispatch based on the type
function optimize(f, range, dim, iters, rng, ::SimulatedAnnealing; kwargs...)
    return SimulatedAnnealing(f, range..., dim, rng; low_temp=iters, kwargs...)
end

function optimize(f, range, dim, iters, rng, ::GeneralSimulatedAnnealing; kwargs...)
    return GeneralSimulatedAnnealing(f, range..., dim, rng; low_temp=iters, kwargs...)
end

"""
    SimulatedAnnealing(f::Function, a, b, dim::Integer, rng;
        low_temp=5000, t0=500.0
    ) -> OptimizationResults
    SimulatedAnnealing(f::Benchmark, a, b, dim::Integer, rng;
        low_temp=5000, t0=500.0
    ) -> OptimizationResults

Implementation of the *classical* version of simulated annealing.

This implementation uses a logarithmic cooling schedule and searches possible candidate solutions by sampling from an approximated Boltzmann distribution, drawn as a normal distribution.

Returns an `OptimizationResults` type with information relevant to the run executed, see [`OptimizationResults`](@ref).

# Arguments

- `f`: any user defined `Function` that can take `AbstractArray`'s.
- `a`: **lower** bound for the solution search space.
- `b`: **upper** bound for the solution search space.
- `dim`: dimension of the optimization problem.
- `rng`: an object of type `AbstractRNG`.

# Keyword arguments

_It is recommended to use the default values provided._

- `t0`: initial value for the *temperature* that is used. The default is an okay value, but should be changed depending on the optimization problem.
- `low_temp`: total number of iterations, short for *lowering temperature steps*. This also corresponds to the famous *Monte Carlo steps*, which are the total number of steps until the algorithm finishes.

# Examples

```julia
using BioMetaheuristics
using Random

rng = MersenneTwister()

# Define the 2D Rosenbrock function
rosenbrock2d(x) =  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

# Implement Simulated Annealing for a 2-dimensional Rosenbrock function, with
# 5000 iterations.
val = SimulatedAnnealing(rosenbrock2d, -5.0, 5.0, 2, rng; low_temp=5000)
```
"""
function SimulatedAnnealing(
    f::Function,
    a,
    b,
    dim::Integer,
    rng;
    t0=500.0,
    low_temp=5000
)
    # Enforce type stability
    a, b = promote(a, b)

    # Create the solution with random initial values within the
    # search space bounds
    x_solution = a .+ rand(rng, typeof(a), dim) * (b - a)

    # We create a temporal array for copying values
    xtmp = similar(x_solution)

    t = t0

    for j = 1:low_temp
        # Determine the temperature for current iteration
        x = _temperature!(t)

        # Create a neighbor solution
        _classical_visit(x_solution, xtmp, sqrt(x), rng)

        # Clip the resulting solution to the bounds
        _clip_trajectory!(x_solution, a, b)

        # Employ the Metropolis-Hastings algorithm
        _annealing!(f, x, x_solution, xtmp, rng)

        # Update the temperature with the classical cooling schedule
        t *= x * t0
    end

    res = OptimizationResults(x_solution, f(x_solution), "SimulatedAnnealing", low_temp)

    return res
end  # function SimulatedAnnealing

function SimulatedAnnealing(
    f::Benchmark,
    a,
    b,
    dim::Integer,
    rng;
    t0=500.0,
    low_temp=5000
)
    return SimulatedAnnealing(x -> evaluate(f, x), a, b, dim, rng;
        t0=t0, low_temp=low_temp)
end

@inline function _temperature!(x)
    # Avoid evaluating the logarithm at zero
    @assert x > -1.0

    return ln2 / log(1.0 + x)
end  # function temperature

function _classical_visit(x, xtmp, σ, rng)
    for i in eachindex(x)
        @inbounds xtmp[i] = x[i] + randn(rng, Float64) * σ
    end

    return nothing
end  # function _classical_visit!

function _annealing!(f::Function, t, x, xtmp, rng)
    # Evaluate the energies
    new_energy = f(xtmp)
    old_energy = f(x)

    # If the new energy is better, update it
    if new_energy <= old_energy
        copyto!(x, xtmp)
    # If not, we accept it with the Metropolis-Hastings algorithm
    else
        Δ = old_energy - new_energy
        # Compute acceptance probability
        acceptance = exp(Δ / t)
        # Metropolis-Hastings criterion
        if rand(rng) <= acceptance
            copyto!(x, xtmp)
        end
    end

    return nothing
end  # function _annealing

@doc raw"""
    GeneralSimulatedAnnealing(f::Function, a, b, dim::Integer, rng;
        low_temp=5_000, t0=500.0, qv=2.7, qa=-5.0
    ) -> OptimizationResults
    GeneralSimulatedAnnealing(f::Benchmark, a, b, dim::Integer, rng;
        low_temp=20_000, t0=500.0, qv=2.7, qa=-5.0
    ) -> OptimizationResults

Implementation of the *generalized* version of simulated annealing.

This implementation uses all the theory from Tsallis & Stariolo for the cooling schedule and the neighbor solution search.
See [`GeneralSimulatedAnnealing`](@ref generalized-sm) for the implementation details.

Returns an `OptimizationResults` type with information relevant to the run executed, see [`OptimizationResults`](@ref).

# Arguments

- `f`: any user defined `Function` that can take `AbstractArray`'s.
- `a`: **lower** bound for the solution search space.
- `b`: **upper** bound for the solution search space.
- `dim`: dimension of the optimization problem.
- `rng`: an object of type `AbstractRNG`.

# Keyword arguments
_It is recommended to use the default values provided._

- `t0`: initial value for the *temperature* that is used. The default is an okay value, but should be changed depending on the optimization problem.
- `low_temp`: total number of iterations, short for *lowering temperature steps*. This also corresponds to the famous *Monte Carlo steps*, which are the total number of steps until the algorithm finishes.
- `qv`: This is known as the *Tsallis parameter*; particularly this parameter controls the cooling schedule convergence and neighbor search. Positive values in the interval ``[1,5/3)`` are best because for values larger than 5/3 the neighbor search diverges.
- `qa`: Another *Tsallis parameter*; this particular parameter controls convergence for the Metropolis-Hastings algorithm and the acceptance probability involved. The more negative the value is, the better, but Tsallis & Stariolo report that the default value is best.

# Examples

```julia
using BioMetaheuristics
using Random

rng = MersenneTwister()
# Define the 2D Rosenbrock function
rosenbrock2d(x) =  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

# Implement Simulated Annealing for a 2-dimensional Rosenbrock function, with
# 15000 iterations and default values.
val = GeneralSimulatedAnnealing(rosenbrock2d, -5.0, 5.0, 2, rng; low_temp=15_000)
```
"""
function GeneralSimulatedAnnealing(
    f::Function,
    a,
    b,
    dim::Integer,
    rng;
    t0=500.0,
    low_temp=20_000,
    qv=2.7,
    qa=-5.0
)
    # Enforce type stability
    a, b = promote(a, b)

    # Create the solution with random initial values within the
    # search space bounds
    x_solution = a .+ rand(rng, typeof(a), dim) * (b - a)

    # We create a temporal array for copying values
    xtmp = similar(x_solution)

    t = t0

    for j = 1:low_temp
        # Determine the temperature for current iteration
        x = _general_temperature!(t, qv)

        # Create a neighbor solution
        _general_visit(x_solution, xtmp, x, qv, rng)

        # Clip the resulting solution to the bounds
        _clip_trajectory!(x_solution, a, b)

        # Employ the Metropolis-Hastings algorithm
        _general_annealing!(f, x, x_solution, xtmp, qa, rng)

        # Update the temperature with the generalized cooling schedule
        t *= x * t0
    end

    res = OptimizationResults(x_solution, f(x_solution), "GeneralizedSimulatedAnnealing", low_temp)

    return res
end  # function GeneralSimulatedAnnealing

function GeneralSimulatedAnnealing(
    f::Benchmark,
    a,
    b,
    dim::Integer,
    rng;
    t0=500.0,
    low_temp=20_000,
    qv=2.7,
    qa=-5.0
)
    return GeneralSimulatedAnnealing(x -> evaluate(f, x), a, b, dim, rng;
        t0=t0, low_temp=low_temp, qv=qv, qa=qa)
end

"""
    This is the algorithm from Tsallis & Stariolo to sample the distribution
shown in their paper, by approximating their probability distribution as a
Lévy probability distribution.

See the appendix on the paper:
Tsallis, C. and Stariolo, D. A. (1996) ‘Generalized simulated annealing’, Physica A: Statistical Mechanics and its Applications, 233(1), pp. 395–406. doi: 10.1016/S0378-4371(96)00271-3.
"""
function _general_visit(
    x::AbstractArray{T},
    xtmp::AbstractArray{T},
    τ::T,
    q::T,
    rng
) where {T <: Real}
    factor_1 = exp(log(τ) / (q - 1.0))
    factor_2 = exp((4.0 - q) * log(q - 1.0))
    factor_3 = exp((2.0 - q) * ln2 / (q - 1.0))
    factor_4 = (sqrtpi * factor_1 * factor_2) / (factor_3 * (3.0 - q))
    factor_5 = (1.0 / (q - 1.0)) - 0.5
    factor_6 = π * (1.0 - factor_5) / sin(π * (1.0 - factor_5)) / exp(_gammaln(2.0 - factor_5))
    sigmax = exp(-(q - 1.0) * log(factor_6 / factor_4)) / (3.0 - q)

    @inbounds for i in eachindex(x)
        xx = sigmax .* randn(rng, eltype(x))
        y = randn(rng, eltype(x))
        den = exp((q - 1.0) * log(abs(y)) / (3.0 - q))
        xtmp[i] = x[i] + (xx / den)
    end

    return nothing
end

function _general_annealing!(
    f::Function,
    t::T,
    x::AbstractArray{T},
    xtmp::AbstractArray{T},
    q::T,
    rng
) where {T <: Real}

    # Evaluate the energies
    new_energy = f(xtmp)
    old_energy = f(x)

    # If the new energy is better, update it
    if new_energy < old_energy
        copyto!(x, xtmp)
    # If not, we accept it with the Metropolis-Hastings algorithm
    else
        Δ = new_energy - old_energy
        if q < 0
            acceptance = ((q - 1.0) * Δ) / t
            acceptance += 1.0
            if acceptance >= 0
                if rand(rng) <= 1.0 / acceptance
                    copyto!(x, xtmp)
                end
            end
        else
            power = 1.0 / (q - 1.0)
            # Compute acceptance probability
            acceptance = ((q - 1.0) * Δ) / t
            acceptance += 1.0
            acceptance = acceptance^power
            acceptance = 1.0 / acceptance
            # Metropolis-Hastings criterion
            if rand(rng) <= acceptance
                copyto!(x, xtmp)
            end
        end
    end

    return nothing
end  # function _general_annealing!

"""
    A generalized cooling schedule that should work for every possible type
of Simulated Annealing implementation. When `q` = 1, this reduces to the
classical version.
"""
function _general_temperature!(x, q)
    # Avoid evaluating the logarithm at zero
    @assert x > -1.0

    factor_1 = 2^(q - 1.0) - 1.0
    factor_2 = (1.0 + x)^(q - 1.0) - 1.0

    return factor_1 / factor_2
end
