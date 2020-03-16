@testset "Results" begin
    # Inline definition of the Sphere function
    f_sphere(x) = sum(x.^2)

    @testset "Benchmarks" begin
        total_iterations = 20000
        val = PSO(Easom(), Population(35, 2, -100.0, 100.0), total_iterations)
        ground_truth = @SVector [π, π]
        @test isapprox(val.x, ground_truth, atol = 1e-8)
        @test isapprox(val.min, -1.0)
        @test val.impl ≡ "PSO"
        @test val.iterations ≡ total_iterations
    end

    @testset "Functions" begin
        total_iterations = 20000
        val = PSO(f_sphere, Population(35, 3, -100.0, 100.0), total_iterations)
        @test isapprox(val.x, zeros(3), atol = 1e-15)
        @test isapprox(val.min, 0.0, atol = 1e-60)
        @test val.impl ≡ "PSO"
        @test val.iterations ≡ total_iterations
        optim_res = OptimizationResults(val.x,
                f_sphere(val.x),
                "PSO",
                val.iterations)
        @show optim_res
    end
end
