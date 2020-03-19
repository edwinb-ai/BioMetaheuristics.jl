import Newtman.TestFunctions: Benchmark, evaluate

const ln2 = log(2.0)

struct SimulatedAnnealing <: Metaheuristic end

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
function SimulatedAnnealing(f::Benchmark, a::T, b::T, dim::Integer;
    t0 = 500.0, low_temp = 5000) where {T <: AbstractFloat}
    return SimulatedAnnealing(x->evaluate(f, x), a, b, dim;
        t0 = t0, low_temp = low_temp)
end

"""
    SimulatedAnnealing(f::Function, a::T, b::T, dim::Integer;
        t0 = 500.0, low_temp = 5000) where {T <: AbstractFloat} -> OptimizationResults

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
function SimulatedAnnealing(f::Function, a::T, b::T, dim::Integer;
    t0 = 500.0, low_temp = 5000) where {T <: AbstractFloat}

    rng = Xorshifts.Xorshift1024Star()

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

@doc raw"""
This scheme approximates a Boltzmann distribution

```math
p_i = \frac{e^{-\varepsilon_i/kT}}{\sum_j e^{-\varepsilon_j/kT}
```
where ``k`` is the Boltzmann constant, ``T`` is the temperature, and
``\varepsilon`` is the energy at *state* ``i``.

The approximation is done by means of a standard normal distribution like so

```math
p_i \sym \mathcal{N}(0, \sqrt{T})
```
"""
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
