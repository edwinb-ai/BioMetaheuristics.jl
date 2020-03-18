@testset "SimulatedAnnealing" begin

    rosenbrock2d(x) =  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

    # * Single-run tests for user-defined functions
    @test begin
        dimension = 2
        ground_truth = 0.0
        val = SimulatedAnnealing(rosenbrock2d, -5.0, 5.0, dimension; low_temp = 5000)
        @show val
        isapprox(val.min, ground_truth, atol = 1e-2)
    end

    # * Single-run tests for benchmark functions
    @test begin
        dimension = 3
        ground_truth = 0.0
        val = SimulatedAnnealing(Rosenbrock(), -5.0, 5.0, dimension; low_temp = 10000)
        @show val
        isapprox(val.min, ground_truth, atol = 1e-2)
    end
end
