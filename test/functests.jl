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
    @test Easom((π, π)) ≈ -1.0 # Check for minimum
    @test isa(evaluate(Easom(), [2.0, 4.0]), Number)
end

@testset "Ackley" begin
    @test_throws AssertionError Ackley([])
    @test isapprox(Ackley(zeros(5)), 0.0, atol = 1e-15) # Check for minimum
    @test isa(evaluate(Ackley(), [2.0, 4.0]), Number)
end
