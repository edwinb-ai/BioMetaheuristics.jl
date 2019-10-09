export Sphere, Easom

struct Sphere <: Unconstrained end

function _sphere(x)
    return sum(x .^ 2)
end

struct Easom <: Unconstrained end

function _easom(x)
    @assert length(x) == 2 "This is a 2D function"

    term_1 = -cos.(x[1]) * cos.(x[2])
    term_2 = exp.(-(x[1] - π) .^ 2 - (x[2] - π) .^ 2)

    return term_1 * term_2
end
