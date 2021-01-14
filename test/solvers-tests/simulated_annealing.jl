rosenbrock2d(x) =  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
RANDOM_SEED = 809230
rng = MersenneTwister(RANDOM_SEED)

@testset "SimulatedAnnealing" begin

    # * Single-run tests for user-defined functions
    @test begin
        dimension = 2
        ground_truth = 0.0
        val = SimulatedAnnealing(
            rosenbrock2d, -5.0, 5.0, dimension, rng;
            low_temp=5000
        )
        @show val
        isapprox(val.min, ground_truth, atol=1e-2)
    end

    # * Single-run tests for benchmark functions
    @test begin
        dimension = 3
        ground_truth = 0.0
        val = SimulatedAnnealing(
            Rosenbrock(), -5.0, 5.0, dimension, rng;
            low_temp=20000
        )
        @show val
        isapprox(val.min, ground_truth, atol=1e-2)
    end

    # * Tests for random seeds
    @test begin
        dimension = 3
        ground_truth = 0.0
        val = SimulatedAnnealing(
            Rosenbrock(), -5.0, 5.0, dimension, rng;
            low_temp=20000
        )
        @show val
        isapprox(val.min, ground_truth, atol=1e-2)
    end
end

@testset "GeneralizedSimulatedAnnealing" begin
    # * Single-run tests for user-defined functions
    @test begin
        dimension = 2
        ground_truth = 0.0
        val = GeneralSimulatedAnnealing(
            rosenbrock2d, -5.0, 5.0, dimension, rng;
            low_temp=35000
        )
        @show val
        isapprox(val.min, ground_truth, atol=1e-2)
    end

    # * Single-run tests for different Tsallis' parameters
    @test begin
        dimension = 2
        ground_truth = 0.0
        val = GeneralSimulatedAnnealing(
            rosenbrock2d,
            -5.0,
            5.0,
            dimension,
            rng;
            low_temp=30000,
            qv=2.5,
            qa=1.0000001
        )
        @show val
        isapprox(val.min, ground_truth, atol=1e-2)
    end

    # * Single-run tests for benchmark functions
    @test begin
        dimension = 3
        ground_truth = 0.0
        val = GeneralSimulatedAnnealing(
            Ackley(),
            -3.0,
            3.0,
            dimension,
            rng;
            low_temp=10000
        )
        @show val
        isapprox(val.min, ground_truth, atol=1e-2)
    end

    # * Test for random seeds
    @test begin
        dimension = 3
        ground_truth = 0.0
        val = GeneralSimulatedAnnealing(
            Ackley(),
            -3.0,
            3.0,
            dimension,
            rng;
            low_temp=10000
        )
        @show val
        isapprox(val.min, ground_truth, atol=1e-2)
    end
end
