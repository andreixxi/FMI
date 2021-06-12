import   Data.List

-- L3.1 Încercati sa gasiti valoarea expresiilor de mai jos si
-- verificati raspunsul gasit de voi în interpretor:
{-
[x^2 | x <- [1 .. 10], x `rem` 3 == 2]
[(x, y) | x <- [1 .. 5], y <- [x .. (x+2)]]
[(x, y) | x <- [1 .. 3], let k = x^2, y <- [1 .. k]]
[x | x <- "Facultatea de Matematica si Informatica", elem x ['A' .. 'Z']]
[[x .. y] | x <- [1 .. 5], y <- [1 .. 5], x < y ]

-}

-- ex 1
factori :: Int -> [Int]
factori n = [x | x <- [1..n], n `rem` x == 0] --rem = mod

-- ex 2
prim :: Int -> Bool
prim x | length(factori x) == 2 = True
       | otherwise = False
-- prim n = factori n == [1, n]

-- ex 3
numerePrime :: Int -> [Int]
numerePrime x = [y | y <- [2..x], prim y == True]

-- L3.2 Testati si sesizati diferenta:
-- [(x,y) | x <- [1..5], y <- [1..3]]
-- zip [1..5] [1..3]

myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 _ _ [] = []
myzip3 _ [] _ = []
myzip3 [] _ _ = []
myzip3 (a:a1) (b:b1) (c:c1) = (a, b, c) : myzip3 a1 b1 c1


--------------------------------------------------------
----------FUNCTII DE NIVEL INALT -----------------------
--------------------------------------------------------
aplica2 :: (a -> a) -> a -> a
--aplica2 f x = f (f x)
--aplica2 f = f.f
--aplica2 f = \x -> f (f x)
aplica2  = \f x -> f (f x)

-- L3.3
{-

map (\ x -> 2 * x) [1 .. 10] --[2,4,6,8,10,12,14,16,18,20]
map (1 `elem` ) [[2, 3], [1, 2]] --[False,True]

--1 elem[2,3] false; 3 elem[2,3] true .. etc;; cauta x din [1,3,4,5] in [2,3]
map ( `elem` [2, 3] ) [1, 3, 4, 5]

-}


---- EXERCITII map
-- firstEl [ ('a', 3), ('b', 2), ('c', 1)]
firstEl :: [(a, b)] -> [a]
firstEl perechi = map fst perechi

-- sumList [[1, 3],[2, 4, 5], [], [1, 3, 5, 6]]
sumList :: [[Int]] -> [Int]

sumList l = map sum l
-- sumList = map(\x -> sum x)
-- sumList = map sum

-- prel2 [2,4,5,6]
f x = if odd x then x * 2
      else x `div` 2
prel2 l = map f l
--sau
prel3 :: [Int] -> [Int]
prel3 l = map (\x -> if x `rem` 2 == 1 then x * 2 else x `div` 2) l

prel4 l = map f l
  where
    f x = if odd x then x*2 else x `div` 2


---- EXERCITII filter
--1.
findChar  :: Char -> [String] -> [String]
findChar  ch s = filter (ch `elem`) s

--2.
pow2 :: [Int] -> [Int]
-- pow2 l = map (^2) (filter odd l)
--sau
-- pow2 = map (^2) . filter odd
--sau
pow2 l = map(^2) l'
  where
    l' = filter odd l
--
-- pow2 l = l''
--   where


--3.
poww2 :: [Integer] -> [Integer]
-- poww2 l = map ((^2).fst) (filter (odd.snd) (l `zip` [0..]))

--sau
{-poww2 l = l3
  where
    l1 = zip l [0..] --l1 pt pozitii
    l2 = filter (odd.snd) l1
    l3 = map ((^2).fst) l2
-}
--sau
poww2 l = l3
  where
    l1 = zip l [0..] --l1 pt pozitii
    l2 = filter (\(x, y) -> odd y) l1
    l3 = map (\(x, y) -> x^2) l2


--4.
vocale l = map (filter (`elem` "aeiouAEIOU")) l


--5.
mymap :: (a -> b) -> [a] -> [b]
mymap _ [] = []
mymap f (h:t) = (f h) : (mymap f t)

myfilter :: (a -> Bool) -> [a] -> [a]
myfilter _ [] = []
myfilter f (h:t)
  | f h = h : (myfilter f t)
  | otherwise = myfilter f t


mymap1 :: (a -> b) -> [a] -> [b]
mymap1 f a = [f(x) | x <- a]

myfilter1 :: (a -> Bool) -> [a] -> [a]
myfilter1 f a = [x | x <- a, f(x)]

------
--material suplimentar
--ciurul lui eratostene
{-erat :: Int -> [Int]
erat n = array
  where
    let l1 = [2..n] --indecsi de la 2 la n
    let a = [(True, val) | val <- l1] --
    let l2 = [2..sqrt fromIntegral n] --pt i


    if a.fst == True
      then let l3 = []
-}

--ciur
numerePrimeCiur :: Int -> [Int]
numerePrimeCiur n = ciurRec [2..n]
 where
 ciurRec [] = []
 ciurRec (x:xs) = x : (ciurRec $ filter (\n -> n `rem` x /= 0) xs)

--ciur v2
numerePrimeCiur2:: Int -> [Int]
numerePrimeCiur2 x = [k | k <- [2..x], length (filter (==k) l) == 0 ]
 where
   l = [z | y <- [2..x], z <- [y+y, y+y+y..x]]

--exercitii
-- 1.
ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = and [x < y | let y = head xs, (x, y) <- zip xs (tail xs)]
--tail xs are cu un element mai putin decat xs
--zip intre lista si elemntele consecutive din lista

-- 2.
ordonataNat2 :: [Int] -> Bool
ordonataNat2 [] = True
ordonataNat2 [x] = True
ordonataNat2 (x : xs) =
    let
      y = head xs
    in
      x < y && ordonataNat2 xs
--sau
ordonataNat1 :: [Int] -> Bool
ordonataNat1 [] = True
ordonataNat1 [x] = True
ordonataNat1 (x:y:xs)
 | x <= y = ordonataNat1 (y:xs)
 | otherwise = False

-- 3. a.
ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata l relatie = and [relatie x y | (x, y) <- zip l (tail l)]

--alta varianta
ordonata1 :: [a] -> (a -> a -> Bool) -> Bool
ordonata1 [] _ = True
ordonata1 [x] _ = True
ordonata1 (x:y:xs) f = (f x y) && (ordonata1 (y:xs) f)

-- b.
-- ordonata [1,5,10] (<) True
-- ordonata [1,5,10] (>) False
-- ordonata ["abcd", "acd"] (<) True

-- c.
(*<*) :: (Integer, Integer) -> (Integer, Integer) -> Bool
(a, b) *<* (c, d) = a < c && b < d
-- (*<*) (1, 10) (0, - 3) False
-- (*<*) (1, 10) (15, 38) True
-- ordonata [(1,2), (3,4)] (*<*) True

-- 4.
compuneList :: (b -> c) -> [(a -> b)] -> [(a -> c)]
compuneList f listafunctii = map (f.) listafunctii
--sau
-- compuneList f listF = [f . x | x <- listF]



aplicaList :: a -> [( a-> b)] -> [b]
aplicaList x lista = map (\f -> f x) lista
--sau
-- aplicaList a listF = [f a | f <- listF]

{-
myzip31 :: [a] -> [b] -> [c] -> [(a, b, c)] --todo
myzip31 a b c = map(\ ((a, b1), b2) -> (a, b1, b2))
 zip (zip (a b ) c)
-}
