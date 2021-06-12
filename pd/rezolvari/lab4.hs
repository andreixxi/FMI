import Numeric.Natural

--1.a
produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (x:xs) = x * produsRec xs

--b
produsFold :: [Integer] -> Integer
produsFold l = foldr (*) 1 l

--2.a
andRec :: [Bool] -> Bool
andRec [] = True
andRec (x:xs) = x && andRec xs

--b
andFold :: [Bool] -> Bool
andFold l = foldr (&&) True l

--3.a
concatRec :: [[a]] -> [a]
concatRec[] = []
concatRec (x:xs) = x ++ (concatRec xs)

--b
concatFold :: [[a]] -> [a]
concatFold l = foldr (++) [] l

--4.a
rmChar :: Char -> String -> String
rmChar ch l = [x | x <- l, x /= ch]
-- rmChar ch = filter (/= ch)

--b
rmCharsRec :: String -> String -> String
rmCharsRec [] s = s
rmCharsRec (h:t) s = rmCharsRec t (rmChar h s)

-- rmCharsRec :: String -> String -> String
-- rmCharsRec _ "" = ""
-- rmCharsRec a (h:t)
--   | h `elem` a = t'
--   | otherwise = h:t'
--   where t' = rmCharsRec a t

test_rmchars :: Bool
test_rmchars = rmCharsRec ['a'..'l'] "fotbal" == "ot"


--c
rmCharsFold :: String -> String -> String
rmCharsFold s1 s2 = foldr (rmChar) s2 s1


-----------
--evaluare lenesa
logistic :: Num a => a -> a -> Natural -> a
logistic rate start = f
  where
    f 0 = start
    f n = rate * f (n - 1) * (1 - f (n - 1))

logistic0 :: Fractional a => Natural -> a
logistic0 = logistic 3.741 0.00079

ex1 :: Natural
ex1 = 100

--daca ex1 e maricel nu ruleaza
ex20 :: Fractional a => [a]
ex20 = [1, logistic0 ex1, 3]

--ia doar primul element = 1
ex21 :: Fractional a => a
ex21 = head ex20

--elementul de pe pozitia2 = 3
ex22 :: Fractional a => a
ex22 = ex20 !! 2

--afiseaza 3
ex23 :: Fractional a => [a]
ex23 = drop 2 ex20

--ultimele 2 elemente, trb ex1 o valoare mica
ex24 :: Fractional a => [a]
ex24 = tail ex20


ex31 :: Natural -> Bool
ex31 x = x < 7 || logistic0 (ex1 + x) > 2

ex32 :: Natural -> Bool
ex32 x = logistic0 (ex1 + x) > 2 || x < 7
ex33 :: Bool
ex33 = ex31 5

ex34 :: Bool
ex34 = ex31 7

ex35 :: Bool
ex35 = ex32 5

ex36 :: Bool
ex36 = ex32 7
