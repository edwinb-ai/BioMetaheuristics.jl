@testset "PSO" begin
    @test let
        assert_results = []
        for i = 2:10
            val = PSO(Sphere(), Population(25, i, -5.0, 5.0), 80;
                w=0.5, c1=0.25, c2=1.5)
            push!(assert_results, ≈(val, zeros(i), atol=1e-1))
        end
        all(assert_results)
    end
end
