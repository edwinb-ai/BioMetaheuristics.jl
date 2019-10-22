@testset "PSO" begin

    f_sphere(x) = sum(x .^ 2)

    @test let
        assert_results = []
        for k = 1:50
            val = PSO(Sphere(), Population(30, 30, -10.0, 10.0), 20000)
            push!(assert_results, ≈(val, zeros(30), atol=1e-11))
        end
        # if at least 90% of the time converges, the test passes
        # 50 * .90 = 45
        if count(assert_results) >= 45
            true
        else
            println(count(assert_results))
            false
        end
    end

    @test let
        assert_results = []
        for k = 1:50
            val = PSO(Easom(), Population(35, 2, -100.0, 100.0), 20000)
            design = [π, π]
            result = ≈(val, design, atol=1e-8)
            push!(assert_results, result)
        end
        # if at least 97/100 pass, the it has converged
        if count(assert_results) >= 48
            true
        else
            println(count(assert_results))
            false
        end
    end

    @test let
        assert_results = []
        for k = 1:50
            val = PSO(f_sphere, Population(30, 30, -10.0, 10.0), 20000)
            push!(assert_results, ≈(val, zeros(30), atol=1e-11))
        end
        # if at least 90% of the time converges, the test passes
        # 50 * .90 = 45
        if count(assert_results) >= 45
            true
        else
            println(count(assert_results))
            false
        end
    end
end
