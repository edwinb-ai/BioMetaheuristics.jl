# A primer on numerical optimization

**Optimization** is a huge subject, and I don't think Newton even realized this when discovering Calculus, where optimization has its roots. Basically, in optimization we are trying to find **the best** possible solution to a given problem. Worded in this way it seems that optimization is actually everywhere we look around, which is so very true, optimization is everywhere!

Say you like to run, and you look at your milage, timings and so on; you start to wonder, what _is the best_ way to **improve** my timings? How can I **maximize** it?

Now imagine that you have some money to spare and you wish to invest it. What type of investment will return the **largest** profit and will also **minimize** the possible risk of losing money?

_Optimization_ has been a major subject within _analysis_, the major branch of mathematics where most of its arguments come from. In mathematical language, we define an **optimization problem** as follows

```math
\text{minimize} f(\mathbf{x}), \quad \mathbf{x} \in \mathbb{R} \\
\text{subject to } h(\mathbf{x}) = 0, \\
\text{and }g(\mathbf{x}) \leq 0 .
```

`h` and `g` are referred to as **constraint functions**, and the full expressions with their equalities and inequalities are simply called **constraints**. When we have a problem like this, we call this a **constrained optimization problem**.

On the other hand, if we only define the problem as

```math
\text{minimize} f(\mathbf{x}),\quad \mathbf{x} \in \mathbb{R}
```

we are talking about an **unconstrained optimization problem**.

The goal of optimization is to find the _vector_ $\mathbf{x}$ that gives the **lowest** possible value for `f` given all the constraints, if any. The classic way to achieve this is by using _derivatives_ and _derivative tests_, and throughout the years mathematicians have developed very rigorous and robust algorithms to find these values. Almost every procedure uses _derivatives_ because Newton and Gauss taught us that these _converge_ faster and more precisely to the true values. But recently, _stochastic optimization_ algorithms, were randomness is used to guide the search for the best value, have been very popular and widely used within the scientific community.

This is a very, very small space to talk about optimization, but the following references should get you started right away. [^1], [^2] and [^3].

# On Convergence

**Convergence** is a very strong word in mathematics, and it actually has lots of definitions depending on the specific branch of mathametics it is used. Here we shall use the _numerical analysis_ definition, which is simply stated as a limit. We wish to obtain a value, whatever it is, in a finite time.

We may employ _tolerance_ values where we argue that a given solution is **close to** the real value that I know of. We can see this in the example above, where we know that the true value is a _vector_ filled with zeros, but we don't actually obtain zeros, instead we get _close_ values to zeros within a certain _tolerance_: in this scenario we can say that the optimization algorithm **has converged**.

If, on the other hand, we rely on the number of **maximum iterations** then we can safely claim that when the algorithm has run for the number of _maximum iterations_ then it has converged. Is that so? At least, in the realm of [approximation algorithms](https://en.wikipedia.org/wiki/Approximation_algorithm) we can safely claim that this is true.

But don't take my word for it, in reality this is a very serious mathematical topic and should not be taken so slightly. Actually, every algorithm ever implemented must have a **convergence analysis** carried out for it, to ensure that either it will stop at some time or that it will given the desired result.

# The basics of nature and bio-inspired metaheuristics

**Nature and bio-inspired metaheuristics** work by means of two fundamental _heuristics_: **exploration** and **exploitation**.

First, **exploration** is leveraged through the use of _random numbers_, these are created to try to cover most of the _search space_, i.e. the set of possible values that can be considered the solution to a given optimization problem. When _exploring_ the _search space_, metaheuristics try to search as efficiently as possible, and most algorithms use _uniform sampling_ to try and cover most, if not all, of the search space.

Once the _search space_ has been explored, the algorithm tries to identify, by means of some update rule, which of these proposed solutions are actually valid. In _swarm intelligence_ algorithms such as [`Particle Swarm Optimization`](@ref implementations-docs) the different particles are ranked and checked against each other to see which has the most promising value. Then, **exploitation** kicks in, trying to take advantage of this information and trying to pull most of the swarm towards it.

In the topic of optimization algorithms, _nature and bio-inspired metaheuristics_ have a special place when talking about _convergence_, _stability_, and _significance._

First, _convergence_ is usually measured as described in the section above, by means of a _tolerance_ or a _maximum number_ of iterations.

_Stability_ is a harder topic in this matter, because of the random aspect of most, if not all, of the current popular _nature and bio-inspired metaheuristics._ Reproduciblity is a big factor, and almost always algorithms need to be run independently _at least_ 30 different times, with 30 statistically independent random number generators. But even this won't guarantee that every single run will give a good solution to the problem.

At last, _statistical significance_ is almost mandatory if one wants to have a solution that has an actual mathematical and statistical _meaning._ Because of randomness, the actual mechanism by which _nature and bio-inspired metaheuristics_ are Markov Chains [^4] which provide statistical tools to guarantee and promise that the values found are, indeed, the real ones. _Hypothesis tests_ like the parametric _t-test_, the _Mann-Whitney-Wilcoxon_ non-parametric test, and some others are the most popular statistical tests to prove _significance_ of the values obtained from applying _nature and bio-inspired metaheuristics._

## References

[^4]: Yang, X.-S. (2014). Nature-inspired optimization algorithms. In Elsevier Insights. <https://doi.org/10.1007/978-981-10-6689-4_8>

[^1]: https://en.wikipedia.org/wiki/Mathematical_optimization#History
[^2]: https://web.stanford.edu/group/sisl/k12/optimization/MO-unit1-pdfs/1.1optimization.pdf
[^3]: https://sites.math.northwestern.edu/~clark/publications/opti.pdf
