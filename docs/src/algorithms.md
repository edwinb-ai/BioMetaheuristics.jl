## Algorithms
 
The following **algorithms** are implemented:

- `Particle Swarm Optimization` [^1]
  This implementation is the modified Particle Swarm Optimization where it employs an inertia weight ``\omega``
  that controls convergence. This implementation uses _linear decay_ for the inertia weight, which lowers the value of 
  ``\omega`` until it reaches the default minimum of ``\omega = 0.4``.
  The **update rules** for the particles are the following:

  ```math
  x_{i+1} = x_i + v_{i+1} \\
  v_{i+1} = \omega v_i + \varphi_1 \beta_1 (p_i - x_i) + \varphi_2 \beta_2 (p_g - x_i)
  ```

  where ``\beta_1`` and ``\beta_2`` are uniformly distributed random numbers; ``\varphi_1`` and ``\varphi_2`` are the momentum coefficients;
  ``p_i`` is the previous individual best position and ``p_g`` is the privious global best position of the population.

### References

[^1]: Eberhart, R. C., & Shi, Y. (2000, July). Comparing inertia weights and constriction factors in particle swarm optimization. In Proceedings of the 2000 congress on evolutionary computation. CEC00 (Cat. No. 00TH8512) (Vol. 1, pp. 84-88). IEEE.