import Data.List

myInt = 55555555555555555555555555555555555555555555555555555555555
double :: Integer -> Integer
double x = x + x

triple :: Integer -> Integer
triple x = x + x + x

maxim :: Integer -> Integer -> Integer
maxim x y = if (x > y) then x else y

minim :: Integer -> Integer -> Integer
minim x y =
  if (x < y)
    then x
    else y

maxim3 :: Integer -> Integer -> Integer -> Integer
maxim3 x y z = maxim x $ maxim y z

maxim32 :: Integer -> Integer -> Integer -> Integer
maxim32 x y z =
  let
    u = maxim x y
  in
    maxim u z

maxim4 :: Integer -> Integer -> Integer -> Integer -> Integer
maxim4 a b c d =
  let
    u = maxim3 a b c
  in
    maxim u d

test_maxim4 a b c d = ((maxim4 a b c d) >= a) && ((maxim4 a b c d) >= b) && ((maxim4 a b c d) >= c) && ((maxim4 a b c d) >= d)

--functie cu 2 parametri care calculeaza suma p ̆atratelor celor dou ̆a numere;
f1 :: Integer -> Integer -> Integer
f1 x y = x*x + y*y

--paritate
f2 :: Integer -> String
f2 x = if (x `mod` 2 == 0) then "par" else "impar"

-- factorial
f3 :: Integer -> Integer
f3 x = product [1..x]


--funct, ie care verific ̆a dac ̆a un primul parametru este mai mare decˆat dublul celui de-al doilea parametru.
f4 :: Integer -> Integer -> Bool
f4 x y = if (x > 2 * y) then True else False
