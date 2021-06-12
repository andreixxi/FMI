-- Sa se scrie o functie, care primeste ca parametru un cuvant si  o lista de siruri de caractere si verifica daca toate sirurile din lista care au ca prefix cuvantul dat, au lungime impara.
-- Puteti folosi doar functii din categoriile A, B, C (fara recursie si descrieri de liste)

prefix :: String -> String -> String
prefix _ [] = []
prefix [] _ = []
prefix (x:xs) (y:ys)
  | x == y    = x : prefix xs ys
  | otherwise = []

aux :: String -> String -> Bool
aux str x = if prefix str x == str && odd(length x)
          then True
          else False

ex2 :: String -> [String] -> Bool
ex2 str l = foldr(&&)True [aux str x | x<-l]



data Pair a b = P  a b  deriving Show
data ListPair a = LP [a]  deriving  Show
class ZippingPairs lp where
  zipL :: lp a -> lp b -> lp (Pair a b)
  unzipL ::  lp (Pair a b) -> Pair (lp a) (lp b)
-- Sa se instantieze clasa ZippingPairs pentru tipul de date ListPair astfel incat functia zipL sa functioneze similar cu functia zip (din doua liste face lista cu perechi), iar functia unzipL cu functia unzip (din lista de perechi face pereche din liste).
instance ZippingPairs ListPair where
  zipL (LP []) _ = LP []
  zipL _ (LP []) = LP []
  zipL (LP (x:xs)) (LP (y:ys)) = LP ((P x y) :  aux)
    where
      LP aux = zipL (LP xs) (LP ys)
  unzipL (LP []) = P (LP []) (LP [])
  unzipL (LP ((P a b) : t)) = P (LP (a:aux)) (LP (b:bux))
    where
      P (LP aux) (LP bux) = unzipL (LP t)
