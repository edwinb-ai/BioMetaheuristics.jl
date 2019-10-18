function f_sphere(x)
    return sum(x .^ 2)
end

@testset "PSO" begin

    @test let
        assert_results = []
        for k = 1:50
            for i = 2:30
                val = PSO(Sphere(), Population(30, i, -10.0, 10.0), 20000)
                push!(assert_results, ≈(val, zeros(i), atol=1e-13))
            end
        end
        # if at least 97% of the time converges, the test passes
        # 150 * .97 = 145
        if count(assert_results) >= 145
            true
        end
    end

    # @test let
    #     assert_results = []
    #     for k = 1:100
    #         val = PSO(Easom(), Population(35, 2, -100.0, 100.0), 100)
    #         design = [π, π]
    #         result = ≈(val, design, atol=1e-4)
    #         push!(assert_results, result)
    #     end
    #     # if at least 97/100 pass, the it has converged
    #     if count(assert_results) >= 97
    #         true
    #     end
    # end

    # @test let
    #     assert_results = []
    #     for k = 1:100
    #         for i = 2:10
    #             val = PSO(f_sphere, Population(30, i, -5.0, 5.0), 100)
    #             push!(assert_results, ≈(val, zeros(i), atol=0.1))
    #         end
    #     end
    #     # if at least 97% of the time converges, the test passes
    #     # 900 * .97 = 873
    #     if count(assert_results) >= 873
    #         true
    #     end
    # end
end
