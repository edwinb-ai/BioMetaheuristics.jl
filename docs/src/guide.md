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

## A primer on numerical optimization

**Optimization** is a huge subject, and I don't think Newton even realized this when discovering Calculus, where optimization
has its roots. Basically, in optimization we are trying to find **the best** possible solution to a given problem. Worded in this way
it seems that optimization is actually everywhere we look around, which is so very true, optimization is everywhere!

Say you like to run, and you look at your milage, timings and so on; you start to wonder, what _is the best_ way to **improve** my
timings? How can I **maximize** it?

Now imagine that you have some money to spare and you wish to invest it. What type of investment will return the **largest** profit
and will also **minimize** the possible risk of losing money?

_Optimization_ has been a major subject within _analysis_, the major branch of mathematics where most of its arguments come from.
In mathematical language, we define an **optimization problem** like follows
```math
\text{minimize} f(\mathbf{x}), \mathbf{x} \in \mathbb{R} \\
\text{subject to} h(\mathbf{x}) = 0, \\
g(\mathbf{x}) \leq 0 .
```
``h`` and ``g`` are referred to as **constraint functions**, and the full expressions with their equalities and inequalities
are simply called **constraints**. When we have a problem like this, we call this a **constrained optimization problem**.

On the other hand, if we only define the problem as
```math
\text{minimize} f(\mathbf{x}), \mathbf{x} \in \mathbb{R}
```
we are talking about an **unconstrained optimization problem**.

The goal of optimization is to find the _vector_ ``\mathbf{x}`` that gives the **lowest** possible value for ``f`` given
all the constraints, if any. The classic ways to achieve this are by using _derivatives_ and _derivative tests_, and throughout
the years mathematicians have developed very rigorous and robust algorithms to find these values. Almost every procedure uses
_derivatives_ because Newton and Gauss taught us that these _converge_ faster and more precisely to the true values. But recently, _stochastic optimization_ algorithms, were randomness is used to guide the search for the best value, have been very popular and widely used within the scientific community.

This is a very, very small space to talk about optimization, but the following references should get you started right away.
[^1], [^2] and [^3].

## On Convergence

**Convergence** is a very strong word in mathematics, and it actually has lots of definitions depending on the specific branch of mathametics
it is used. Here we shall use the _numerical analysis_ definition, which is simply stated as a limit. We wish to obtain a value, whatever it is,
in a finite time.

We may employ _tolerance_ values where we argue that a given solution is **close to** the real value that I know of. We can see this in the example
above, where we know that the true value is a _vector_ filled with zeros, but we don't actually obtain zeros, instead we get _close_ values to zeros
within a certain _tolerance_: in this scenario we can say that the optimization algorithm **has converged**.

If, on the other hand, we rely on the number of **maximum iterations** then we can safely claim that when the algorithm has run
for the number of _maximum iterations_ then it has converged. Is that so? At least, in the realm of [approximation algorithms](https://en.wikipedia.org/wiki/Approximation_algorithm)
we can safely claim that this is true.

But don't take my word for it, in reality this is a very serious mathematical topic and should not be taken so slightly. Actually, every algorithm
ever implemented must have a **convergence analysis** carried out for it, to ensure that either it will stop at some time or that it will
given the desired result.

### References
[^1]: https://en.wikipedia.org/wiki/Mathematical_optimization#History
[^2]: https://web.stanford.edu/group/sisl/k12/optimization/MO-unit1-pdfs/1.1optimization.pdf
[^3]: https://sites.math.northwestern.edu/~clark/publications/opti.pdf

TODO
- basics of metaheuristics