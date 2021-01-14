RANDOM_SEED = 809123
rng = MersenneTwister(RANDOM_SEED)

@testset "Particle" begin
    @test_throws AssertionError Particle(zeros(3), zeros(2), zeros(1), 0.0, 1.0)

    # * Test type promotion
    @test let
        p = Particle(15, 20.0, 10, rng)
        eltype(p.x) ≡ eltype(p.v)
    end
end

@testset "Population" begin
    @test let
        pops = typeof(Population(15, 20, -10.0, 10.0, rng))
        actual_type = typeof(Vector{Particle}(undef, 15))
        pops ≡ actual_type
    end

    # * Test random seeds
    @test let
        pops = typeof(Population(15, 20, -10.0, 10.0, rng))
        actual_type = typeof(Vector{Particle}(undef, 15))
        pops ≡ actual_type
    end

    # * Test multiple ranges
    @test let
        range_a = SVector(-10.0, 10.0)
        range_b = SVector(-2.5, 2.0)
        pops = Population(20, [range_a, range_b], rng)
        type_pops = typeof(pops)
        actual_type = typeof(Vector{Particle}(undef, 2))
        type_pops ≡ actual_type
    end
    @test_throws AssertionError Population(15, -1, 1.0, 1.0, rng)
    @test_throws AssertionError Population(0, 5, 1.0, 1.0, rng)
    @test_throws AssertionError Population(-1, 5, 1.0, 1.0, rng)

    @test let
        range_a = SVector(-10.0, 10.0)
        range_b = SVector(-2.5, 2.0)
        pops = Population(20, [range_a, range_b], rng)
        type_pops = typeof(pops)
        actual_type = typeof(Vector{Particle}(undef, 2))
        type_pops ≡ actual_type
    end
end
