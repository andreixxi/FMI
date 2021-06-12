type Name = String
newtype NewName = N String

-- instance Show Name where
--   show s = "*" ++ s ++ "*"

instance Show NewName where
  show (N s) = "*" ++ s ++ "*"

type Key = Int
type Value = String
newtype PairList = PairList {getPairList :: [(Key, Value)]}
instance Show PairList where
  show (PairList p) = "PairList" ++ (show p)

class Collection c where --primele 6 trb declarate obligatoriu
  cempty :: c --colectia vida
  csingleton :: Key -> Value -> c
  cinsert :: Key -> Value -> c -> c
  cdelete :: Key -> c -> c
  clookup :: Key -> c -> Maybe Value -- poate nu gaseste cheia
  ctoList :: c-> [(Key, Value)]
  --operatii derivate
  ckeys :: c -> [Key]
  cvalues :: c -> [Value]
  cfromList :: [(Key, Value)] -> c

  ckeys c = [fst x | x <- ctoList c]
  cvalues c = [snd x | x <- ctoList c]
  cfromList [] = cempty
  cfromList((k,v) : xs) = cinsert k v (cfromList xs)

--la instanta scriu corpul functiilor din clasa
instance Collection PairList where
  cempty = PairList []
  csingleton k v = PairList [(k, v)]
  cinsert k v (PairList l) = PairList $ (k,v) : filter ((/= k).fst) l --concatenare, inserez (k,v) in pairlist daca nu se afla in lista
  cdelete k (PairList l) = PairList $ filter ((/= k).fst) l --returnez lista FARA (k,v)
  clookup k = lookup k . getPairList
  ctoList = getPairList


data SearchTree = Empty | Node SearchTree --elem chei mai mici
                               Key        --cheia
                               (Maybe Value) --valoarea
                               SearchTree --elem chei mai mari
                    deriving Show
instance Collection SearchTree where
  cempty = Empty
  csingleton k v = Node Empty k (Just v) Empty
  cinsert k v = go --returnez un arbore, adica Node t1 k v t2
    where
      go Empty = csingleton k v
      go (Node t1 k1 v1 t2)
        | k == k1 = Node t1 k (Just v) t2 -- se repeta cheia, nu inserez
        | k < k1 = Node (go t1) k1 v1 t2
        | otherwise = Node t1 k1 v1 (go t2)
  cdelete k = go --returnez arbore
    where
      go Empty = Empty
      go (Node t1 k1 v1 t2)
        | k == k1 = Node t1 k Nothing t2
        | k < k1 = Node (go t1) k1 v1 t2
        | otherwise = Node t1 k1 v1 (go t2)
  clookup k = go --returnez valoarea daca exista
    where
      go Empty = Nothing
      go (Node t1 k1 v1 t2)
        | k == k1 = v1
        | k < k1 = go t1
        | otherwise = go t2
  ctoList Empty = [] -- pt arbore vid -> lista vida
  ctoList (Node t1 k v t2) = ctoList t1 ++ embed k v ++ ctoList t2
    where
      embed k (Just v) = [(k, v)]
      embed _ _ = []



-- data Prog = On Instr
-- data Instr = Off | Expr :> Instr
-- data Expr = Mem | V Int | Expr :+ Expr  --mem ultima val calculata
--
-- type Env = Int --vloarea celulei de memorie
-- type DomProg = [Int]
-- type DomInstr = Int -> [Int]
-- type DomExpr = Int -> Int
--
-- prog :: Prog -> DomProg
-- stmt :: Instr -> DomInstr
-- expr :: Expr -> DomExpr
-- prog (On s) = stmt s 0
-- stmt ( e :> s) m = let v = expr e
--                    in (v : (stmt s v))
-- stmt Off _ = []
-- expr (e1 :+ e2) m = (expr e1 m) + (expr e2 m)
-- expr (V n) _ = n
-- expr Mem m = m


data Hask = HTrue
          | HFalse
          | HLit Int
          | HIf Hask Hask Hask
          | Hask :==: Hask
          | Hask :+: Hask
          | HVar Name
          | HLam Name Hask
          | Hask :$: Hask
  deriving (Read, Show)
infix 4 :==:
infixl 6 :+:
infixl 9 :$:
