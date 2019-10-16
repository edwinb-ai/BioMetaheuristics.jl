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

$$ f(\mathcal{x}) = \sum_{i=1}^{d} x_i^2 $$

where $d \in \mathbb{R}$ is the dimension of the problem.
```julia
using Newtman

sphere(x) = sum( x .^ 2)

# Choose d = 10 in this case
PSO(sphere, Population(30, 10, -5.0, 5.0), 100;
    w=0.5, c1=0.25, c2=1.5)
```

The output is just the minima found (note that this is just a single run, and because of randomness
this **will** change every time):
```julia
[0.0005382790884110001,
-0.0006403872223652838,
 0.0017884733637705066,
 0.0003215948050234845,
-0.00015816973315573588,
 0.0006939763675548503,
-0.0012632337893056552,
-0.0003439393687106131,
-0.0013398480490333878,
 1.0513231280505062e-5]
```
which is reasonably the _true global minima_ within a certain tolerance.