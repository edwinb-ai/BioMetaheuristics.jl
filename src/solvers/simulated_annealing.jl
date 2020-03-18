const ln2 = log(2.0)

struct SimulatedAnnealing <: Metaheuristic end

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
