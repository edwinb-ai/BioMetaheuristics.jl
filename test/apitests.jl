rng = MersenneTwister(912301)

@testset "API" begin
    # * Single-run tests for TestFunctions, Easom
    @test begin
        assert_results = []
        ground_truth = @SVector [π, π]
        for k = 1:10
            val = optimize(Easom(), zeros(2), [-100.0, 100], PSO(); rng=rng)
            result = isapprox(val.x, ground_truth)
            push!(assert_results, result)
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end

    # * Change the keyword arguments
    @test begin
        assert_results = []
        ground_truth = @SVector [π, π]
        args = Dict(:w => 0.8, :c1 => 1.5, :c2 => 1.0)
        for k = 1:10
            val = optimize(Easom(), zeros(2), [-100.0, 100], PSO(); rng=rng, args...)
            result = isapprox(val.x, ground_truth)
            push!(assert_results, result)
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end

    # * Test random RNG
    @test begin
        assert_results = []
        ground_truth = @SVector [π, π]
        for k = 1:10
            val = optimize(Easom(), zeros(2), [-100.0, 100], PSO(); iters=15_000)
            result = isapprox(val.x, ground_truth)
            push!(assert_results, result)
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end

    # * Test fixed RNG, SimulatedAnnealing
    @test begin
        assert_results = []
        ground_truth = 0.0
        for k = 1:10
            val = optimize(Rosenbrock(), zeros(2), [-5.0, 5.0], SimulatedAnnealing();
                rng=rng, iters=20_000)
            result = isapprox(val.min, ground_truth, atol=1e-2)
            push!(assert_results, result)
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end

    # * Test fixed RNG, GeneralSimulatedAnnealing
    @test begin
        assert_results = []
        ground_truth = 0.0
        for k = 1:10
            val = optimize(
                Rosenbrock(),
                zeros(2),
                [-5.0, 5.0],
                GeneralSimulatedAnnealing();
                rng=rng,
                iters=20_000
            )
            result = isapprox(val.min, ground_truth, atol=1e-2)
            push!(assert_results, result)
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end

    # * Test randomly seeded RNG, SimulatedAnnealing
    @test begin
        assert_results = []
        ground_truth = 0.0
        for k = 1:10
            val = optimize(Rosenbrock(), zeros(2), [-5.0, 5.0], SimulatedAnnealing();
                iters=20_000)
            result = isapprox(val.min, ground_truth, atol=1e-2)
            push!(assert_results, result)
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end

    # * Test randomly seeded RNG, GeneralSimulatedAnnealing
    @test begin
        assert_results = []
        ground_truth = 0.0
        for k = 1:10
            val = optimize(
                Rosenbrock(),
                zeros(2),
                [-5.0, 5.0],
                GeneralSimulatedAnnealing();
                iters=20_000
            )
            result = isapprox(val.min, ground_truth, atol=1e-2)
            push!(assert_results, result)
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end
end
