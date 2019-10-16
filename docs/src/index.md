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

TODO:
- What are nature-inspired metaheuristics?
- Why are they needed?
- What does this package offer?
- Talk about EC Bestiary

## References
[^1]: Sörensen, K. (2015). Metaheuristics-the metaphor exposed. International Transactions in Operational Research, 22(1), 3–18. https://doi.org/10.1111/itor.12001