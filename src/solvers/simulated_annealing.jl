const ln2 = log(2.0)

struct SimulatedAnnealing <: Metaheuristic end

"""
    SimulatedAnnealing(f::Function, a::T, b::T, dim::Integer;
        t0 = 500.0, low_temp = 5000) where {T <: AbstractFloat} -> OptimizationResults

Implementation of the *classical* version of simulated annealing. This implementation uses a logarithmic cooling schedule and searches possible candidate solutions by sampling from an approximate Boltzmann distribution, modeled as a normal distribution.

Returns an `OptimizationResults` type with information relevant to the run executed, see [`OptimizationResults`](@ref).

# Arguments
- `f`: can be any `AbstractArray` that contains [`Particle`](@ref)
instances, but it is expected to be generated by [`Population`](@ref).
- `k_max`: number of maximum iterations until "convergence" of the algorithm.

# Keyword arguments
_It is recommended to use the default values provided._

- `w`: value that controls how much of the initial velocity is retained, i.e.
an inertia term. This values decays linearly over each iteration until it reaches
the default miminum value of 0.4.
- `c1`: balance between the influence of the individual's knowledge, i.e. the
best inidividual solution so far.
- `c2`: balance between the influence of the population's knowledge, i.e. the
best global solution so far.

# Examples
- For `Function`s
```julia
using Newtman

# Define the Sphere function
f_sphere(x) = sum(x .^ 2)

# Implement PSO for a 3-dimensional Sphere function, with
# 10000 iterations and 30 particles in the population.
val = PSO(f_sphere, Population(30, 3, -15.0, 15.0), 10000)
```
- For `TestFunctions`
```julia
using Newtman

# Implement PSO for a 3-dimensional Sphere function, with
# 10000 iterations and 25 particles in the population.
val = PSO(Sphere(), Population(25, 3, -15.0, 15.0), 10000)
```
"""
function SimulatedAnnealing(f::Function, a::T, b::T, dim::Integer; t0 = 500.0, low_temp = 5000) where {T <: AbstractFloat}

    rng = Xorshifts.Xorshift1024Star()

    x_solution = a .+ rand(rng, T, dim) * (b - a)
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
