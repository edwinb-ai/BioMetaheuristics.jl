# Newtman.jl

This is `Newtman.jl`, an stochastic optimization package that implements
a number of metaheuristic algorithms, mostly nature-inspired and bio-inspired.

## On Metaheuristics

The term _metaheuristic_ has a large history, and a very large span of definitions
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
to create _heuristics_ for problem solving. Example are Ant Colony Optimization[^3], based on the
foraging behavior of ant colonies, Particle Swarm Optimization[^4], which draws inspiration in the
so-called _swarm intelligence_ of birds, people, and so on.

With this mindset, the field of _stochastic optimization_ witnessed an avalanche of "novel" algorithms
all based on nature, which were called **nature-inspired metaheuristics**.

If one takes not only nature, but physics, chemisty and biology, one can create the so-called
**bio-inspired metaheuristics**, based on ideas drawn from biological, chemical and physical processes.

TODO:
- Why are they needed?
- What does this package offer?
- Talk about EC Bestiary

## References
[^1]: Sörensen, K. (2015). Metaheuristics-the metaphor exposed. International Transactions in Operational Research, 22(1), 3–18. https://doi.org/10.1111/itor.12001

[^2]: Kar, A. K. (2016). Bio inspired computing - A review of algorithms and scope of applications. Expert Systems with Applications, 59, 20–32. https://doi.org/10.1016/j.eswa.2016.04.018

[^3]: Dorigo, M., & Di Caro, G. (1999, July). Ant colony optimization: a new meta-heuristic. In Proceedings of the 1999 congress on evolutionary computation-CEC99 (Cat. No. 99TH8406) (Vol. 2, pp. 1470-1477). IEEE.

[^4]: Eberhart, R., & Kennedy, J. (1995, November). Particle swarm optimization. In Proceedings of the IEEE international conference on neural networks (Vol. 4, pp. 1942-1948).