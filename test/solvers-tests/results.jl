@testset "Results" begin
    # Inline definition of the Sphere function
    f_sphere(x) = sum(x.^2)

    RANDOM_SEED = 6918234
    rng = MersenneTwister(RANDOM_SEED)

    @testset "Benchmarks" begin
        total_iterations = 20000
        val = PSO(
            Easom(),
            Population(35, 2, -100.0, 100.0, rng),
            total_iterations,
            rng
        )
        ground_truth = @SVector [π, π]
        @test isapprox(val.x, ground_truth, atol = 1e-8)
        @test isapprox(val.min, -1.0)
        @test val.impl ≡ "PSO"
        @test val.iterations ≡ total_iterations
    end

    @testset "Functions" begin
        total_iterations = 20000
        val = PSO(
            f_sphere,
            Population(35, 3, -100.0, 100.0, rng),
            total_iterations,
            rng
        )
        @test isapprox(val.x, zeros(3), atol=eps())
        @test isapprox(val.min, 0.0, atol=eps())
        @test val.impl ≡ "PSO"
        @test val.iterations ≡ total_iterations
        optim_res = OptimizationResults(val.x,
                f_sphere(val.x),
                "PSO",
                val.iterations)
        @show optim_res
    end
end
