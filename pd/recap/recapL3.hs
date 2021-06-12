l1 = [x^2 | x <- [1..10], x `rem` 3 == 2] -- 4 25 64
l2 = [(x,y) | x <- [1..5], y <- [x..(x+2)]] --[(1,1),(1,2),(1,3),(2,2),(2,3),(2,4),(3,3),(3,4),(3,5),(4,4),(4,5),(4,6),(5,5),(5,6),(5,7)]
l3 = [(x,y) |x <- [1..3], let k = x^2, y <- [1..k]] --[(1,1),(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(3,9)]
l4 = [ x | x <- "Fac de Mat si Inf", elem x ['A' .. 'Z']] --FMI
l5 = [[x..y] | x<- [1..5], y <- [1..5], x < y]--[[1,2],[1,2,3],[1,2,3,4],[1,2,3,4,5],[2,3],[2,3,4],[2,3,4,5],[3,4],[3,4,5],[4,5]]


--1 lista divizori pozitivi ai lui x
factori :: Int -> [Int]
factori x = [d | d <- [1..x], x `mod` d == 0]

--2
prim :: Int -> Bool
prim x
  | length (factori x) == 2 = True
  | otherwise = False

--3
numerePrime :: Int -> [Int]
numerePrime x = [nr |nr <- [2..x], prim nr]

--4
myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 _ _ [] = []
myzip3 _ [] _ = []
myzip3 [] _ _ = []
myzip3 l1 l2 l3 = (h1, h2, h3) :  myzip3 t1 t2 t3
  where
    h1 = head l1
    t1 = tail l1
    h2 = head l2
    t2 = tail l2
    h3 = head l3
    t3 = tail l3

l6 = map (\x -> 2 * x) [1..10] --[2,4,6,8,10,12,14,16,18,20]
l7 = map (1 `elem`) [[2,3], [1, 2]] --[False,True]
l8 = map (`elem` [2, 3]) [1,3,4,5] --[False,True,False,False]


--5
firstEl :: [(a, b)] -> [a]
firstEl l = map (\(x,y) -> x) l
--firstEl [ ('a', 3), ('b', 2), ('c', 1)]
-- "abc"

--6
sumList :: [[Int]] -> [Int]
sumList l = map (\x -> sum x ) l
--sumList [[1, 3],[2, 4, 5], [], [1, 3, 5, 6]]
-- [4,11,0,15]

--7
fAux :: Integer -> Integer
fAux x
   | even x = x `div` 2
   | otherwise = x * 2

prel2 :: [Integer] -> [Integer]
prel2 l = map fAux l

--8
findChar :: Char -> [String] -> [String]
findChar c list =  filter(c `elem`)  list

--9
pow2 :: [Int] -> [Int]
pow2 list = map (\x->x*x) $ filter(odd) list

--10
pow2' :: [Int] -> [Int]
pow2' l = map ((^2).fst) $ filter (odd.snd) $ l `zip` [0..]

--11
numaiVocale :: [String] -> [String]
numaiVocale l =  map(filter(`elem` "aeiouAEIOU")) l

--12
mymap :: (a -> b) -> [a] -> [b]
mymap f l = [f x | x <- l]

myfilter :: (a -> Bool) -> [a] -> [a]
myfilter prop l = [x | x<-l , prop x]


--ex de la tema
--1
ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = and [x < y | (x, y) <- zip xs (tail xs) ]

--2
ordonataNat1 :: [Int] -> Bool
ordonataNat1 [] = True
ordonataNat1 [x] = True
ordonataNat1 (x:xs)
  | x < head xs  = ordonataNat1 xs
  | otherwise = False

--3
ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata [] rel = True
ordonata [x] rel = True
ordonata (x:xs) rel = and [rel x y | (x, y) <- zip xs (tail xs) ]


--4
compuneList :: (b -> c) -> [(a->b)] -> [(a->c)]
compuneList f list = map (f.) list

aplicaList :: a -> [(a->b)] -> [b]
aplicaList a list = map (\f -> f a) list

myzip31 :: [a] -> [b] -> [c] -> [(a, b, c)]
myzip31 l1 l2 l3 = undefined 
