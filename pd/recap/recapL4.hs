--1
--a
produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (x:xs) = x * produsRec xs
--b
produsFold :: [Integer] -> Integer
produsFold l = foldr(*) 1 l -- operatia, elem neutru, lista

--2
--a
andRec :: [Bool] -> Bool
andRec [] = True
andRec (x:xs) = x && andRec xs

--b
andFold :: [Bool] -> Bool
andFold l = foldr(&&) True l

--3
concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (x:xs) = x ++ concatRec xs

concatFold :: [[a]] -> [a]
concatFold l = foldr(++) [] l

--4 a
rmChar :: Char -> String -> String
rmChar c str = [l | l <- str, l /= c]
--b
rmCharsRec :: String -> String -> String
rmCharsRec [] s = s
rmCharsRec (x:xs) s2 =  rmCharsRec xs (rmChar x s2)

test1 :: Bool
test1 = rmCharsRec ['a'..'l'] "fotbal" == "ot"
--c
rmCharsFold :: String -> String -> String
rmCharsFold s1 s2 = foldr(rmChar) s2 s1
