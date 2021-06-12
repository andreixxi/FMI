import Control.Monad
import Data.List
import Data.Char

numbers = [1,2,3,4,5]
total = foldl (*) 1 numbers -- 1 * (1 * 2 * 3 * 4 * 5) = 120
total2 = product $ numbers
double = map (*2) numbers -- 2 * [1,2,3,4,5] =[2,4,6,8,10]

qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = (qsort lesser) ++ [x] ++ (qsort greater)
  where
    lesser = filter (<=x) xs
    greater = filter (>x) xs

-- cum asez n regine pe o tabla de n*n ai sa nu se atace
queens :: Int -> [[Int]]
queens n = foldM f [] [1..n]
  where
    f qs _ = [q:qs | q <- [1..n] \\ qs, q `notDiag` qs]
    q `notDiag` qs = and [abs (q - qi) /= i | (qi, i) <- qs `zip` [1..]]

fact n = if n == 0
          then 1
          else n * fact (n-1)

trei = let
          a = 1
          b = 2
        in a + b

f x = g x + g x + z
  where
    g x = 2 * x
    z = x-1

h x | x == 0 = 0
    | x == 1 = y + 1 -- x^2 + 1
    | x == 2 = y * y -- x^4
    | otherwise = y -- x^2
  where y = x*x

digitsToInt :: String -> Int
digitsToInt x = read x :: Int

selectie :: Int -> String -> String
selectie 0 s = s -- selectie 0 "alin" = "alin"
selectie 1 (_:s) = s -- selectie 1 "alin" = "lin"
selectie 1 "" = ""
selectie _ s = s ++ s -- selectie 2 "alin" = "alinalin"

f2 :: Int -> Int
f2 x = x + 1

semn :: Int -> Int
semn n | n < 0 = -1
       | n == 0 = 0
       | otherwise = 1

reverse' :: [Int] -> [Int]
reverse' [] = []
reverse' (x:xs) = (reverse' xs) ++ [x]

f3 l = map(*3) $ filter (>= 2) l

f4 :: [Int] -> Int
f4 l = sum [x * x | x<-l, x>0]

f4_ :: [Int] -> Int
f4_ [] = 0
f4_ (x : xs)
  | x > 0 = (x * x) + f4_ xs
  | otherwise = f4_ xs

f4' :: [Int] -> Int
f4' l = foldr(+) 0 $ map (^2) $ filter (>0) l

scrieLitereMari :: String -> String
scrieLitereMari s = map (toUpper) s

incepeLitMare :: [String] -> [String]
incepeLitMare l = [x | x<-l, isUpper (head x)]

incepeLitMare' :: [String] -> [String]
incepeLitMare' [] = []
incepeLitMare' (x:xs)
  | isUpper(head x) = x : incepeLitMare' xs
  | otherwise = incepeLitMare' xs

-- fac o functie pentru filter si o aplic pe lista de stringuri
fAux :: String -> Bool
fAux sir = isUpper(head sir)
incepeLitMare'' :: [String] -> [String]
incepeLitMare'' l = filter (fAux) l

collatz :: Int -> [Int]
collatz n
  | n == 1 = [1]
  | even n = [n] ++ collatz (n `div` 2)
  | otherwise = [n] ++ collatz(3*n+1)

fAux2 :: [Int] -> Bool
fAux2 l = length l <= 5
collatzSeq :: [[Int]]
collatzSeq = filter (fAux2) ( map collatz [1..100] )

--lungimea celui mai lung cuvant care incepe cu 'c'
lungime, lungime' :: [String] -> Int
lungime l = fst $ maximum $  [(length str, str) | str <- l, head str == 'c']

lungime' l = foldr max 0 $ map length $ filter (\x -> head x == 'c') l

sumList, sumRec, sumFold :: [Int] -> Int
sumList l = sum [x | x <- l]
sumRec [] = 0
sumRec (x:xs) = x + sumRec xs
sumFold l = foldr(+) 0 l

elem x ys = or [ x==y | y <-ys]


data Season = Spring | Summer | Autumn | Winter
succesor Spring = Summer
succesor Summer = Autumn
succesor Autumn = Winter
succesor Winter = Spring

showSeason Spring = "Spring"
showSeason Summer = "Summer"
showSeason Autumn = "Autumn"
showSeason Winter = "Winter"

instance Show Season where
  show = showSeason

data Point a b = Pt a b
pr1 :: Point a b -> a
pr1 (Pt x _) = x
pr2 :: Point a b -> b
pr2 (Pt _ y) = y
pointFlip :: Point a b -> Point b a
pointFlip (Pt x y) = Pt y x
-------
type FirstName = String
type LastName = String
type Age = Int
type Height = Float
type Phone = String

data Person = Person FirstName LastName Age Height Phone

firstName :: Person -> String
firstName (Person name _ _ _ _) = name
lastName :: Person -> String
lastName (Person _ name _ _ _) = name
age :: Person -> Int
age (Person _ _ x _ _) = x
height :: Person -> Float
height (Person _ _ _ h _) = h
phone :: Person -> String
phone (Person _ _ _ _ p) = p
