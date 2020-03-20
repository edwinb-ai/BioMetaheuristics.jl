@testset "Sphere" begin
    # Simple constructor calls
    @test Sphere(zeros(4)) ≈ 0.0 # This is the minimum
    @test Sphere(ones(4)) ≈ 4.0
    @test Sphere(0.0) ≈ 0.0
    @test Sphere(5.0) ≈ 25.0
    # Using multiple dispatch
    @test isa(evaluate(Sphere(), 0.0), Number)
end

@testset "Easom" begin
    @test_throws AssertionError Easom(zeros(4))
    @test Easom(fill(3.0, 2)) ≈ -0.94156415
    minimum_val = @SVector [π, π]
    @test Easom(minimum_val) ≈ -1.0 # Check for minimum
    @test isa(evaluate(Easom(), [2.0, 4.0]), Number)
end

@testset "Ackley" begin
    @test_throws AssertionError Ackley([])
    @test isapprox(Ackley(zeros(5)), 0.0, atol = 1e-15) # Check for minimum
    @test isa(evaluate(Ackley(), [2.0, 4.0]), Number)
end

@testset "Rosenbrock" begin
    @test_throws AssertionError Rosenbrock(zeros(1))
    @test isapprox(Rosenbrock(fill(1.0, 4)), 0.0, atol = 1e-15) # Check for minimum
end

@testset "GoldsteinPrice" begin
    ground_truth = 3.0
    true_vector = @SVector [0.0, -1.0]
    @test_throws AssertionError GoldsteinPrice(zeros(3))
    # Check for minimum
    @test isapprox(GoldsteinPrice(true_vector), ground_truth, atol = 1e-15)
end

@testset "Beale" begin
    ground_truth = 0
    true_vector = @SVector [3, 0.5]
    @test_throws AssertionError Beale(zeros(3))
    # Check for minimum
    @test isapprox(Beale(true_vector), ground_truth, atol = 1e-15)
end

@testset "Levy" begin
    ground_truth = 0
    dimension = 10
    true_vector = fill(1.0, dimension)
    # Check for minimum
    @test isapprox(Levy(true_vector), ground_truth, atol = 1e-15)
end
