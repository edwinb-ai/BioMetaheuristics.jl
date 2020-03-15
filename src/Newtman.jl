module Newtman

using RandomNumbers.Xorshifts
using RandomNumbers.PCG
using Base.Threads
using Statistics
using Base.Printf

include("test-functions/functions.jl")
include("population/types.jl")
include("solvers/solvers.jl")

end
