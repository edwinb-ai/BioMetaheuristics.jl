# # Parallel evaluation and simple statistics
#
# In this example we will be looking at a way to evaluate several times a given problem
# by exploiting a distributed computing strategy known as **embarrasingly parallel**
# execution.
#
# The idea is very simple: compute the same problem several times, in parallel, and
# collect the results at the end.
# This should work well with metaheuristics due to the following properties:
#
# - Metaheuristics are _self-contained,_ meaning that they possess their own RNG and their own search space.
# - Due to the fact that solutions are searched with a random component, independent runs should be able to give independent results.
#
# With this in mind, we can use the fantastic parallel capabilities of `Julia` and
# show how easy it is to obtain some simple, but meaningful statistics for a given
# optimization problem.
#
# With this we want to also show that this is the **right way** to use this package.
# We should _always_ run several independent solvers to obtain good statistics.
# We must **never** settle with just one run from the solver.
#
# ## Setting up
#
# In order to use the multithreading capabilities of `Julia`, we need to launch the
# REPL using all the threads we can afford.
#
# For instance, the computer where this example is currently being executed has
# 8 physical cores, so I should launch my `Julia` REPL
# like so
#
# ```shell
# JULIA_NUM_THREADS=8 julia
# ```
#
# This will launch the REPL with 8 cores ready to be used. We can check this by entering
# the following in the REPL,
#
# ```julia
# julia> using Base.Threads
# julia> nthreads()
# ```
#
# making sure that this matches the same number introduced with the variable
# `JULIA_NUM_THREADS`.
#
# You should replace the number of threads, in this case 8, with the number of threads
# that you wish.
#
# ## Set up
#
# First, let us import all the necessary modules we will need for this example.

using Newtman
using Newtman.TestFunctions
using Base.Threads
using Statistics
using BenchmarkTools

# Now, let us create some setup functions.
# First, we will be using the `optimize` interface to solve the [`Levy`](@ref)
# optimization problem. This function just
# wraps the `optimize` function and returns the solution vector from the problem.
#
# We will be using Particle Swarm Optimization (PSO), with 20,000 iterations.
# It is very important to note that no specific RNG is being used.
# This tells the `optimize` function to always use a new, truly randomly seeded RNG.

function solve_problem(dim)
    val = optimize(Levy(), zeros(dim), [-35.0, 35.0], PSO(); iters=20_000)

    return val.x
end;

# ### Some benchmarks
#
# Before we continue, I would like to show a benchmark of the PSO implementation.
# We will use the fantastic [`BenchmarkTools.jl`](https://github.com/JuliaCI/BenchmarkTools.jl)
# to check the time it takes to finish a single optimization problem.
#
# Here, we will solve a 50-dimensional Levy optimization problem. We are not really
# interested if the solution is accurate, just the timing. We will deal with accuracy
# in the next subsection.

b = @benchmark solve_problem(50);
b

# Not bad at all. If it takes between 3-4 seconds to finish I think this is fairly
# good.
# Furthermore, it means that we can take advantage of how little it takes to run
# in order to really push the number of solvers to execute.
#
# ## Parallel evaluation
#
# We now turn to the main event. We will launch several solvers using the previously
# created wrapper function in parallel. First off, we need another function to do so.
#
# This function will use the `@threads` macro that enables a for-loop to run in parallel.
# The function has a matrix called `solutions` where we will be storing the solution
# vectors from each independent run.
#
# We will call the solver in parallel and each time we will save the solutions vector.
# We will then compute the mean, median and standard deviation from all the independent
# runs and report that as the _true_ value, and compare it to the _ground truth._

function parallel_compute(;dim=50, total_iterations=50)
    solutions = Matrix{Float64}(undef, dim, total_iterations)

    @threads for i in 1:total_iterations
        solutions[:, i] = solve_problem(dim)
    end

    mean_result = mean(solutions; dims=2)
    median_result = median(solutions; dims=2)
    std_result = std(solutions; dims=2)

    return (mean_result, median_result, std_result)
end;

# We are ready to go. We will do 200 iterations in order to have good statistics.
#
# !!! warning
#     Depending on your hardware this might take a long time. If that is the case
#     stop the process and reduce the number of iterations.
#
# !!! note
#     Every time you do this exercise, new results will appear. This is normal for
#     metaheuristics, and it is desired. We don't want reproducibility here, we aim
#     for _statistical significance._

μ, med, σ = parallel_compute(;total_iterations=200);

# We can now check the results

# Here is the mean value

μ

# Here is the median obtained

med

# And finally, the standard deviation of the solution

σ

# Let us print the evaluation of the function on these results.
# First, the mean value.

println(evaluate(Levy(), μ))

# Then, the median obtained.

println(evaluate(Levy(), med))

# ## Conclusions
#
# Recall that for the Levy function the solution is
#
# ```math
# \mathbf{x^*} = (1, \dots, 1)
# ```
#
# and it should evaluate to
#
# ```math
# f(\mathbf{x^*}) = 0
# ```
#
# It it safe to say that we have obtained those results, but we are _statistically sure_
# that these results are the _true_ results, because we have several independent runs
# for the answer.
#
# ### On the use of the median
#
# Notice that most of the time, the median result actually performs better than the mean
# result.
# This is somewhat expected, as the median is not really affected by poorly performant runs.
# Sometimes, independent runs will not give good results and when taken into account,
# the mean value will suffer greatly from this.
# The median, however, as a measure of the "value in the middle", will not be so affected
# and a better estimation is expected.
#
# We should always report both results, and conclude that whenever the final function
# evaluation is approximately the same with both the mean and the median, the
# solution is statistically acceptable for that particular problem.
#
