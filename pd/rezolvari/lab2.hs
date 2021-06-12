
-- la nevoie decomentati liniile urmatoare:
-- import Test.QuickCheck
import Data.Char
import Data.List


---------------------------------------------
-------RECURSIE: FIBONACCI-------------------
---------------------------------------------

fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
  | n < 2     = n
  | otherwise = fibonacciCazuri (n - 1) + fibonacciCazuri (n - 2)

fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n =
    fibonacciEcuational (n - 1) + fibonacciEcuational (n - 2)

{-| @fibonacciLiniar@ calculeaza @F(n)@, al @n@-lea element din secvența
Fibonacci în timp liniar, folosind funcția auxiliară @fibonacciPereche@ care,
dat fiind @n >= 1@ calculează perechea @(F(n-1), F(n))@, evitănd astfel dubla
recursie. Completați definiția funcției fibonacciPereche.

Indicație:  folosiți matching pe perechea calculată de apelul recursiv.
-}
fibonacciPereche :: Integer -> (Integer, Integer)
fibonacciPereche 1 = (0, 1)
fibonacciPereche n =
  let (a, b) = fibonacciPereche(n-1) -- b e nr mai mare
  in (b, a + b) -- dupa in este rasp functiei, adica fibpereche este (b, a+b)
-- fn = a + b
-- fn-1 = b
-- fn-2 = a

fibonacciLiniar :: Integer -> Integer
fibonacciLiniar 0 = 0
fibonacciLiniar n = b
  where
        (_, b) = fibonacciPereche n
--(_,b) = {fn-1, fn}

test n = fibonacciLiniar n == fibonacciCazuri n


---------------------------------------------
----------RECURSIE PE LISTE -----------------
---------------------------------------------
semiPareRecDestr :: [Int] -> [Int]
semiPareRecDestr l
  | null l    = l
  | even h    = h `div` 2 : t' --pun catul impartirii la 2, concatenat la restul apelului recursiv
  | otherwise = t'
  where
    h = head l --primul element din lista
    t = tail l --restul listei
    t' = semiPareRecDestr t --functia apelata recursiv pe restul elem

-- varianta 2 (de preferat)
semiPareRecEq :: [Int] -> [Int]
semiPareRecEq [] = [] --pt lista vida rezultatul este lista vida
semiPareRecEq (h:t)
  | even h    = h `div` 2 : semiPareRecEq t -- ":" pt concatenare
  | otherwise = semiPareRecEq t
  -- where t' = semiPareRecEq t

---------------------------------------------
----------DESCRIERI DE LISTE ----------------
---------------------------------------------
--pt x din l care este par pastrez x/2
semiPareComp :: [Int] -> [Int]
semiPareComp l = [ x `div` 2 | x <- l, even x ]

-- testsemi :: [Int] -> Bool
-- testsemi l = lt == semiPareRecEq l && lt == semiPareComp l
--   where lt = semiPareRecDestr l

{-
double :: Int => Int
triple :: Int => Int
penta :: Int => Int

test x = (double x + triple x ) == ( penta x )
-}

-- L2.2
--cu recursie
inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec _ _ [] = [] --pt lista vida returnez []
-- inIntervalRec a b (h : t) =
--   if a <= h && h <= b
--     then h : (inIntervalRec a b t ) --il pun pe h in t
--     else (inIntervalRec a b t) --nu modific lista

--varianta 2
inIntervalRec a b (h : t)
  | a <= h && h <= b = h : inIntervalRec a b t
  | otherwise = inIntervalRec a b t


inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b l = [ x | x <- l, a <= x && x <= b ]

testinint a b l = inIntervalRec a b l == inIntervalComp a b l

-- L2.3
pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0 --lista vida niciun nr poz
pozitiveRec (h : t)
  | h > 0 = 1 + pozitiveRec t
  | otherwise = pozitiveRec t


pozitiveComp :: [Int] -> Int
pozitiveComp l = sum [ 1 | x <- l, x > 0]
--pt fiecare x > 0 adun 1

testPoz l = pozitiveRec l == pozitiveComp l


-- L2.4
--in p am pozitia
pozitiiImpareAux :: [Int] -> Int -> [Int]
pozitiiImpareAux [] _ = []
pozitiiImpareAux (h : t) p
  | odd h = p : pozitiiImpareAux t (p+1) --creste pozitia
  | otherwise = pozitiiImpareAux t (p+1)

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec l = pozitiiImpareAux l 0 --0 e prima pozitie


pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l =  [ y | (x,y) <- zip l [0..], odd x] --iau pozitia din tuplul (val,poz) unde val este impar

pozitiiImpareComp2 :: [Int] -> [Int]
pozitiiImpareComp2 l = [y | y <- [0..length l-1], let x = l !! y, odd x]



-- L2.5
multDigitsRec :: [Char] -> Int
multDigitsRec [] = 1
multDigitsRec (h : t)
  | isDigit h = digitToInt h * multDigitsRec t
  | otherwise =  multDigitsRec t


multDigitsComp :: String -> Int
multDigitsComp sir = product [digitToInt x | x <- sir,  isDigit x]



-- L2.6
discountRec :: [Float] -> [Float]
discountRec [] = []
discountRec (h : t)
  | h - 0.25 * h < 200 = (h - 0.25 * h) : discountRec t -- daca valoarea redusa cu 25% este mai mica decat
                                                        -- 200, o pun in noua lista
  | otherwise = discountRec t

discountComp :: [Float] -> [Float]
discountComp list = [ x - 0.25 * x | x <- list, x - 0.25 * x < 200]

testDiscount l = discountRec l == discountComp l
