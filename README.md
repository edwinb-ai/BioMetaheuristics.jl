# Newtman.jl

Nature-inspired and bio-inspired algorithms for unconstrained optimization.

| Style | Documentation| Build Status | Coverage |
| :-----: | :------------: | :------------: | :--------: |
| [![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)|[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://edwinb-ai.github.io/Newtman.jl/dev)|[![Build Status](https://travis-ci.org/edwinb-ai/Newtman.jl.svg?branch=master)](https://travis-ci.org/edwinb-ai/Newtman.jl)|[![Codecov](https://codecov.io/gh/edwinb-ai/Newtman.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/edwinb-ai/Newtman.jl)|
| | |[![Build Status](https://ci.appveyor.com/api/projects/status/github/edwinb-ai/Newtman.jl?svg=true)](https://ci.appveyor.com/project/edwinb-ai/Newtman-jl)|[![Coverage Status](https://coveralls.io/repos/github/edwinb-ai/Newtman.jl/badge.svg?branch=master)](https://coveralls.io/github/edwinb-ai/Newtman.jl?branch=master)|

## Demo

This is an example of using [Particle Swarm Optimization](https://en.wikipedia.org/wiki/Particle_swarm_optimization)
to solve an unconstrained problem, namely, the [Sphere function](https://www.sfu.ca/~ssurjano/spheref.html) defined
as

> <a href="https://www.codecogs.com/eqnedit.php?latex=\large&space;f(\mathbf{x})&space;=&space;\sum_{i=1}^{d}&space;x_i^2" target="_blank"><img src="https://latex.codecogs.com/png.latex?\large&space;f(\mathbf{x})&space;=&space;\sum_{i=1}^{d}&space;x_i^2" title="\large f(\mathbf{x}) = \sum_{i=1}^{d} x_i^2" /></a>

where `d` is any integer, i.e. the dimension of the problem.
```julia
using Newtman

sphere(x) = sum( x .^ 2)

# Choose d = 10 in this case
PSO(sphere, Population(30, 10, -5.0, 5.0), 10000)
```

The output is just the minima found (note that this is just a single run, and because of randomness
this **will** change every time):
```julia
[1.4133633848603616e-8,
 5.269529873035152e-8,
-6.817589802491161e-8,
 8.439376030727941e-8,
 1.6808091823666365e-8,
 2.1992538496794947e-8,
-1.435877272853963e-7,
 2.6145972639285076e-9,
 2.1692613064163623e-9,
-9.597041588846402e-9]
```
which is reasonably the _true global minima_, within a certain tolerance.

## Installation

`Newtman.jl` is _not_ in the official Registry yet; instead, you can install by one of the following
```julia
using Pkg

Pkg.add("https://github.com/edwinb-ai/Newtman.jl.git")
```

or in the Julia REPL
```julia
julia>]     # Type ] to enter Pkg

pkg> add https://github.com/edwinb-ai/Newtman.jl.git
```