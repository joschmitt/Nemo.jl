function test_nmod_poly_constructors()
  print("nmod_poly.constructors...")

  R = ResidueRing(ZZ, 17)
  Rx, x = PolynomialRing(R, "x")

  S = ResidueRing(ZZ, 19)
  Sy, y = PolynomialRing(R, "y")

  RRx, xx = PolynomialRing(R, "x")
  RRRx, xxx = PolynomialRing(ResidueRing(ZZ, 17), "xx")

  @test var(Rx) == Symbol("x")

  @test RRx != RRRx

  @test RRx == Rx

  @test S != R

  @test isa(Rx, Ring)
  @test isa(x, Nemo.nmod_poly)

  a = Rx()

  @test isa(a, Nemo.nmod_poly)
  @test parent(a) == Rx

  b = Rx(2)
  
  @test isa(b, Nemo.nmod_poly)
  @test parent(b) == Rx

  c = Rx(ZZ(3))
  
  @test isa(c, Nemo.nmod_poly)
  @test parent(c) == Rx

  d = Rx(R(16))

  @test isa(d, Nemo.nmod_poly)
  @test parent(d) == Rx

  e = Rx([UInt(1), UInt(2), UInt(3)])

  @test isa(e, Nemo.nmod_poly)
  @test parent(e) == Rx

  f = Rx([ZZ(1), ZZ(2), ZZ(3)])

  @test isa(d, Nemo.nmod_poly)
  @test parent(f) == Rx

  g = Rx([R(1), R(2), R(3)])
  
  @test isa(g, Nemo.nmod_poly)
  @test parent(g) == Rx

  _a = PolynomialRing(ZZ, "y")[1]([ZZ(1),ZZ(2),ZZ(3)])
  
  h = Rx(_a)

  @test isa(h, Nemo.nmod_poly)
  @test parent(h) == Rx

  i = x^2 + x^2 + x^2 + x^1 + x^1 + R(1) 

  @test isa(i, Nemo.nmod_poly)
  @test parent(i) == Rx

  @test e == f
  @test f == g
  @test g == h
  @test h == i
  
  println("PASS")
end
  
function test_nmod_poly_manipulation()
  print("nmod_poly.manipulation...")

  R = ResidueRing(ZZ, 17)
  Rx, x = PolynomialRing(R, "x")

  @test isone(one(Rx))
  @test iszero(zero(Rx))
  @test isgen(gen(Rx))
  @test isunit(one(Rx))

  @test !isunit(gen(Rx))

  @test degree(x) == 1
  @test degree(x^10) == 10

  @test coeff(x^6 + R(2)*x^5, 5) == R(2)

  @test lead(R(3)*x^2 + x) == R(3)

  @test canonical_unit(-x + 1) == R(-1)

  println("PASS")
end

function test_nmod_poly_unaryoperations()
  print("nmod_poly.unaryoperations...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^2 + R(13)*x + R(5)

  @test -f ==  R(22)*x^2 + R(10)*x + R(18)

  println("PASS")
end
 
function test_nmod_poly_binaryoperations()
  print("nmod_poly.binaroperations...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^2 + R(13)*x + R(5)
  g = x^3 + R(11)*x^2 + R(10)*x + R(18)
  h = x + R(10)

  @test f + g == x^3 + R(12)*x^2

  @test f*g == x^5 + x^4 + R(20)*x^3 + R(19)*x^2 + R(8)*x + R(21);

  @test f - g == R(22)*x^3 + R(13)*x^2 + R(3)*x + R(10)

  @test h*(f+g) == x^4 + R(22)*x^3 + R(5)*x^2


  println("PASS")
end

function test_nmod_poly_adhocbinaryoperations()
  print("nmod_poly.adhocbinaryoperations...")

  R = ResidueRing(ZZ, 113)
  Rx, x = PolynomialRing(R, "x")

  S = ResidueRing(ZZ,112)

  f = x^2 + R(2)x + R(1)
  g = x^3 + R(3)x^2 + x

  @test ZZ(2)*f == R(2)x^2 + R(4)x + R(2)
  @test ZZ(2)*f == f*ZZ(2)
  @test 2*f == ZZ(2)*f
  @test f*2 == 2*f
  @test R(2)*f == ZZ(2)*f
  @test f*R(2) == R(2)*f

  @test_throws ErrorException S(1)*f

  @test f + 112 == x^2 + R(2)x
  @test 112 + f == f + 112
  @test f + ZZ(112) == f + 112
  @test ZZ(112) + f == f + ZZ(112)

  @test_throws ErrorException S(1)+f

  @test f - 1 == x^2 + R(2)x
  @test ZZ(1) - f == -(f - ZZ(1))
  @test ZZ(1) - f == R(112)*x^2 + R(111)*x
  @test f - R(1) == f - 1
  @test R(1) - f == -(f - R(1))

  @test_throws ErrorException f - S(1)

  println("PASS")
end

function test_nmod_poly_powering()
  print("nmod_poly.powering...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^2 + R(13)x + R(5)

  @test f^3 == x^6 + 16x^5 + 16x^4 + 11x^3 + 11x^2 + 9x + 10

  @test f^23 == x^46 + 13*x^23 + 5

  @test_throws DomainError f^(-1)

  println("PASS")
end

function test_nmod_poly_comparison()
  print("nmod_poly.comparison...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")
  Ry, y = PolynomialRing(R, "y")

  @test x^2 + x == x^2 + x
  @test_throws ErrorException x^2 + x != y^2 + y

  println("PASS")
end

function test_nmod_poly_truncation()
  print("nmod_poly.truncation...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2

  g = truncate(f,4)

  @test parent(g) == parent(f)

  @test truncate(f,2) == R(0)
  @test truncate(f,5) == x^4 + 2*x^2
  @test truncate(f,10) == f

  println("PASS")
end

function test_nmod_poly_mullow()
  print("nmod_poly.mullow...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2
  g = x^4 + x^3

  @test mullow(f,g,2) == truncate(f*g,2)
  @test mullow(f,g,7) == truncate(f*g,7)

  println("PASS")
end

function test_nmod_poly_reverse()
  print("nmod_poly.reverse...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2 + 1

  g = reverse(f) 

  @test parent(g) == parent(f)
  @test g == x^5 + 2*x^3 + x + 1
  @test isone(reverse(x))

  println("PASS")
end
 
function test_nmod_poly_shift()
  print("nmod_poly.shift...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2 + 1

  g = shift_left(f,3)
  h = shift_right(f,3)

  @test parent(g) == parent(f)
  @test parent(h) == parent(f)

  @test g == x^3*f

  @test h == x^2 + x

  @test f == shift_right(shift_left(f,20),20)

  @test_throws DomainError shift_left(f,-1)
  @test_throws DomainError shift_right(f,-1)

  println("PASS")
end

function test_nmod_poly_division()
  print("nmod_poly.division...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2 + x

  g = divexact(f,x)

  @test parent(g) == parent(f)
  @test g == x^4 + x^3 + 2*x + 1

  g = divexact(f,x+1)
  
  @test g == x^4 + 2*x + 22

  h = x^1235+x^23

  @test divexact(f*h,h) == f

  @test_throws DivideError divexact(f,zero(Rx))

  @test f - divexact(f,Rx(2))*2 == zero(Rx)

  (q,r) = divrem(f,x+2)

  @test parent(q) == parent(f)
  @test parent(r) == parent(f)

  @test (q,r) == (x^4 + 22*x^3 + 2*x^2 + 21*x + 5, Rx(13))
  @test f == q*(x+2) + r

  @test_throws DivideError divrem(f,zero(Rx))

  r = rem(f,x+3)

  @test parent(r) == parent(f)

  @test r == Rx(14)

  println("PASS")
end

function test_nmod_poly_gcd()
  print("nmod_poly.gcd...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2 + x
  g = x^3 + x^2 + x

  k = gcd(f,g)

  @test parent(k) == parent(x)
  @test k == x

  k, s, t = gcdx(f,g)

  @test k == s*f + t*g

  println("PASS")
end

function test_nmod_poly_modular_arithmetic()
  print("nmod_poly.modular_arithmetic...")

  R = ResidueRing(ZZ, 487326487)
  S, x = PolynomialRing(R, "x")

  f = 3*x^2 + x + 2
  g = 5*x^2 + 2*x + 1
  h = 3*x^3 + 2*x^2 + x + 7

  @test gcdinv(f, g) == (1,84344969*x+234291581)

  @test invmod(f, h) == 40508247*x^2+341251293*x+416130174 

  @test mulmod(f, g, h) == 324884334*x^2+162442132*x+162442162

  @test powmod(f, 10, h) == 485924368*x^2+380106591*x+302530457

  println("PASS")
end

function test_nmod_poly_resultant()
  print("nmod_poly.resultant...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2 + x

  @test resultant(f,x) == Rx(0)

  g = resultant(f,x^2 +2)

  @test parent(g) == R

  @test g == 4

  println("PASS")
end

function test_nmod_poly_evaluate()
  print("nmod_poly.evaluate...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2 + x

  r = evaluate(f,R(20))

  @test r == R(14)

  println("PASS")
end

function test_nmod_poly_derivative()
  print("nmod_poly.derivative...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2 + x

  ff = derivative(f)

  @test parent(ff) == parent(f)

  @test ff == 5*x^4 + 4*x^3 + 4*x + 1

  println("PASS")
end

function test_nmod_poly_integral()
  print("nmod_poly.integral...")

  R = ResidueRing(ZZ, 7)
  S, x = PolynomialRing(R, "x")

  f = x^2 + 2x + 1
  
  @test integral(f) == 5x^3 + x^2 + x

  println("PASS")
end

function test_nmod_poly_compose()
  print("nmod_poly.compose...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^5 + x^4 + 2 *x^2 + x
  g = x+1

  ff = compose(f,g)

  @test parent(ff) == parent(f)

  @test ff == x^5 + 6*x^4 + 14*x^3 + 18*x^2 + 14*x + 5

  println("PASS")
end

function test_nmod_poly_interpolate()
  print("nmod_poly.interpolate...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  xval = [ R(0), R(1), R(2), R(3) ]

  yval = [ R(0), R(1), R(4), R(9) ] 

  f = interpolate(Rx,xval,yval)

  @test parent(f) == Rx
  @test f == x^2

  println("PASS")
end

function test_nmod_poly_inflate()
  print("nmod_poly.inflate...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^6 + x^4 + 2 *x^2 

  g = inflate(f,2)

  @test parent(g) == parent(f)
  @test g == x^12 + x^8 + 2*x^4

  @test_throws DomainError inflate(f,-1)

  println("PASS")
end


function test_nmod_poly_deflate()
  print("nmod_poly.deflate...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^6 + x^4 + 2 *x^2 

  g = deflate(f,2)

  @test parent(g) == parent(f)
  @test g == x^3 + x^2 + 2*x

  @test_throws DomainError deflate(f,-1)

  println("PASS")
end

function test_nmod_poly_lifting()
  print("nmod_poly.lifting...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")
  Zy,y = PolynomialRing(ZZ, "y")

  f = x^6 + x^4 + 2 *x^2 

  Zf = lift(Zy, f)

  @test Rx(Zf) == f

  println("PASS")
end


function test_nmod_poly_isirreducible()
  print("nmod_poly.isirreducible...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^6 + x^4 + 2 *x^2 

  @test !isirreducible(f)

  @test isirreducible(x)

  @test isirreducible(x^16+2*x^9+x^8+x^2+x+1)

  println("PASS")
end

function test_nmod_poly_issquarefree()
  print("nmod_poly.issquarefree...")

  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = x^6 + x^4 + 2 *x^2 

  @test !issquarefree(f)

  @test issquarefree((x+1)*(x+2)*(x+3))

  println("PASS")
end

function test_nmod_poly_factor()
  print("nmod_poly.lifting...")
  
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  f = (x^6 + x^4 + 2 *x^2 )^10 + x - 1

  fac = factor(f)

  p = Rx(1)

  for i in 1:length(fac)
    p *= fac[i][1]^fac[i][2]
  end

  @test f == p

  sh = factor_shape(f)

  @test Set(sh) == Set([(36,1),(1,1),(4,1),(19,1)])

  f = (x^6 + x^4 + 2 *x^2 )^10 

  fac = factor_squarefree(f)

  @test Set(fac) == Set([(x^4+x^2+2,10), (x,20)])

  @test_throws ErrorException factor_distinct_deg(f)

  fac = factor_distinct_deg(x^6 + x^4 + 2*x^2+2)

  @test length(fac) == 1
  @test fac[1] == (x^6+x^4+2*x^2 + 2, 2)

  println("PASS")
end

function test_nmod_poly_canonicalization()
  print("nmod_poly.canonicalization...")
  R = ResidueRing(ZZ, 23)
  Rx, x = PolynomialRing(R, "x")

  @test canonical_unit(5*x) == R(5)

  println("PASS")
end

function test_nmod_poly()
  test_nmod_poly_constructors()
  test_nmod_poly_manipulation()
  test_nmod_poly_unaryoperations()
  test_nmod_poly_binaryoperations()
  test_nmod_poly_adhocbinaryoperations()
  test_nmod_poly_powering()
  test_nmod_poly_comparison()
  test_nmod_poly_truncation()
  test_nmod_poly_mullow()
  test_nmod_poly_reverse()
  test_nmod_poly_shift()
  test_nmod_poly_division()
  test_nmod_poly_gcd()
  test_nmod_poly_modular_arithmetic()
  test_nmod_poly_resultant()
  test_nmod_poly_evaluate()
  test_nmod_poly_derivative()
  test_nmod_poly_integral()
  test_nmod_poly_compose()
  test_nmod_poly_interpolate()
  test_nmod_poly_inflate()
  test_nmod_poly_deflate()
  test_nmod_poly_lifting()
  test_nmod_poly_isirreducible()
  test_nmod_poly_issquarefree()
  test_nmod_poly_factor()
  test_nmod_poly_canonicalization()

  println("")
end