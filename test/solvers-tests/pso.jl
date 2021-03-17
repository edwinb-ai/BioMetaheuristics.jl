@testset "PSO" begin

    RANDOM_SEED = 909231
    rng = MersenneTwister(RANDOM_SEED)

    f_sphere(x) = sum(x.^2)

    # * Single-run tests for TestFunctions, Easom
    @test begin
        assert_results = []
        ground_truth = @SVector [π, π]
        for k = 1:10
            val = PSO(
                Easom(),
                Population(35, 2, -100.0, 100.0, rng),
                5_000,
                rng
            )
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

    # * Single-run tests for user-defined functions
    @test begin
        assert_results = []
        ground_truth = zeros(30)
        for k = 1:10
            val = PSO(
                f_sphere,
                Population(35, 30, -10.0, 10.0, rng),
                15_000,
                rng
            )
            push!(assert_results, isapprox(val.x, ground_truth, atol=1e-8))
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end

    # * Check that kwargs are handled correctly
    @test begin
        ground_truth = zeros(30)
        val = PSO(
            f_sphere,
            Population(35, 30, -10.0, 10.0, rng),
            15_000,
            rng;
            c1=1.0,
            c2=0.5
        )

        isapprox(val.x, ground_truth, atol=1e-8)
    end
end
