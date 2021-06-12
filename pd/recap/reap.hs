data Punct = Punct [Int]
--  deriving (Show, Eq)

instance Show Punct where
  show (Punct[]) = ""
  show (Punct (x:xs)) = show x ++ " " ++ show (Punct xs)

data Arb = Vid | F Int | N Arb Arb
  deriving Show

(*++*) :: Punct -> Punct -> Punct
(Punct l1) *++* (Punct l2) = Punct (l1 ++ l2)

class ToFromArb a where
  toArb :: a -> Arb
  fromArb :: Arb -> a
  f :: a -> a
  f x = fromArb(toArb x)

instance ToFromArb Punct where
  toArb (Punct []) = Vid
  toArb (Punct (x:xs)) = N (F x) (toArb (Punct xs))
  fromArb Vid = Punct []
  fromArb (F x) = Punct [x]
  fromArb (N st dr) = Punct (l1 ++ l2)
    where
      Punct l1 = fromArb st
      Punct l2 = fromArb dr
  --fromArb (N st dr) = (fromArb st) *++* (fromArb dr)

-- Punct[1,2,3,4] --toArb
--   N (F 1) (N (F 2) (N (F 3) (N (F 4) (Vid))))
