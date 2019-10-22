@testset "Results" begin
    @test begin
        val = PSO(Easom(), Population(35, 2, -100.0, 100.0), 20000)
        println(val.x)
        true
    end
end
