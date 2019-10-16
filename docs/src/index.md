# Newtman.jl

This is `Newtman.jl`, an stochastic optimization package that implements
a number of metaheuristic algorithms, mostly nature-inspired and bio-inspired.

## On Metaheuristics

The term _metaheuristic_ has a some history behind it, and a large span of definitions
within the scientific community. In `Newtman.jl`, _metaheuristic_ is defined as follows

>A _metaheuristic_ is a **black box** optimization framework that employs
>heuristics to find a close-to optimal solution for a given optimization
>problem.

The definition is important in this context. `Newtman.jl` strives on implementations of
already existent algorithms, but actually the term itself has not yet been acquired a formal
definition, as Sörensen[^1] says in his paper.

Because `Newtman.jl` employs _metaheuristics_ as actual _black box optimization_ frameworks,
this definition should be enough to provide the actual purpose of the package.

## Nature and bio-inspired algorithms

_Heuristic_ is a term for a simple rule. Given a rule, mainly provided by experience, one
can create a process or _algorithm_ to solve a given problem.

Nature is an unlimited source of experience that can provide a lot of _heuristics_ for us, if
one looks closely.

Recent research has taken this approach[^2] and scientists have taken inspiration from nature
to create _heuristics_ for problem solving. Examples are Ant Colony Optimization[^3], based on the
foraging behavior of ant colonies, Particle Swarm Optimization[^4], which draws inspiration in the
so-called _swarm intelligence_ of birds, people, and so on.

With this mindset, the field of _stochastic optimization_ witnessed an avalanche of "novel" algorithms
all based on nature, which were called **nature-inspired metaheuristics**.

If one takes not only nature, but physics, chemistry and biology, one can create the so-called
**bio-inspired metaheuristics**, based on ideas drawn from biological, chemical and physical processes.

## The need for `Newtman.jl` and nature-inspired algorithms

Most _metaheuristic_ algorithms are _not_ very difficult to implement, and most of the time there
is already a package for it (e.g. [NiaPy](https://github.com/NiaOrg/NiaPy) for Python).

In general, these algorithms are not consistently used because there are more robust and exact algorithms out there,
such as the classics BFGS, L-BFGS, Gradient Descent and many more.

Nonetheless, there are several areas in optimization that need quick and approximate solutions, mostly because they
are unsolvable in finite time[^1]. Because of this, nature and bio-inspired algorithms rose to the top in some of these
problems and were the _only_ framework that could give a reasonable solution.

When there is not much information about the problem (i.e. the derivative or gradient of the fitness function),
or if the classic algorithms take too much time to converge, nature and bio-inspired algorithms tackle these types of
problems with randomness and _heuristics_, and having found a close-to optimal solution, more robust algorithms can be
applied to the given problem. [^5]

### About using `Julia`

In scientific computing, the [Julia programming language](https://julialang.org) has been an excellent tool to get rid of the
two language problem, i.e. when there is a need for high perfomance calculations but with low level manipulation, problems
can be harder to code and even harder to solve.
`Julia` is a great candidate to solve this problem, and this package attempts to prove that by providing high perfomant code and
implementations.

## Contents of `Newtman.jl`

The following **algorithms** are implemented:

- Particle Swarm Optimization [^4]

Also, the following **benchmark functions** are implemented:

- [`Sphere`](@ref)
- [`Easom`](@ref)

## The Evolutionary Computation Bestiary

There is a _hidden_ goal for `Newtman.jl` and that is to implement _all_ of the algorithms proposed in the
[EC Bestiary](https://github.com/fcampelo/EC-Bestiary)[^6], which is a compilation of most of the nature and bio-inspired algorithms
in the literature.

### On the name of the package

Because of this _hidden_ goal, the name `Newtman` was chosen, which is a [pormanteau](https://www.merriam-webster.com/dictionary/portmanteau)
of the character by J.K. Rowling, **Newt**on Sca**man**der, whose purpose in life is to collect samples of _fantastic beasts_ and create
a book or log of their nature.

## References
[^1]: Sörensen, K. (2015). Metaheuristics-the metaphor exposed. International Transactions in Operational Research, 22(1), 3–18. https://doi.org/10.1111/itor.12001

[^2]: Kar, A. K. (2016). Bio inspired computing - A review of algorithms and scope of applications. Expert Systems with Applications, 59, 20–32. https://doi.org/10.1016/j.eswa.2016.04.018

[^3]: Dorigo, M., & Di Caro, G. (1999, July). Ant colony optimization: a new meta-heuristic. In Proceedings of the 1999 congress on evolutionary computation-CEC99 (Cat. No. 99TH8406) (Vol. 2, pp. 1470-1477). IEEE.

[^4]: Eberhart, R., & Kennedy, J. (1995, November). Particle swarm optimization. In Proceedings of the IEEE international conference on neural networks (Vol. 4, pp. 1942-1948).

[^5]: Luke, S. (2011). Essentials of metaheuristics. In Genetic Programming and Evolvable Machines (Vol. 12). https://doi.org/10.1007/s10710-011-9139-0

[^6]: Felipe Campelo, & Claus Aranha. (2018, June 20). EC Bestiary: A bestiary of evolutionary, swarm and other metaphor-based algorithms (Version v2.0.1). Zenodo. http://doi.org/10.5281/zenodo.1293352