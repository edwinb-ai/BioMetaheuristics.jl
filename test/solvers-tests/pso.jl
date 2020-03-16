@testset "PSO" begin

    f_sphere(x) = sum(x.^2)

    # * Single-run tests for TestFunctions, Sphere
    @test begin
        assert_results = []
        for k = 1:10
            val = PSO(Sphere(), Population(30, 30, -10.0, 10.0), 20000)
            push!(assert_results, ≈(val.x, zeros(30), atol = 1e-11))
        end
        # if at least 80% of the time converges, the test passes
        if count(assert_results) >= 8
            true
        else
            println(count(assert_results))
            false
        end
    end
    # * Single-run tests for TestFunctions, Easom
    @test begin
        assert_results = []
        for k = 1:10
            val = PSO(Easom(), Population(35, 2, -100.0, 100.0), 20000)
            design = [π, π]
            result = ≈(val.x, design, atol = 1e-8)
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
        for k = 1:10
            val = PSO(f_sphere, Population(30, 30, -10.0, 10.0), 20000)
            push!(assert_results, ≈(val.x, zeros(30), atol = 1e-11))
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
