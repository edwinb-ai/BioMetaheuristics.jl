```@meta
EditURL = "<unknown>/docs/src/examples/examples.jl"
```

# Examples

Before we start, I will define a seed to enable reproducibility of the
results presented here

```@example examples
RANDOM_SEED = 458012;
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

```@example examples
function griewank(x::AbstractArray)
    first_term = sum(x .^ 2) / 4000
    # This variable will hold the result of the product,
    # the second term in the function definition from above
    second_term = 1.0
    for (idx, val) in enumerate(x)
        second_term *= cos(val / sqrt(idx))
    end

    return first_term - second_term + 1.0
end
```

Now, we wish to find the minimum of this function, and fortunately we know the
true value so we can compare it later, we can use some of the implementations
from `Newtman.jl`, for example, [`PSO`](@ref).
In this script we have chosen 30 particles within the population, `d` is equal
to 20, next we define the boundaries and finally we declare that the algorithm
will run for 20000 maximum iterations until it stops, having _converged_.

```@example examples
using Newtman

val = PSO(
    griewank,
    Population(35, 10, -600.0, 600.0; seed = RANDOM_SEED),
    20000;
    seed = RANDOM_SEED
)
println(val)
```

Within a certain tolerance of about ``\epsilon = 1 \times 10^{-6}`` we have found
the _global_ minimum of the function. We can actually check the value with the
evaluation, notice that it actually returns `0`, as expected.

```@example examples
griewank(val.x)
```

## Nonlinear 2-dimensional global optimization problem

Let us now tackle one of the most common optimization problems, which is
finding the minimum of the [Rosenbrock function](https://en.wikipedia.org/wiki/Rosenbrock_function)
which is a non-convex function, meaning that is does not have just one minimum
or stationary point, it has several, so it is a difficult problem for classical
optimization algorithms. In this example we will try to solve it using the
[`SimulatedAnnealing`](@ref) implementation from `Newtman.jl`.

First, we define the Rosenbrock function in `Julia`

```@example examples
rosenbrock2d(x) =  (1.0 - x[1]) ^ 2 + 100.0 * (x[2] - x[1] ^ 2) ^ 2;
nothing #hide
```

We will apply the _Simulated Annealing_ algorithm to find the global optimum

```@example examples
val = SimulatedAnnealing(
    rosenbrock2d, -5.0, 5.0, 2; low_temp = 5000, seed = RANDOM_SEED
)
println(val)
```

Again, within a certain tolerance we find the expected result which is

```math
\mathbf{x}^{*} = (1, 1)
```

and if we account for rounding errors and floating-point arithmetic, we
can safely take this result as the best.

## Multiple runs to ensure statistical significance

Recall that most metaheuristics are actually stochastic optimization algorithms,
but most importantly they only _estimate_ or _approximate_ a solution.
These algorithms are not meant to be taken for _granted_, so multiple runs
with different seeds and starting points are very useful in order to obtain a
statistically meaningful result.

In this section we will implement a distributed solution in order to build
a confidence interval around the solution for the [McCormick function](https://www.sfu.ca/~ssurjano/mccorm.html).

First, we define the function

```@example examples
mcorm(x) = sin(x[1] + x[2]) + (x[1] + x[2]) ^ 2 - 1.5 * x[1] + 2.5 * x[2] + 1;
nothing #hide
```

Now, in order for us to use `Newtman.jl` in a parallel fashion we must
load it using the `Distributed` module from `Julia`

```@example examples
using Distributed
@everywhere using Pkg
@everywhere Pkg.activate("../../")
@everywhere Pkg.instantiate()
@everywhere using Newtman
```

Now we define a function where we can run multiple times the same algorithm,
and store its results. For simplicity, we will be using the [`GeneralizedSimulatedAnnealing`](@ref) implementation from `Newtman.jl`.

```@example examples
@everywhere function run_distributed()
    return nothing
end

run_distributed()
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*
