# [Algorithms](@id implementations-docs)

The following **algorithms** are implemented:

## Particle Swarm Optimization
This implementation is the modified Particle Swarm Optimization [^1] where it employs an inertia weight ``\omega``
that controls convergence. This implementation uses _linear decay_ for the inertia weight, which lowers the value of 
``\omega`` iteratively until it reaches the default minimum of ``\omega = 0.4``.

The **update rules** for the particles are the following:

```math
x_{i+1} = x_i + v_{i+1} \\
v_{i+1} = \omega v_i + \varphi_1 \beta_1 (p_i - x_i) + \varphi_2 \beta_2 (p_g - x_i) \\
\omega = \omega - \eta
```

where ``\beta_1`` and ``\beta_2`` are uniformly distributed random numbers; ``\varphi_1`` and ``\varphi_2`` are the momentum coefficients;
``p_i`` is the previous individual best position and ``p_g`` is the privious global best position of the population; finally
``\eta`` is the weight decay, currently implemented as

```math
\eta = \frac{(0.9 - 0.4)}{n}
```
where ``0.9`` is the original default value for ``\omega``, ``0.4`` is the default minimum as explained before and ``n`` is the
total number of iterations the algorithm is run. This guarantees that the weight decays linearly.

### References

[^1]: Eberhart, R. C., & Shi, Y. (2000, July). Comparing inertia weights and constriction factors in particle swarm optimization. In Proceedings of the 2000 congress on evolutionary computation. CEC00 (Cat. No. 00TH8512) (Vol. 1, pp. 84-88). IEEE.