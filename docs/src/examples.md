```@meta
EditURL = "<unknown>/docs/src/examples/examples.jl"
```

# Implementations and proof of concept

In this examples I want to show some of the implementations and how they are used
as a proof of concept. This means that we will use the "low-level API", i.e. calling
the methods directly instead of the `optimize` interface.

Further, we wish to show that the implementations can at least solve some of the
most common benchmark optimization problems.

Before we start, I will define a seed and an RNG to enable reproducibility of the
results presented here.

```julia
using Random

RANDOM_SEED = 458012;
rng = MersenneTwister(RANDOM_SEED);
nothing #hide
```

## Nonlinear ``d``-dimensional global optimization problem

Using `Newtman.jl` is fairly straightforward, we will start by defining
an d-dimensional nonlinear function to minimize,
in this case we will use a popular function, the
[Griewank function](http://mathworld.wolfram.com/GriewankFunction.html)
defined as

```math
f(\mathbf{x}) = \sum_{i=1}^d \frac{x_i^2}{4000} - \prod_{i=1}^d \cos{\left(
\frac{x_i}{\sqrt{i}}\right)} + 1
```

where ``d`` is the dimension of the problem. It's mostly evaluated within the
boundaries ``-100 \leq x_i \leq 100``, and it has a **minimum** at ``\mathbf
{x^*} = (0, \cdots, 0)``, and it evaluates to ``f(\mathbf{x^*}) = 0``.

We define the function in `Julia` like this

```julia
function griewank(x)
    first_term = sum(x.^2) / 4000
    # This variable will hold the result of the product,
    # the second term in the function definition from above
    second_term = 1.0
    for (idx, val) in enumerate(x)
        second_term *= cos(val / sqrt(idx))
    end

    return first_term - second_term + 1.0
end
```

```
griewank (generic function with 1 method)
```

Now, we wish to find the minimum of this function, and fortunately we know the
true value so we can compare it later, we can use some of the implementations
from `Newtman.jl`, for example, [`PSO`](@ref).
In this script we have chosen 30 particles within the population, `d` is equal
to 20, next we define the boundaries and finally we declare that the algorithm
will run for 20000 maximum iterations until it stops, having _converged_.

```julia
using Newtman

val = PSO(
    griewank,
    Population(35, 10, -600.0, 600.0, rng),
    20_000,
    rng
)
println(val)
```

```
Results from Optimization
	Algorithm: PSO
	Solution: [-1.2951243253091765e-6, 4.103266843628412e-6, -1.9912163226147196e-6, 4.4936413741072556e-6, 2.813628268436206e-6, 1.1256507815651895e-5, 9.97929061647118e-7, -3.0759921634749986e-6, 2.394042272909523e-6, -5.820201386836871e-6]
	Minimum: 0.0000
	Maximum iterations: 20000


```

Within a certain tolerance of about ``\epsilon = 1 \times 10^{-6}`` we have found
the _global_ minimum of the function. We can actually check the value with the
evaluation, notice that it actually returns `0`, as expected.

```julia
griewank(val.x)
```

```
2.2315038705755796e-11
```

## Nonlinear 2-dimensional global optimization problem

Let us now tackle one of the most common optimization problems, which is
finding the minimum of the [Rosenbrock function](https://en.wikipedia.org/wiki/Rosenbrock_function)
which is a non-convex function, meaning that is does not have just one minimum
or stationary point, it has several, so it is a difficult problem for classical
optimization algorithms. In this example we will try to solve it using the
[`SimulatedAnnealing`](@ref) implementation from `Newtman.jl`.

First, we define the Rosenbrock function in `Julia`

```julia
rosenbrock2d(x) =  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2;
nothing #hide
```

We will apply the _Simulated Annealing_ algorithm to find the global optimum

```julia
val = SimulatedAnnealing(
    rosenbrock2d, -5.0, 5.0, 2, rng; low_temp=10_000
)
println(val)
```

```
Results from Optimization
	Algorithm: SimulatedAnnealing
	Solution: [1.028674409182762, 1.0597525306225808]
	Minimum: 0.0011
	Maximum iterations: 10000


```

Again, within a certain tolerance we find the expected result which is

```math
\mathbf{x}^{*} = (1, 1)
```

and if we account for rounding errors and floating-point arithmetic, we
can safely take this result as the best.

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

