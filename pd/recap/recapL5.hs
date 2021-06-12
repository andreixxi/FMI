import Data.Char

--1
rotate :: Int -> String -> String
rotate n str
  | n == 0 = str
  | n<0 || n>length str = error "N invalid"
  | otherwise = rotate (n-1) $ tail str ++ [head(str)]

--2
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l

--3
makeKey :: Int -> [(Char, Char)]
makeKey n = zip ['A'..'Z'] $ rotate n ['A'..'Z']

--4
lookUp :: Char -> [(Char, Char)] -> Char
lookUp c [] = c
lookUp c (x:xs) = if fst x == c then snd x
                  else lookUp c xs

--5
encipher :: Int -> Char -> Char
encipher n ch = lookUp ch $ makeKey n

--6
ok = ['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9']
normalize :: String -> String
normalize str = [toUpper x | x<-str, x `elem` ok ]

--7
encipherStr :: Int -> String -> String
encipherStr n str = [encipher n x | x <- normalize str]

--8
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey pair = [(snd x, fst x) | x<- pair]

--9
decipher :: Int -> Char -> Char
decipher n ch = lookUp ch $  reverseKey $ makeKey n

decipherStr :: Int -> String -> String
decipherStr n str = [decipher n x | x <-  str]
