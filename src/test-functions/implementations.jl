export Sphere, Easom

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

    term_1 = -cos.(x[1]) * cos.(x[2])
    term_2 = exp.(-(x[1] - π).^2 - (x[2] - π).^2)

    return term_1 * term_2
end

@doc raw"""
    Ackely

An unconstrained implementation of the d-dimensional
Ackely function defined as:

```math
f(\mathbf{x}) = 
```

where ``x_1`` and ``x_2`` refer to the first and second element of the
input vector ``\mathbf{x}``.
"""
struct Ackely <: Unconstrained end

# function _ackley(x)

#     term_1 = -cos.(x[1]) * cos.(x[2])
#     term_2 = exp.(-(x[1] - π).^2 - (x[2] - π).^2)

#     return term_1 * term_2
# end