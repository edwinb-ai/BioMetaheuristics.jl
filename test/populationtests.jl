@testset "Population" begin
    # Check that type and dimension are correct
    @test let
        pops = typeof(Population(20, -10.0, 10.0))
        actual_type = typeof(Vector{Particle}(undef, 20))
        pops ≡ actual_type
    end
end

@testset "Particle" begin
    @test_throws AssertionError Particle(zeros(3), zeros(2), zeros(1), 0.0, 0.0)
end
