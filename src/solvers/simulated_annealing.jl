import Newtman.TestFunctions: Benchmark, evaluate

const ln2 = log(2.0)
const sqrtpi = √π

struct SimulatedAnnealing <: Metaheuristic end

struct GeneralSimulatedAnnealing <: Metaheuristic end

"""
    SimulatedAnnealing(f::Benchmark, a::T, b::T, dim::Integer;
        t0 = 500.0, low_temp = 5000) where {T <: AbstractFloat} -> OptimizationResults

Same implementation as the one for [`SimulatedAnnealing`](@ref) except that this one
can accept `Benchmark` functions implemented within `Newtman.TestFunctions`.

# Examples

```julia
using Newtman

# Implement Simulated Annealing for a 3-dimensional Rosenbrock function, with
# 10000 iterations.
val = SimulatedAnnealing(Rosenbrock(), -5.0, 5.0, 3; low_temp = 10000)
```
"""
function SimulatedAnnealing(
    f::Benchmark,
    a::T,
    b::T,
    dim::Integer;
    t0 = 500.0,
    low_temp = 5000,
    seed = nothing,
) where {T <: AbstractFloat}
    return SimulatedAnnealing(x->evaluate(f, x), a, b, dim;
        t0 = t0, low_temp = low_temp, seed = seed)
end

"""
    SimulatedAnnealing(f::Function, a::T, b::T, dim::Integer;
        t0 = 500.0, low_temp = 5000, seed = nothing
        ) where {T <: AbstractFloat} -> OptimizationResults

Implementation of the *classical* version of simulated annealing. This implementation uses a logarithmic cooling schedule and searches possible candidate solutions by sampling from an approximate Boltzmann distribution,
drawn as a normal distribution.

Returns an `OptimizationResults` type with information relevant to the run executed, see [`OptimizationResults`](@ref).

# Arguments
- `f`: any user defined `Function` that can take `AbstractArray`'s.
- `a`: **lower** bound for the solution search space.
- `b`: **upper** bound for the solution search space.
- `dim`: dimension of the optimization problem.

# Keyword arguments
_It is recommended to use the default values provided._

- `t0`: initial value for the *temperature* that is used. The default is an okay
value, but should be changed depending on the optimization problem.

- `low_temp`: total number of iterations, short for *lowering temperature steps*.
This also corresponds to the famous *Monte Carlo steps*, which are the total number
of steps until the algorithm finishes.

- `seed`: an integer to be used as the seed for the pseudo random number generators.
If `nothing` is passed (the default), then a random seed will be taken from the
system.

# Examples

```julia
using Newtman

# Define the 2D Rosenbrock function
rosenbrock2d(x) =  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

# Implement Simulated Annealing for a 2-dimensional Rosenbrock function, with
# 5000 iterations.
val = SimulatedAnnealing(rosenbrock2d, -5.0, 5.0, 2; low_temp = 5000)
```
"""
function SimulatedAnnealing(
    f::Function,
    a::T,
    b::T,
    dim::Integer;
    t0 = 500.0,
    low_temp = 5000,
    seed = nothing,
) where {T <: AbstractFloat}

    # Use a user specified seed if necessary
    if isnothing(seed)
        rng = Xorshifts.Xorshift1024Star()
    else
        rng = Xorshifts.Xorshift1024Star(seed)
    end

    # Create the solution with random initial values within the
    # search space bounds
    x_solution = a .+ rand(rng, T, dim) * (b - a)

    # We create a temporal array for copying values
    xtmp = similar(x_solution)

    t = t0

    for j = 1:low_temp
        # Determine the temperature for current iteration
        x = _temperature!(t)

        # Create a neighbor solution
        _classical_visit(x_solution, xtmp, sqrt(x), rng)

        # Employ the Metropolis-Hastings algorithm
        _annealing!(f, x, x_solution, xtmp, rng)

        # Update the temperature with the classical cooling schedule
        t *= x * t0
    end

    res = OptimizationResults(x_solution, f(x_solution), "SimulatedAnnealing", low_temp)

    return res
end  # function SimulatedAnnealing

@inline function _temperature!(x::AbstractFloat)

    # Avoid evaluating the logarithm at zero
    @assert x > -1.0

    return ln2 / log(1.0 + x)
end  # function temperature

function _classical_visit(x::AbstractArray, xtmp::AbstractArray, σ::AbstractFloat, rng)

    @simd for i in eachindex(x)
        @inbounds xtmp[i] = x[i] + randn(rng, Float64) * σ
    end
end  # function _classical_visit!

function _annealing!(f::Function, t::AbstractFloat, x::AbstractArray, xtmp::AbstractArray, rng)

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
end  # function _annealing

"""
    GeneralSimulatedAnnealing(
        f::Benchmark, a::T, b::T, dim::Integer;
        t0 = 500.0, low_temp = 20000, qv = 2.7, qa = -5.0
        ) where {T <: AbstractFloat} -> OptimizationResults

Same implementation as the one for [`GeneralSimulatedAnnealing`](@ref) except that this one
can accept `Benchmark` functions implemented within `Newtman.TestFunctions`.

# Examples

```julia
using Newtman

# Implement General Simulated Annealing for a 3-dimensional Rosenbrock function, with
# 10000 iterations.
val = GeneralSimulatedAnnealing(Rosenbrock(), -5.0, 5.0, 3; low_temp = 10000)
```
"""
function GeneralSimulatedAnnealing(
    f::Benchmark,
    a::T,
    b::T,
    dim::Integer;
    t0 = 500.0,
    low_temp = 20000,
    qv = 2.7,
    qa = -5.0,
    seed = nothing,
) where {T <: AbstractFloat}
    return GeneralSimulatedAnnealing(x->evaluate(f, x), a, b, dim;
        t0 = t0, low_temp = low_temp, qv = qv, qa = qa, seed = seed)
end

@doc raw"""
    GeneralSimulatedAnnealing(
        f::Function, a::T, b::T, dim::Integer;
        t0 = 500.0, low_temp = 5000, qv = 2.7, qa = -5.0,
        seed = nothing
        ) where {T <: AbstractFloat} -> OptimizationResults

Implementation of the *generalized* version of simulated annealing. This implementation uses all the theory from Tsallis & Stariolo for the cooling schedule and the
neighbor solution search. See [`GeneralSimulatedAnnealing`](@ref) for the implementation
details.

Returns an `OptimizationResults` type with information relevant to the run executed, see [`OptimizationResults`](@ref).

# Arguments
- `f`: any user defined `Function` that can take `AbstractArray`'s.
- `a`: **lower** bound for the solution search space.
- `b`: **upper** bound for the solution search space.
- `dim`: dimension of the optimization problem.

# Keyword arguments
_It is recommended to use the default values provided._

- `t0`: initial value for the *temperature* that is used. The default is an okay
value, but should be changed depending on the optimization problem.

- `low_temp`: total number of iterations, short for *lowering temperature steps*.
This also corresponds to the famous *Monte Carlo steps*, which are the total number
of steps until the algorithm finishes.

- `qv`: This is known as the *Tsallis parameter*; particularly this parameter
controls the cooling schedule convergence and neighbor search. Positive values
in the interval ``[1,5/3)`` are best because for values larger than 5/3 the
neighbor search diverges.

- `qa`: Another *Tsallis parameter*; this particular parameter controls convergence
for the Metropolis-Hastings algorithm and the acceptance probability involved.
The more negative the value is, the better, but Tsallis & Stariolo report that the
default value is best.

- `seed`: an integer to be used as the seed for the pseudo random number generators.
If `nothing` is passed (the default), then a random seed will be taken from the
system.

# Examples

```julia
using Newtman

# Define the 2D Rosenbrock function
rosenbrock2d(x) =  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

# Implement Simulated Annealing for a 2-dimensional Rosenbrock function, with
# 15000 iterations and default values.
val = GeneralSimulatedAnnealing(rosenbrock2d, -5.0, 5.0, 2; low_temp = 15000)
```
"""
function GeneralSimulatedAnnealing(
    f::Function,
    a::T,
    b::T,
    dim::Integer;
    t0 = 500.0,
    low_temp = 20000,
    qv = 2.7,
    qa = -5.0,
    seed = nothing,
) where {T <: AbstractFloat}

    # Use a user defined seed
    if isnothing(seed)
        rng = Xorshifts.Xoroshiro128Plus()
    else
        rng = Xorshifts.Xoroshiro128Plus(seed)
    end

    # Create the solution with random initial values within the
    # search space bounds
    x_solution = a .+ rand(rng, T, dim) * (b - a)

    # We create a temporal array for copying values
    xtmp = similar(x_solution)

    t = t0

    for j = 1:low_temp
        # Determine the temperature for current iteration
        x = _general_temperature!(t, qv)

        # Create a neighbor solution
        _general_visit(x_solution, xtmp, x, qv, rng)

        # Employ the Metropolis-Hastings algorithm
        _general_annealing!(f, x, x_solution, xtmp, qa, rng)

        # Update the temperature with the generalized cooling schedule
        t *= x * t0
    end

    res = OptimizationResults(x_solution, f(x_solution), "GeneralizedSimulatedAnnealing", low_temp)

    return res
end  # function GeneralSimulatedAnnealing


function _general_visit(
    x::AbstractArray,
    xtmp::AbstractArray,
    τ::AbstractFloat,
    q::AbstractFloat,
    rng
)
"""
This is the algorithm from Tsallis & Stariolo to sample the distribution
shown in their paper, by approximating their probability distribution as a
Lévy probability distribution.
"""
    factor_1 = exp(log(τ) / (q - 1.0))
    factor_2 = exp((4.0 - q) * log(q - 1.0))
    factor_3 = exp((2.0 - q) * ln2 / (q - 1.0))
    factor_4 = (sqrtpi * factor_1 * factor_2) / (factor_3 * (3.0 - q))
    factor_5 = (1.0 / (q - 1.0)) - 0.5
    factor_6 = π * (1.0 - factor_5) / sin(π * (1.0 - factor_5)) / exp(_gammaln(2.0 - factor_5))
    sigmax = exp(-(q - 1.0) * log(factor_6 / factor_4)) / (3.0 - q)

    for i in eachindex(x)
        xx = sigmax .* randn(rng, Float64)
        y = randn(rng, Float64)
        den = exp((q - 1.0) * log(abs(y)) / (3.0 - q))
        @inbounds xtmp[i] = x[i] + (xx / den)
    end
end

function _general_annealing!(f::Function, t::AbstractFloat, x::AbstractArray, xtmp::AbstractArray, q::AbstractFloat, rng)

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
end  # function _general_annealing!

function _general_temperature!(x::AbstractFloat, q::AbstractFloat)
"""
A generalized cooling schedule that should work for every possible type
of Simulated Annealing implementation. When `q` = 1, this reduces to the
classical version.
"""
    # Avoid evaluating the logarithm at zero
    @assert x > -1.0

    factor_1 = 2^(q - 1.0) - 1.0
    factor_2 = (1.0 + x)^(q - 1.0) - 1.0

    return factor_1 / factor_2
end

function _gammaln(x::AbstractFloat)
"""
Compute the logarithm of the Gamma function as defined in the
3rd edition of Numerical Recipes in C.
"""
    @assert x > 0

    coeffs = @SVector [57.1562356658629235,-59.5979603554754912,
    14.1360979747417471,-0.491913816097620199,0.339946499848118887e-4,
    0.465236289270485756e-4,-0.983744753048795646e-4,0.158088703224912494e-3,
    -0.210264441724104883e-3,0.217439618115212643e-3,-0.164318106536763890e-3,
    0.844182239838527433e-4,-0.261908384015814087e-4,0.368991826595316234e-5]

    y = copy(x)
    xx = copy(x)

    tmp = xx + 5.2421875 # Rational 671/128
    tmp = (xx + 0.5) * log(tmp) - tmp

    ser = 0.999999999999997092

    for i in 1:14
        y += 1
        @inbounds ser += coeffs[i] / y
    end

    return tmp + log(2.5066282746310005 * ser / xx)
end  # function _gammaln
