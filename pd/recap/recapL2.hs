import Data.Char

fibb :: Int -> Int
fibb n =
  if n <=1
    then n
  else
    fibb (n-1) + fibb (n-2)
--sau

fibonacciCazuri  :: Int -> Int
fibonacciCazuri  n
  | n <= 1 = n
  | otherwise = fibonacciCazuri  (n-1) + fibonacciCazuri  (n-2)


fibonacciEcuational  :: Int -> Int
fibonacciEcuational  0 = 0
fibonacciEcuational  1 = 1
fibonacciEcuational  n =
  fibonacciEcuational  (n-1) + fibonacciEcuational  (n-2)

fibonacciLiniar  :: Int -> Int
fibonacciLiniar  0 = 0
fibonacciLiniar  1 = 1
fibonacciLiniar  n = snd $fibonacciPereche  n
  where
    fibonacciPereche  :: Int -> (Int, Int)
    fibonacciPereche  1 = (0, 1)
    fibonacciPereche  n =
      let
        (a, b) = fibonacciPereche(n-1)
      in
        (b, a+b)


semiPare :: [Int] -> [Int]
semiPare [] = []
semiPare (x:xs) =
  if x `mod` 2 == 0
    then
      x `div` 2 : semiPare xs
    else
      semiPare xs

semiPare2 :: [Int] -> [Int]
semiPare2 l
  | null l = l
  | h `mod` 2 == 0 = h `div` 2 : t2
  | otherwise = t2
  where
    h = head l
    t = tail l
    t2 = semiPare2 t

semiPare3 :: [Int] -> [Int]
semiPare3 [] = []
semiPare3 (x:xs)
  | x `mod` 2 == 0 = x `div` 2 : semiPare3 xs
  | otherwise = semiPare3 xs


--expresie(rezultat) | selectori(x<-l), legari(separari prin virgula), filtrari (conditii tip bool)
-- seectori -> legari + filtrari -> expresie
--[ | ]   => [ | x <- l ] => [ | x <- l, x `mod` 2 == 0] = [x `div` 2 | x <- l, x `mod` 2 == 0]
semiPare4 :: [Int] -> [Int]
semiPare4 l = [x `div` 2 | x <- l, x `mod` 2 == 0]


--ex
--1
inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b l = [x | x <-l, x >=a && x <= b]

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec a b [] = []
inIntervalRec a b (x:xs)
  | a <= x && x <= b = x : inIntervalRec a b xs
  | otherwise = inIntervalRec a b xs

--2
pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs)
  | x > 0 = 1 + pozitiveRec xs
  | otherwise = 0 + pozitiveRec xs

pozitiveComp :: [Int] -> Int
pozitiveComp l = sum [1 | x <-l, x > 0]

--3
aux :: [Int] -> Int -> [Int]
aux [] _ = []
aux (x:xs) n
  | x `mod` 2 == 1 = n : aux xs (n+1)
  | otherwise = aux xs (n+1)

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec l = aux l 0


pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = [y  | (x, y) <- zip l [0..], x `mod` 2 == 1]

pozitiiImpareComp2 :: [Int] -> [Int]
pozitiiImpareComp2 l = [idx  --lista de indecsi
                            | idx <- [0..length l - 1], --[0,1,2,....]
                              let x = l !! idx, -- x = l[idx]
                              x `mod` 2 == 1 ] --daca este impar

-- 4
multDigitsRec :: String -> Int
multDigitsRec "" = 1
multDigitsRec (x:xs)
  | isDigit x = digitToInt x * multDigitsRec xs
  | otherwise = multDigitsRec xs


multDigitsComp :: String -> Int
multDigitsComp l = product [digitToInt x | x <-l, isDigit x]


--5
discountRec :: [Double] -> [Double]
discountRec [] = []
discountRec (x:xs)
  | x - 0.25 * x < 200 = (x - 0.25 * x) : discountRec xs
  | otherwise =  discountRec xs

discountComp :: [Double] -> [Double]
discountComp l = [x - 0.25 * x | x<-l, x - 0.25 * x < 200]
