from math import sqrt 
import times 

proc trailing_zeros(n:int): int =
    var order = 0
    var n = n
    while n mod 2 == 0:
        order += 1
        n = n div 2
    return order

proc stein_gcd(a, b:int):int=
    if a == 0:
        return abs(b)
    if b == 0:
        return abs(a)
    let za = trailing_zeros(a)
    let zb = trailing_zeros(b)
    let k = min(za, zb)

    var u = abs(a shr za)
    var v = abs(b shr zb)

    while u != v:
        if u > v:
            swap u,v
        v -= u
        v = v shr trailing_zeros(v)

    let r = u shl k
    return r

proc calc_pi_by_gcd(N:int): float64 = 
  var s = 0
  for a in 1..N:
    for b in 1..N:
      if stein_gcd(a,b)==1:
        s+=1 
  var pi=sqrt(6*N*N/s)
  return pi 

if isMainModule:
  let N = 10000
  var s=cpuTime()
  var pi=calc_pi_by_gcd(N)
  var e=cpuTime()
  echo "pi=",pi
  echo e-s,"[sec]"