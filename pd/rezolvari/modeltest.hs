--ex 1
sfChr :: Char -> Bool
sfChr x = if elem x ['?', '!', '.', ':'] then True else False

ex1 :: [Char] -> Integer
ex1 [] = 0
ex1 prop = sum $ [if sfChr x == True then 1 else 0 | x <- prop ]
--ex1 "Maria are 110 ani. eu am o papusa? tu ce spui: hai la mare!"

--ex 2
ex2 :: [Int] -> Int -> Bool
ex2 lista n = if length lista == n then True else False

-- chiar daca zice fara recursie/ explicitare liste fa asa si dupa aplici foldr
-- vezi in alte lab legatura dintre recursie si foldr
-- True daca e formata doar din elem pozitive, false altfel
pozitive :: [Int] -> Bool
pozitive list = filter (>=0) list == list

--returneaza liniiile din matrice de lungime n
lungimeN :: [[Int]] -> Int -> [[Int]]
lungimeN matrix  n = filter ((==n) . length) matrix

liniiN :: [[Int]] -> Int -> Bool
liniiN matrice n = foldr (&&) True ( map pozitive (lungimeN matrice n) )


-- ex 3
data Punct = Pt [Int]
            deriving Show
data Arb = Vid | F Int | N Arb Arb
          deriving Show
class ToFromArb a where
      toArb :: a -> Arb
      fromArb :: Arb -> a

instance ToFromArb Punct where
  -- Transformă un punct într-un arbore binar
    toArb (Pt coord) = punctToArb coord
      where
        punctToArb [] = Vid
        punctToArb (x:xs) = N (F x) (punctToArb xs)
    -- Transformă un arbore generat cu funcția precedentă
    -- înapoi într-un punct
    fromArb arb = Pt (punctFromArb arb)
      where
        punctFromArb Vid = []
        punctFromArb (N (F x) b) = x : punctFromArb b
