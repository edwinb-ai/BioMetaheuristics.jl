# Benchmark test functions

The following **benchmark functions** are implemented in the submodule `BioMetaheuristics.TestFunctions`.
Each function is defined in the survey by Jamil and Yang[^1].
We explain them in detail here for quick reference purposes. No other information more than
the solutions to each of the optimization problems is provided.

The purpose of these functions is to check the **validity** of the implementations in this
package. By solving these benchmark optimization problems we can trust that the implemenations
are correct and that they will give reasonable results in other similar problems.
It is expected that _virtually all_ implementations can solve these functions, or at least
a considerable subset of these.

The previous point is very important. Due to the No Free Lunch theorem[^2] and its extension
to metaheuristics[^3], no single optimization algorithm is better than another for a set
of optimization problems. This is a very important result, and one of the main reasons why
most of the time some algorithms tend to perform better than other for a given optimization
problem.

## [`Sphere`](@ref)

The `Sphere` function is defined as:

```math
f(\mathbf{x}) = \sum_{i=1}^{d} x_i^2
```

with ``d`` the dimension of the _design_ vector ``\mathbf{x}``,
normally evaluated within the bounds ``0 \leq x_i \leq 10``.

!!! solution
    ```math
    f(\mathbf{x^*}) = 0, \quad \mathbf{x^*} = (0, \cdots, 0)
    ```

## [`Easom`](@ref)

The `Easom` function is defined as:

```math
f(\mathbf{x}) = -\cos{(x_1)} \cos{(x_2)} \exp{[-(x_1 - \pi)^2 - (x_2 - \pi)^2]}
```

where the _design_ vector is a 2-D vector only.
It is normally evaluated within the range ``-100 \leq x_i \leq 100``.

!!! solution
    ```math
    f(\mathbf{x^*}) = -1, \quad \mathbf{x^*} = (\pi, \pi)
    ```

## [`Ackley`](@ref)

The `Ackley` function is defined as:

```math
f(\mathbf{x}) = -20 \exp{\left[ -0.02 \sqrt{\frac{1}{d}\sum_{i=1}^{d}{x_i^2}} \right]}
- \exp{\left[\frac{1}{d}\sum_{i=1}^{d}{\cos{(2 \pi x_i)}}\right]} + 20 + e
```

where the _design_ vector is a d-dimensional vector.
Normally evaluated within the range ``-35 \leq x_i \leq 35``.

!!! solution
    ```math
    f(\mathbf{x^*}) = 0, \quad \mathbf{x^*} = (0, \cdots, 0)
    ```

## [`Rosenbrock`](@ref)

The famous `Rosenbrock` function is defined as:

```math
f(\mathbf{x}) = \sum_{i=1}^{N-1} \left[100(x_{i-1}-x_i^2)^2 +(1-x_i)^2 \right]
```

where the _design_ vector is a N-dimensional vector.
The search space range is normally ``-\infty \leq x_i \leq \infty``.

!!! solution
    ```math
    f(\mathbf{x^*}) = 0, \quad \mathbf{x^*} = (1, \cdots, 1)
    ```

## [`GoldsteinPrice`](@ref)

The `Goldstein-Price` function is defined as:

```math
f(x,y)=[1 + (x + y + 1)^2(19 − 14x+3x^2− 14y + 6xy + 3y^2)] \times \\
[30 + (2x − 3y)^2(18 − 32x + 12x^2 + 4y − 36xy + 27y^2)]
```

where ``x`` and ``y`` are the elements of a ``2D`` _design_ vector.

!!! solution
    ```math
    f(\mathbf{x^*}) = 3, \quad \mathbf{x^*} = (0, -1)
    ```

## [`Beale`](@ref)

The `Beale` function is defined as:

```math
f(x, y) = (1.5-x+xy)^2+(2.25-x+xy^2)^2+(2.625-x+xy^3)^2
```

where ``x`` and ``y`` are the elements of a ``2D`` _design_ vector.

!!! solution
    ```math
    f(\mathbf{x^*}) = 0, \quad \mathbf{x^*} = (3, 0.5)
    ```

## [`Levy`](@ref)

The `Lévy` function is defined as:

```math
f(\mathbf{x}) = \sin^{2}{\pi w_1} + \sum_{i=1}^{d-1} (w_i-1)^2 [1+10\sin^{2}{\pi w_1 + 1}]
+ (w_d-1)^2 [1+\sin^{2}{2\pi w_d}]
```

where

```math
w_i = 1 + \frac{x_i-1}{4}
```

and ``d`` is the dimension of the vector.

!!! solution
    ```math
    f(\mathbf{x^*}) = 0, \quad \mathbf{x^*} = (1, \dots, 1)
    ```

## References

[^1]: Jamil, M., & Yang, X. S. (2013). A literature survey of benchmark functions for global optimisation problems. International Journal of Mathematical Modelling and Numerical Optimisation, 4(2), 150–194. https://doi.org/10.1504/IJMMNO.2013.055204
[^2]: Wolpert, D. H. and Macready, W. G. (1997) ‘No free lunch theorems for optimization’, IEEE Transactions on Evolutionary Computation, 1(1), pp. 67–82. doi: 10.1109/4235.585893.
[^3]: Joyce, T. and Herrmann, J. M. (2018) ‘A Review of No Free Lunch Theorems, and Their Implications for Metaheuristic Optimisation’, in Yang, X.-S. (ed.) Nature-Inspired Algorithms and Applied Optimization. Cham: Springer International Publishing (Studies in Computational Intelligence), pp. 27–51. doi: 10.1007/978-3-319-67669-2_2.
