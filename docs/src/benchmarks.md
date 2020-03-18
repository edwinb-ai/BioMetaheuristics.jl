# Benchmark test functions

The following **benchmark functions** are implemented, each function is defined in the
survey[^1]:

## [`Sphere`](@ref)

The `Sphere` function is defined as:
```math
f(\mathbf{x}) = \sum_{i=1}^{d} x_i^2
```
with ``d`` the dimension of the _design_ vector ``\mathbf{x}``,
subject to ``0 \leq x_i \leq 10``.

- The **minimum** is
```math
f(\mathbf{x^*}) = 0, \quad \mathbf{x^*} = (0, \cdots, 0)
```

## [`Easom`](@ref)

The `Easom` function is defined as:
```math
f(\mathbf{x}) = -\cos{(x_1)} \cos{(x_2)} \exp{[-(x_1 - \pi)^2 - (x_2 - \pi)^2]}
```
where the _design_ vector is a 2-D vector only, subject to ``-100 \leq x_i \leq 100``.

- The function has the following **minimum**:
```math
f(\mathbf{x^*}) = -1, \quad \mathbf{x^*} = (\pi, \pi)
```

## [`Ackley`](@ref)

The `Ackley` function is defined as:
```math
f(\mathbf{x}) = -20 \exp{\left[ -0.02 \sqrt{\frac{1}{d}\sum_{i=1}^{d}{x_i^2}} \right]}
- \exp{\left[\frac{1}{d}\sum_{i=1}^{d}{\cos{(2 \pi x_i)}}\right]} + 20 + e
```
where the _design_ vector is a d-dimensional vector, subject to ``-35 \leq x_i \leq 35``.

- The function has the following **minimum**:
```math
f(\mathbf{x^*}) = 0, \quad \mathbf{x^*} = (0, \cdots, 0)
```

## [`Rosenbrock`](@ref)

The famous `Rosenbrock` function is defined as:
```math
f(\mathbf{x}) = \sum_{i=1}^{N-1} \left[100(x_{i-1}-x_i^2)^2 +(1-x_i)^2 \right]
```
where the _design_ vector is a N-dimensional vector, subject to ``-\infty \leq x_i \leq \infty``.

- The function has the following **minimum**:
```math
f(\mathbf{x^*}) = 0, \quad \mathbf{x^*} = (1, \cdots, 1)
```

### References

[^1]: Jamil, M., & Yang, X. S. (2013). A literature survey of benchmark functions for global optimisation problems. International Journal of Mathematical Modelling and Numerical Optimisation, 4(2), 150–194. https://doi.org/10.1504/IJMMNO.2013.055204