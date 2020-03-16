export Sphere, Easom, Ackley

@doc raw"""
    Sphere

An unconstrained implementation of the Sphere function defined as:

```math
f(\mathbf{x}) = \sum_{i=1}^{d} x_i^2
```

where ``d`` is the dimension of the input vector ``\mathbf{x}``.
"""
struct Sphere <: Unconstrained end

function _sphere(x)
    return sum(x.^2)
end

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

function _easom(x)
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

function _ackley(x)
    dimension = length(x)
    @assert dimension > 0 "Must have positive dimension"

    term_1 = exp(-0.02 * sqrt(_sphere(x) / dimension))
    term_2 = exp(sum(cos.(2.0 * π * x)) / dimension)

    return -20.0 * term_1 - term_2 + 20.0 + exp(1.0)
end
