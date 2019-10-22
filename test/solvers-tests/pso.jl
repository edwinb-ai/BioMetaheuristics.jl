@testset "PSO" begin

    f_sphere(x) = sum(x .^ 2)

    @test begin
        total_runs = 2
        val = PSO(Sphere(), Population(30, 30, -10.0, 10.0), 20000, total_runs)
        assert_results = []
        for i = 1:total_runs
            push!(assert_results, ≈(val[i], zeros(30), atol=1e-11))
        end
        if count(assert_results) >= 1
            true
        else
            println(count(assert_results))
            false
        end
    end

    @test begin
        total_runs = 2
        val = PSO(f_sphere, Population(30, 30, -10.0, 10.0), 20000, total_runs)
        assert_results = []
        for i = 1:total_runs
            push!(assert_results, ≈(val[i], zeros(30), atol=1e-11))
        end
        if count(assert_results) >= 1
            true
        else
            println(count(assert_results))
            false
        end
    end

    @test begin
        assert_results = []
        for k = 1:30
            val = PSO(Sphere(), Population(30, 30, -10.0, 10.0), 20000)
            push!(assert_results, ≈(val, zeros(30), atol=1e-11))
        end
        # if at least 50% of the time converges, the test passes
        if count(assert_results) >= 15
            true
        else
            println(count(assert_results))
            false
        end
    end

    @test begin
        assert_results = []
        for k = 1:50
            val = PSO(Easom(), Population(35, 2, -100.0, 100.0), 20000)
            design = [π, π]
            result = ≈(val, design, atol=1e-8)
            push!(assert_results, result)
        end
        # if at least 50% of the time converges, the test passes
        if count(assert_results) >= 25
            true
        else
            println(count(assert_results))
            false
        end
    end

    @test begin
        assert_results = []
        for k = 1:30
            val = PSO(f_sphere, Population(30, 30, -10.0, 10.0), 20000)
            push!(assert_results, ≈(val, zeros(30), atol=1e-11))
        end
        # if at least 50% of the time converges, the test passes
        if count(assert_results) >= 15
            true
        else
            println(count(assert_results))
            false
        end
    end
end
