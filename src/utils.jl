"""
    Apply boundary conditions to both position and velocity for
every `Particle` type object `P`. Instead of just returning the
upper and lower bound, we return a new value within the search
space.
"""
function _clip_positions_velocities!(P::Particle)
    # First the positions
    rand!(P.x, P.min_dim:P.max_dim)

    # Then the velocities
    rand!(P.v, P.min_dim:P.max_dim)
end # end _clip_positions_velocities!

"""
    Compute the logarithm of the Gamma function as defined in the
3rd edition of Numerical Recipes in C.
"""
function _gammaln(x)

    @assert x > 0

    coeffs = @SVector([
        57.1562356658629235,
        -59.5979603554754912,
        14.1360979747417471,
        -0.491913816097620199,
        0.339946499848118887e-4,
        0.465236289270485756e-4,
        -0.983744753048795646e-4,
        0.158088703224912494e-3,
        -0.210264441724104883e-3,
        0.217439618115212643e-3,
        -0.164318106536763890e-3,
        0.844182239838527433e-4,
        -0.261908384015814087e-4,
        0.368991826595316234e-5
    ])

    y = copy(x)
    xx = copy(x)

    tmp = xx + 5.2421875 # Rational 671/128
    tmp = (xx + 0.5) * log(tmp) - tmp

    ser = 0.999999999999997092

    @inbounds for i in 1:14
        y += 1
        ser += coeffs[i] / y
    end

    return tmp + log(2.5066282746310005 * ser / xx)
end  # function _gammaln
