## Reach

This package should/could be used by:

- **Practitioners**: people in need of a _black box optimization_ framework
  for when they know very little about the problem at hand.
- **Students**: wanting to learn about nature-inspired algorithms, stochastic optimization
  or want a general survey of the current literature.
- **Researchers**: who want to employ different algorithms at once, test them or use them
  as comparison for their own developed algorithms.

## Examples

Using `Newtman.jl` is fairly straightforward, first you define your own
function to minimize, in this case we will use a popular function, the
[Griewank function](http://mathworld.wolfram.com/GriewankFunction.html)
defined as

```math
f(\mathbf{x}) = \sum_{i=1}^d \frac{x_i^2}{4000} - \prod_{i=1}^d \cos{\left( \frac{x_i}{\sqrt{i}}\right)} + 1
```
where ``d`` is the dimension of the problem. It's mostly evaluated within the boundaries
``-100 \leq x_i \leq 100``, and it has a **minimum** at ``\mathbf{x^*} = (0, \cdots, 0)``, and it evaluates to
``f(\mathbf{x^*}) = 0``.

We define the function in `Julia` like this
```julia
function griewank(x)
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

Now, we wish to find the minimum of this function, and fortunately we know the true value so we can compare it later,
we can use some of the implementations from `Newtman.jl`, for example, [`PSO`](@ref):
```julia
using Newtman

val = PSO(griewank, Population(30, 20, -100.0, 100.0), 20000)
println("The minimum is located at: $val")
evaluation = griewank(val)
println("The minimum found is: $evaluation")
```

In this script we have chosen 30 particles within the population, ``d`` is equal to 20,
next we define the boundaries and finally we declare that the algorithm will run for
20000 maximum iterations until it stops, having _converged_.

When run, the above script will output something similar, but **not equal** to the following
```julia
The minimum is located at: [-4.917577504199913e-9,
-6.330030904044292e-9,
1.3873059483127891e-8,
1.990010126964934e-10,
-7.557797889209866e-9,
1.419769038062995e-8,
2.496436871899069e-8,
8.804753850761231e-9,
-1.8548632048540488e-8,
-2.7123021782721856e-8,
1.8334065350891433e-8,
-2.9056057778454154e-9,
1.6970421809599717e-8,
2.4908425003071914e-8,
-2.6288593326664073e-9,
3.191274332613467e-8,
-2.745352987902211e-8,
-3.1305326101664176e-8,
-1.805272411452161e-8,
4.5660334299426855e-10]
The minimum found is: 0.0
```

Within a certain tolerance of about ``\epsilon`` = 1e-8 we have found the _true_ minimum of the function. We can actually check
the value with the evaluation, notice that it actually returns ``0``, as expected.



TODO
- Basic optimization theory
- basics of metaheuristics
- Convergence