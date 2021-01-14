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

## Simulated Annealing

### Classic version

This implementation [^2] uses the following logarithmic cooling schedule

```math
T_{new}(t) = T_0 \frac{\log{(2)}}{\log{1 + t}}
```

to obtain a new temperature each iteration, starting from an initial temperature ``T_0``.

This implementation searches possible candidate solutions by sampling from an approximate Boltzmann distribution,
drawn as a normal distribution like so

```math
g_{sol}(x) = \mathcal{N}(0, 1) * \sigma \\
x_{sol} = x_{prev} + g_{sol}(x)
```

where ``g_{sol}(x)`` is an array filled with random values sampled from an approximate normal standard distribution
with standard deviation ``\sigma = \sqrt{T_{new}(t)}`` which corresponds to the previously found
temperature. With this array, the new solution is computed as the previous (best) solution, ``x_{sol}``,
and adding the sampled array.

Finally, the Metropolis-Hastings algorithm is defined as

```math
P(x_{sol} \leftarrow x_{old}) = 1.0 \qquad f(x_{sol}) < f(x_{old}) \\
P(x_{sol} \leftarrow x_{old}) = e^{(\Delta / T_{new}(t))} \qquad f(x_{sol}) \geq f(x_{old})
```

where ``\Delta = f(x_{old}) - f(x_{sol})``.

### [Generalized version](@id generalized-sm)

This is the implementation developed by Tsallis & Stariolo [^2] following Tsallis' theory on
the generalization of the extensive entropy developed in Statistical Mechanics. This implementation
has as special cases the classic version described above and the *fast* version developed by
Szu & Hartley [^3].

This implementation is quite interesting as it uses the Tsallis entropy defined [^4] as

```math
S_q = k_B \frac{1-\sum_q p_i^q}{q_1}
```

where ``q`` is the so-called **Tsallis parameter**. By developing fundamental Statistical Mechanics
theory and combining it with Gibbs' ensemble theory (I'm skipping all the development, it's quite
extensive, pun intended), we arrive at a Metropolis-Hastings-like acceptance probability

```math
P_{q_a}(x_{sol} \leftarrow x_{old}) = 1 \qquad f(x_{sol}) < f(x_{old}) \\

P_{q_a}(x_{sol} \leftarrow x_{old}) = \frac{1}{[1+(q_a-1)\Delta / T_{new}(t)]^{(1/(q_a-1))}} \qquad f(x_{sol}) \geq f(x_{old})
```

there is a lot to unpack here, so we will go step by step.

Firstly, the **cooling schedule** is now defined as

```math
T_{q_v}^V (t) = \frac{2^{q_v-1}-1}{(1+t)^{q_v-1}-1}
```

```math
T_{new}(t) = T_0\ T_{q_v}^V (t)
```

where ``T_0`` is the initial temperature.

Then we have the neighbor sampling distribution defined as

```math
g_{q_v}(\Delta x) = \left(\frac{q_{v}-1}{\pi}\right)^{D/2}

\frac{\Gamma\left(\frac{1}{q_{v}-1}+\frac{D-1}{2}\right)}{\Gamma\left(\frac{1}{q_{v}-1}-\frac{1}{2}\right)}

\frac{[T_{q_v}^V (t)]^{-\frac{D}{3-q_v}}}{\left(1+(q_v-1)\frac{(\Delta x)^2}{[T_{q_v}^V (t)]^{\frac{2}{3-q_v}}}\right)^{\frac{1}{q_V+1}+\frac{D-1}{2}}} \\

\forall D, \forall q_V
```

where ``\Delta x = x_{sol} - x_{old}``, and ``\Gamma`` denotes the [Gamma function](https://mathworld.wolfram.com/GammaFunction.html). As you can see, this distribution is very complicated, but in the
original paper [^2] Tsallis & Stariolo provide an algorithm where they approximate this distribution
as a [Lévy distribution](https://en.wikipedia.org/wiki/L%C3%A9vy_distribution). This algorithm
is provided in the paper and it's the one used in this implementation.

With this, we update the neighbor solution as before ``x_{sol} = x_{old} + g_{q_v}(\Delta x)``
and then we employ the Metropolis-Hastings algorithm.

Lastly, an important case is when ``q_A < 0`` because the update rule is now undetermined, so we
employ the following update rule

```math
P_{q_a}(x_{sol} \leftarrow x_{old}) = 1 \qquad f(x_{sol}) < f(x_{old}) \\

P_{q_a}(x_{sol} \leftarrow x_{old}) = [1+(q_a-1)\Delta / T_{new}(t)]^{-1} \qquad f(x_{sol}) \geq f(x_{old})
```

which means that we always reject the solution ``x_{sol}`` whenever the proposition
``[1+(q_a-1)\Delta / T_{new}(t)] < 0`` is true.

## References

[^1]: Eberhart, R. C., & Shi, Y. (2000, July). Comparing inertia weights and constriction factors in particle swarm optimization. In Proceedings of the 2000 congress on evolutionary computation. CEC00 (Cat. No. 00TH8512) (Vol. 1, pp. 84-88). IEEE.

[^2]: C. Tsallis and D. A. Stariolo, “Generalized Simulated Annealing,” Physica A: Statistical Mechanics and its Applications, vol. 233, no. 1–2, pp. 395–406, Nov. 1996, doi: 10.1016/S0378-4371(96)00271-3.

[^3]: Szu, H., & Hartley, R. (1987). Fast simulated annealing. Physics letters A, 122(3-4), 157-162.

[^4]: C. Tsallis, “Possible generalization of Boltzmann-Gibbs statistics,” J Stat Phys, vol. 52, no. 1, pp. 479–487, Jul. 1988, doi: 10.1007/BF01016429.
