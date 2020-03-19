@doc raw"""
    Sphere

An unconstrained implementation of the Sphere function defined as:

```math
f(\mathbf{x}) = \sum_{i=1}^{d} x_i^2
```

where ``d`` is the dimension of the input vector ``\mathbf{x}``.
"""
struct Sphere <: Unconstrained end

_sphere(x) = sum(x.^2)

@doc raw"""
    Easom

An unconstrained implementation of the 2-dimensional
Easom function defined as:

```math
f(\mathbf{x}) = -\cos{(x_1)} \cos{(x_2)} \exp{[-(x_1 - \pi)^2 - (x_2 - \pi)^2]}
```

where ``x_1`` and ``x_2`` refer to the first and second element of the
input vector ``\mathbf{x}``.
"""
struct Easom <: Unconstrained end

@inline function _easom(x)
    @assert length(x) == 2 "This is a 2D function"

    term_1 = -cos(x[1]) * cos(x[2])
    term_2 = exp(-(x[1] - π)^2 - (x[2] - π)^2)

    return term_1 * term_2
end

@doc raw"""
    Ackley

An unconstrained implementation of the d-dimensional
Ackley function defined as:

```math
f(\mathbf{x}) = -20 e^{ -0.02 \sqrt{\frac{1}{d}\sum_{i=1}^{d}{x_i^2}}} - e^{\frac{1}{d}\sum_{i=1}^{d}{\cos{(2 \pi x_i)}}} + 20 + e
```

where ``d`` is the dimension of the input vector ``\mathbf{x}``.
"""
struct Ackley <: Unconstrained end

@inline function _ackley(x)
    dimension = length(x)
    @assert dimension > 0 "Must have positive dimension"

    term_1 = exp(-0.02 * sqrt(_sphere(x) / dimension))
    term_2 = exp(sum(cos.(2.0 * π * x)) / dimension)

    return -20.0 * term_1 - term_2 + 20.0 + exp(1.0)
end

@doc raw"""
    Rosenbrock

An unconstrained implementation of the d-dimensional
Rosenbrock function defined as:

```math
f(\mathbf{x}) = \sum_{i=1}^{N-1} \left[100(x_{i-1}-x_i^2)^2 +(1-x_i)^2 \right]
```

where ``N`` is the dimension of the input vector ``\mathbf{x}``.
"""
struct Rosenbrock <: Unconstrained end

@inline function _rosenbrock(x)
    dimension = length(x)
    @assert dimension >= 2 "Must be at least 2D"

    total = 0.0
    for i in 1:dimension - 1
        @inbounds total += 100.0 * (x[i + 1] - x[i]^2)^2 + (1.0 - x[i])^2
    end

    return total
end  # function _rosenbrock

struct GoldsteinPrice <: Unconstrained end

@inline function _goldprice(x)
    @assert length(x) == 2 "Exactly 2D"

    term_1 = (x[1] + x[2] + 1.0)^2
    term_1 *= 19.0 - 14.0 * x[1] + 3.0 * x[1]^2 - 14.0 * x[2] + 6.0 * x[1] * x[2] + 3.0 * x[2]^2
    term_1 += 1.0
    term_2 = (2.0 * x[1] - 3.0 * x[2])^2
    term_2 *= 18.0 - 32.0 * x[1] + 12.0 * x[1]^2 + 48.0 * x[2] - 36.0 * x[1] * x[2] + 27.0 * x[2]^2
    term_2 += 30.0

    return term_1 * term_2
end  # function _goldprice

# Build a dictionary of test functions and their implementations
test_functions = Dict([:Sphere => :_sphere, :Easom => :_easom, :Ackley => :_ackley,
:Rosenbrock => :_rosenbrock, :GoldsteinPrice => :_goldprice])

for (k, v) in test_functions
    # Create the methods for the given test functions
    @eval $k(x::T) where T = $v(x)
    # Create a special method for the `TestFunction` type
    @eval evaluate(b::$k, x::T) where T = $v(x)
end
