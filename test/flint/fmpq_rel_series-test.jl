@testset "QQRelPowerSeriesRingElem.conformance_tests" begin
  R, x = power_series_ring(QQ, 30, "x")
  ConformanceTests.test_Ring_interface(R)
end

@testset "QQRelPowerSeriesRingElem.types" begin
  @test rel_series_type(QQFieldElem) == QQRelPowerSeriesRingElem
end

@testset "QQRelPowerSeriesRingElem.constructors" begin
  S1 = RelPowerSeriesRing(QQ, 30)
  S2 = RelPowerSeriesRing(QQ, 30)

  @test isa(S1, QQRelPowerSeriesRing)
  @test S1 !== S2

  R, x = power_series_ring(QQ, 30, "x")

  @test elem_type(R) == QQRelPowerSeriesRingElem
  @test elem_type(QQRelPowerSeriesRing) == QQRelPowerSeriesRingElem
  @test parent_type(QQRelPowerSeriesRingElem) == QQRelPowerSeriesRing

  @test isa(R, QQRelPowerSeriesRing)

  a = x^3 + 2x + 1
  b = x^2 + 3x + O(x^4)

  @test isa(R(a), SeriesElem)

  @test isa(R([ZZRingElem(1), ZZRingElem(2), QQFieldElem(3)], 3, 5, 0), SeriesElem)

  @test isa(R([ZZRingElem(1), 2, 3], 3, 3, 0), SeriesElem)

  @test isa(R([BigInt(1), 2, 3], 3, 3, 0), SeriesElem)

  @test isa(R([1//1, 2, 3], 3, 3, 0), SeriesElem)

  @test isa(R([BigInt(1)//1, 2, 3], 3, 3, 0), SeriesElem)

  @test isa(R(1), SeriesElem)

  @test isa(R(ZZRingElem(2)), SeriesElem)

  @test isa(R(BigInt(2)), SeriesElem)

  @test isa(R(QQFieldElem(2)), SeriesElem)

  @test isa(R(2//1), SeriesElem)

  @test isa(R(BigInt(2)//1), SeriesElem)

  @test isa(R(), SeriesElem)
end

@testset "QQRelPowerSeriesRingElem.printing" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = x^3 + 2x + 1

  @test sprint(show, "text/plain", a) == "1 + 2*x + x^3 + O(x^30)"
end

@testset "QQRelPowerSeriesRingElem.manipulation" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^4)

  @test is_gen(gen(R))

  @test iszero(zero(R))

  @test isone(one(R))

  @test is_unit(-1 + x + 2x^2)

  @test valuation(a) == 1

  @test valuation(b) == 4

  @test characteristic(R) == 0
end

@testset "QQRelPowerSeriesRingElem.similar" begin
  R, x = power_series_ring(QQ, 10, "x")
  S, y = power_series_ring(ZZ, 10, "y")

  for iters = 1:10
    f = rand(R, 0:10, -10:10)
    fz = rand(S, 0:10, -10:10)

    g = similar(fz, QQ, "y")
    h = similar(f, "y")
    k = similar(f)
    m = similar(fz, QQ, 5)
    n = similar(f, 5)

    @test isa(g, QQRelPowerSeriesRingElem)
    @test isa(h, QQRelPowerSeriesRingElem)
    @test isa(k, QQRelPowerSeriesRingElem)
    @test isa(m, QQRelPowerSeriesRingElem)
    @test isa(n, QQRelPowerSeriesRingElem)

    @test parent(g).S == :y
    @test parent(h).S == :y

    @test iszero(g)
    @test iszero(h)
    @test iszero(k)
    @test iszero(m)
    @test iszero(n)

    @test parent(g) !== parent(f)
    @test parent(h) !== parent(f)
    @test parent(k) === parent(f)
    @test parent(m) !== parent(f)
    @test parent(n) !== parent(f)

    p = similar(f, cached=false)
    q = similar(f, "z", cached=false)
    r = similar(f, "z", cached=false)
    s = similar(f)
    t = similar(f)

    @test parent(p) === parent(f)
    @test parent(q) !== parent(r)
    @test parent(s) === parent(t)
  end
end

@testset "QQRelPowerSeriesRingElem.rel_series" begin
  f = rel_series(QQ, [1, 2, 3], 3, 5, 2, "y")

  @test isa(f, QQRelPowerSeriesRingElem)
  @test base_ring(f) === QQ
  @test coeff(f, 2) == 1
  @test coeff(f, 4) == 3
  @test parent(f).S == :y

  g = rel_series(QQ, [1, 2, 3], 3, 7, 4)

  @test isa(g, QQRelPowerSeriesRingElem)
  @test base_ring(g) === QQ
  @test coeff(g, 4) == 1
  @test coeff(g, 6) == 3
  @test parent(g).S == :x

  h = rel_series(QQ, [1, 2, 3], 2, 7, 1)
  k = rel_series(QQ, [1, 2, 3], 1, 6, 0, cached=false)
  m = rel_series(QQ, [1, 2, 3], 3, 9, 5, cached=false)

  @test parent(h) === parent(g)
  @test parent(k) !== parent(m)

  p = rel_series(QQ, QQFieldElem[], 0, 3, 1)
  q = rel_series(QQ, [], 0, 3, 2)

  @test isa(p, QQRelPowerSeriesRingElem)
  @test isa(q, QQRelPowerSeriesRingElem)

  @test pol_length(p) == 0
  @test pol_length(q) == 0

  r = rel_series(QQ, ZZRingElem[1, 2, 3], 3, 11, 8)

  @test isa(r, QQRelPowerSeriesRingElem)

  s = rel_series(QQ, [1, 2, 3], 3, 5, 0; max_precision=10)

  @test max_precision(parent(s)) == 10
end

@testset "QQRelPowerSeriesRingElem.unary_ops" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = 1 + 2x + x^2 + O(x^3)

  @test -a == -2x - x^3

  @test -b == -1 - 2x - x^2 + O(x^3)
end

@testset "QQRelPowerSeriesRingElem.binary_ops" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^4)
  c = 1 + x + 3x^2 + O(x^5)
  d = x^2 + 3x^3 - x^4

  @test a + b == x^3+2*x+O(x^4)

  @test a - c == x^3-3*x^2+x-1+O(x^5)

  @test b*c == O(x^4)

  @test a*c == 3*x^5+x^4+7*x^3+2*x^2+2*x+O(x^6)

  @test a*d == -x^7+3*x^6-x^5+6*x^4+2*x^3

  f1 = 1 + x + x^2 + x^3
  f2 = x + x^2
  f3 = x + x^2 + x^3
  f4 = x^2 + x^3 + x^4 + x^5

  @test f1 + f1 == 2+2*x+2*x^2+2*x^3+O(x^30)

  @test f1 + f2 == 1+2*x+2*x^2+x^3+O(x^30)
  @test f2 + f1 == f1 + f2

  @test f1 + f3 == 1+2*x+2*x^2+2*x^3+O(x^30)
  @test f3 + f1 == f1 + f3

  @test f1 + f4 == 1+x+2*x^2+2*x^3+x^4+x^5+O(x^30)
  @test f4 + f1 == f1 + f4

  @test f1 - f1 == 0+O(x^30)

  @test f1 - f2 == 1+x^3+O(x^30)

  @test f1 - f3 == 1+O(x^30)

  @test f1 - f4 == 1+x-x^4-x^5+O(x^30)

  g1 = x^2*f1
  g2 = x^2*f2
  g3 = x^2*f3
  g4 = x^2*f4

  @test g1 + g1 == 2*x^2+2*x^3+2*x^4+2*x^5+O(x^32)

  @test g1 + g2 == x^2+2*x^3+2*x^4+x^5+O(x^32)
  @test g2 + g1 == g1 + g2

  @test g1 + g3 == x^2+2*x^3+2*x^4+2*x^5+O(x^32)
  @test g3 + g1 == g1 + g3

  @test g1 + g4 == x^2+x^3+2*x^4+2*x^5+x^6+x^7+O(x^32)
  @test g4 + g1 == g1 + g4

  @test g1 - g1 == 0+O(x^32)

  @test g1 - g2 == x^2+x^5+O(x^32)
  @test g2 - g1 == -(g1 - g2)

  @test g1 - g3 == x^2+O(x^32)
  @test g3 - g1 == -(g1 - g3)

  @test g1 - g4 == x^2+x^3-x^6-x^7+O(x^32)
  @test g4 - g1 == -(g1 - g4)

  h1 = f1
  h2 = -f2
  h3 = -f3
  h4 = -f4

  @test h1 + h2 == 1+x^3+O(x^30)
  @test h2 + h1 == h1 + h2

  @test h1 + h3 == 1+O(x^30)
  @test h3 + h1 == h1 + h3

  @test h1 + h4 == 1+x-x^4-x^5+O(x^30)
  @test h4 + h1 == h1 + h4

  @test h1 - h2 == 1+2*x+2*x^2+x^3+O(x^30)
  @test h2 - h1 == -(h1 - h2)

  @test h1 - h3 == 1+2*x+2*x^2+2*x^3+O(x^30)
  @test h3 - h1 == -(h1 - h3)

  @test h1 - h4 == 1+x+2*x^2+2*x^3+x^4+x^5+O(x^30)
  @test h4 - h1 == -(h1 - h4)

  k1 = g1
  k2 = -g2
  k3 = -g3
  k4 = -g4

  @test k1 + k2 == x^2+x^5+O(x^32)
  @test k2 + k1 == k1 + k2

  @test k1 + k3 == x^2+O(x^32)
  @test k3 + k1 == k1 + k3

  @test k1 + k4 == x^2+x^3-x^6-x^7+O(x^32)
  @test k4 + k1 == k1 + k4

  @test k1 - k2 == x^2+2*x^3+2*x^4+x^5+O(x^32)
  @test k2 - k1 == -(k1 - k2)

  @test k1 - k3 == x^2+2*x^3+2*x^4+2*x^5+O(x^32)
  @test k3 - k1 == -(k1 - k3)

  @test k1 - k4 == x^2+x^3+2*x^4+2*x^5+x^6+x^7+O(x^32)
  @test k4 - k1 == -(k1 - k4)

  m1 = 1 + x + x^2 + x^3 + O(x^4)
  m2 = x + x^2 + O(x^3)
  m3 = x + x^2 + x^3 + O(x^4)
  m4 = x^2 + x^3 + x^4 + x^5 + O(x^6)

  @test isequal(m1 + m1, 2+2*x+2*x^2+2*x^3+O(x^4))

  @test isequal(m1 + m2, 1+2*x+2*x^2+O(x^3))

  @test isequal(m1 + m3, 1+2*x+2*x^2+2*x^3+O(x^4))

  @test isequal(m1 + m4, 1+x+2*x^2+2*x^3+O(x^4))

  @test isequal(m1 - m1, 0+O(x^4))

  @test isequal(m1 - m2, 1+O(x^3))

  @test isequal(m1 - m3, 1+O(x^4))

  @test isequal(m1 - m4, 1+x+O(x^4))
end

@testset "QQRelPowerSeriesRingElem.adhoc_binary_ops" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^4)
  c = 1 + x + 3x^2 + O(x^5)
  d = x^2 + 3x^3 - x^4

  for T in [Int, BigInt, Rational{Int}, Rational{BigInt}, ZZRingElem, QQFieldElem]
    @test T(2) + a == 2x + x^3 + 2
    @test a + T(2) == 2x + x^3 + 2
  end

  for T in [Int, BigInt, Rational{Int}, Rational{BigInt}, ZZRingElem, QQFieldElem]
    @test T(2) * a == 4x + 2x^3
    @test a * T(2) == 4x + 2x^3
  end

  @test ZZ(3)*b == O(x^4)

  @test c*2 == 2 + 2*x + 6*x^2 + O(x^5)

  for T in [Int, BigInt, Rational{Int}, Rational{BigInt}, ZZRingElem, QQFieldElem]
    @test d * T(3) == 3x^2 + 9x^3 - 3x^4
    @test T(3) * d== 3x^2 + 9x^3 - 3x^4
  end

  @test c*QQFieldElem(2, 3) == 2*x^2 + ZZRingElem(2)//3*x + ZZRingElem(2)//3+O(x^5)

  @test QQFieldElem(2, 3)*c == 2*x^2 + ZZRingElem(2)//3*x + ZZRingElem(2)//3+O(x^5)
end

@testset "QQRelPowerSeriesRingElem.comparison" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^3)
  c = 1 + x + 3x^2 + O(x^5)
  d = 3x^3 - x^4

  @test a == 2x + x^3

  @test b == d

  @test c != d
end

@testset "QQRelPowerSeriesRingElem.adhoc_comparison" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^0)
  c = 1 + O(x^5)
  d = R(3)


  for T in [Int, BigInt, Rational{Int}, Rational{BigInt}, ZZRingElem, QQFieldElem]
    @test d == T(3)

    @test c == T(1)

    @test T(0) != a

    @test T(2) == b

    @test T(1) == c
  end
end

@testset "QQRelPowerSeriesRingElem.powering" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^4)
  c = 1 + x + 2x^2 + O(x^5)
  d = 2x + x^3 + O(x^4)

  @test a^12 == x^36+24*x^34+264*x^32+1760*x^30+7920*x^28+25344*x^26+59136*x^24+101376*x^22+126720*x^20+112640*x^18+67584*x^16+24576*x^14+4096*x^12

  @test b^12 == O(x^48)

  @test c^12 == 2079*x^4+484*x^3+90*x^2+12*x+1+O(x^5)

  @test d^12 == 4096*x^12+24576*x^14+O(x^15)

  @test_throws DomainError d^-1
end

@testset "QQRelPowerSeriesRingElem.shift" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^4)
  c = 1 + x + 2x^2 + O(x^5)
  d = 2x + x^3 + O(x^4)

  @test shift_left(a, 2) == 2*x^3+x^5

  @test_throws DomainError shift_left(a, -1)

  @test_throws DomainError shift_right(a, -1)

  @test shift_left(b, 2) == O(x^6)

  @test shift_right(c, 1) == 1+2*x+O(x^4)

  @test shift_right(d, 3) == 1+O(x^1)
end

@testset "QQRelPowerSeriesRingElem.truncation" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^4)
  c = 1 + x + 2x^2 + O(x^5)
  d = 2x + x^3 + O(x^4)
  e = x^3 + O(x^10)

  @test truncate(a, 3) == 2*x + O(x^3)

  @test_throws DomainError truncate(a, -1)

  @test truncate(b, 2) == O(x^2)

  @test truncate(c, 5) == 2*x^2+x+1+O(x^5)

  @test truncate(d, 5) == x^3+2*x+O(x^4)

  @test isequal(truncate(e, 2), O(x^2))
end

@testset "QQRelPowerSeriesRingElem.exact_division" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = x + x^3
  b = O(x^4)
  c = 1 + x + 2x^2 + O(x^5)
  d = x + x^3 + O(x^6)

  @test divexact(a, d) == 1+O(x^5)

  @test divexact(d, a) == 1+O(x^5)

  @test divexact(b, c) == O(x^4)

  @test divexact(d, c) == -2*x^5+2*x^4-x^2+x+O(x^6)
end

@testset "QQRelPowerSeriesRingElem.adhoc_exact_division" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = x + x^3
  b = O(x^4)
  c = 1 + x + 2x^2 + O(x^5)
  d = x + x^3 + O(x^6)

  for T in [Int, BigInt, Rational{Int}, Rational{BigInt}, ZZRingElem, QQFieldElem]
    @test isequal(divexact(7a, T(7)), a)

    @test isequal(divexact(11b, T(11)), b)

    @test isequal(divexact(2c, T(2)), c)

    @test isequal(divexact(9d, T(9)), d)
  end

  @test isequal(divexact(94872394861923874346987123694871329847a, 94872394861923874346987123694871329847), a)
end

@testset "QQRelPowerSeriesRingElem.inversion" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 1 + x + 2x^2 + O(x^5)
  b = R(-1)

  @test inv(a) == -x^4+3*x^3-x^2-x+1+O(x^5)

  @test inv(b) == -1
end

@testset "QQRelPowerSeriesRingElem.integral_derivative" begin
  R, x = power_series_ring(QQ, 10, "x")

  for iter = 1:100
    f = rand(R, 0:0, -10:10)

    @test integral(derivative(f)) == f - coeff(f, 0)
  end
end

@testset "QQRelPowerSeriesRingElem.special" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 1 + x + 3x^2 + O(x^5)
  b = x + 2x^2 + 5x^3 + O(x^5)

  @test sqrt(a^2) == a
  @test log(exp(b)) == b
  @test asin(sin(b)) == b
  @test atan(tan(b)) == b
  @test sin(b)^2 + cos(b)^2 == 1 + O(x^5)
  @test asinh(sinh(b)) == b
  @test atanh(tanh(b)) == b
  @test cosh(b)^2 - sinh(b)^2 == 1 + O(x^5)

  for iter = 1:300
    f = rand(R, 0:9, -10:10)

    @test sqrt(f^2) == f || sqrt(f^2) == -f
  end
end

@testset "QQRelPowerSeriesRingElem.unsafe_operators" begin
  R, x = power_series_ring(QQ, 30, "x")

  for iter = 1:300
    f = rand(R, 0:9, -10:10)
    g = rand(R, 0:9, -10:10)
    f0 = deepcopy(f)
    g0 = deepcopy(g)

    h = rand(R, 0:9, -10:10)

    k = f + g
    h = add!(h, f, g)
    @test isequal(h, k)
    @test isequal(f, f0)
    @test isequal(g, g0)

    f1 = deepcopy(f)
    f1 = add!(f1, f1, g)
    @test isequal(f1, k)
    @test isequal(g, g0)

    g1 = deepcopy(g)
    g1 = add!(g1, f, g1)
    @test isequal(g1, k)
    @test isequal(f, f0)

    f1 = deepcopy(f)
    f1 = add!(f1, g)
    @test isequal(h, k)
    @test isequal(g, g0)

    k = f*g
    h = mul!(h, f, g)
    @test isequal(h, k)
    @test isequal(f, f0)
    @test isequal(g, g0)

    f1 = deepcopy(f)
    f1 = mul!(f1, f1, g)
    @test isequal(f1, k)
    @test isequal(g, g0)

    g1 = deepcopy(g)
    g1 = mul!(g1, f, g1)
    @test isequal(g1, k)
    @test isequal(f, f0)

    h = zero!(h)
    @test isequal(h, R())
  end
end

@testset "QQRelPowerSeriesRingElem.set_precision" begin
  R, x = power_series_ring(QQ, 30, "x")

  a = 2x + x^3
  b = O(x^4)
  c = 1 + x + 2x^2 + O(x^5)
  d = 2x + x^3 + O(x^4)
  e = x^3 + O(x^10)

  @test isequal(set_precision(a, 3), 2*x + O(x^3))
  @test isequal(set_precision(b, 2), O(x^2))
  @test isequal(set_precision(b, 10), O(x^10))
  @test isequal(set_precision(c, 5), 2*x^2+x+1+O(x^5))
  @test isequal(set_precision(c, 10), 2*x^2+x+1+O(x^10))
  @test isequal(set_precision(d, 5), x^3+2*x+O(x^5))
  @test isequal(set_precision(e, 2), O(x^2))

  @test_throws DomainError set_precision(a, -1)
end
