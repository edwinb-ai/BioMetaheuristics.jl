@testset "PSO" begin
    @test result = begin
        pops = Vector{Individual}(undef, 20)
        construct = Population(20, -10.0, 10.0)
        return pops ≡ construct
    end
end
