rng = MersenneTwister(912301)

@testset "API" begin
    # # * Single-run tests for TestFunctions, Easom
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
end
