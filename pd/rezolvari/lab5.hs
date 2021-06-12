-- http://www.inf.ed.ac.uk/teaching/courses/inf1/fp/



import Data.Char
import Data.List


-- 1. --gresit
-- rotate :: Int -> [Char] -> [Char]
-- rotate n l
--   | n == 0        = l
--   | n < 0 or n > length l = error "N invalid" -- !!!!n > length l 
--   | n < length l  = error "N must be > list's length"
--   | otherwise     = rotate (n-1) (tail l ++ [head l])

--var2
{-
rotate :: Int -> [Char] -> [Char]
rotate 0 l = l
rotate k (xs) = rotate (k-1) (tail xs ++ [head xs])
-}

{-
--var 3
f :: Int -> [Char] -> [Char]
f 0 l = []
f n [] = error "n e prea mare"
f n (h:t) = h : f (n-1) t
g :: Int -> [Char] -> [Char]
g 0 l = l
g n [] = error "n e prea mare"
g n (h:t) = g (n-1) t
rotate :: Int -> [Char] -> [Char]
rotate n l = g n l ++ f n l
-}

--var 4
rotate :: Int -> [Char] -> [Char]
rotate n str
  | n > 0 && n < length str = str2 ++ str1
  | otherwise = error "N este invalid"
  where
    str1 = take n str
    str2 = drop n str

-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l

-- 3.
alphabet = ['A'..'Z']
makeKey :: Int -> [(Char, Char)]
makeKey n = zip alphabet(rotate n alphabet)

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp ch [] = ch
lookUp ch ((a, b) : t) = if ch == a then b
                                    else lookUp ch t

-- 5.
encipher :: Int -> Char -> Char
encipher n ch = lookUp ch (makeKey n)


-- 6.
lista = ['0'..'9'] ++ ['a'..'z'] ++ ['A'..'Z']
normalize :: String -> String
normalize l = filter(`elem` lista)(map(toUpper)(l))


-- 7.
encipherStr :: Int -> String -> String
encipherStr n l = [encipher n ch | ch <- normalize l ]
-- encipherStr n l  = map (encipher n) (normalize l)

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey [] = []
reverseKey ((a, b) : t) = ((b,a) : reverseKey t)


-- 9.
decipher :: Int -> Char -> Char
decipher n ch = lookUp ch $reverseKey $makeKey n
-- decipher n ch = lookUp ch(reverseKey(makeKey n))
-- f$x = f(x)
decipherStr :: Int -> String -> String
decipherStr n l = map (decipher n) l
