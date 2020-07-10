# # Examples
#
# Using `Newtman.jl` is fairly straightforward, first you define your own 
# function to minimize, in this case we will use a popular function, the 
# [Griewank function](http://mathworld.wolfram.com/GriewankFunction.html) 
# defined as
#
# ```math
# f(\mathbf{x}) = \sum_{i=1}^d \frac{x_i^2}{4000} - \prod_{i=1}^d \cos{\left( 
# \frac{x_i}{\sqrt{i}}\right)} + 1
# ```
#
# where ``d`` is the dimension of the problem. It's mostly evaluated within the
# boundaries ``-100 \leq x_i \leq 100``, and it has a **minimum** at ``\mathbf
# {x^*} = (0, \cdots, 0)``, and it evaluates to ``f(\mathbf{x^*}) = 0``.
#
# We define the function in `Julia` like this