-- functie cu 2 parametri care calculeaza suma p ̆atratelor celor dou ̆a numere;
sumpatrate :: Int -> Int -> Int
sumpatrate a b = a*a+ b*b

-- functie cu un parametru ce ˆıntoarce mesajul ”par” dac ̆a parametrul este par s, i ”impar”
-- altfel;
paritate :: Int -> String
paritate x =
  if even x then "par"
    else "impar"

-- funct, ie care calculeaz ̆a factorialul unui num ̆ar;
fact :: Integer -> Integer
fact x = product[1..x]


-- funct, ie care verific ̆a dac ̆a un primul parametru este mai mare decˆat dublul celui de-al
-- doilea parametru.
verif :: Int -> Int -> Bool
verif a b =
  if a > 2 * b
    then True
  else False
