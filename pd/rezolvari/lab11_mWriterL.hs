
--- Monada Writer

-- 2. Modificati definitia monadei WriterS astfel încât să producă lista mesajelor
-- logate si nu concatenarea lor. Pentru a evita posibile confuzii, lucrati în fisierul
-- mWriterL.hs . Definiti functia logIncrementN în acest context.

newtype WriterLS a = Writer { runWriter :: (a, [String]) }


instance  Monad WriterLS where
  return va = Writer (va, [])
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)


instance  Applicative WriterLS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance  Functor WriterLS where
  fmap f ma = pure f <*> ma



tell :: String -> WriterLS ()
tell log = Writer ((), [log])

--apel: runWriter $ logIncrement 2
logIncrement :: Int  -> WriterLS Int
logIncrement x = do
  tell("increment: " ++ show x)
  return (x + 1)

--apel: runWriter $ logIncrement2 2
logIncrement2 :: Int -> WriterLS Int
logIncrement2 x = do
  y <- logIncrement x
  logIncrement y

-- apel: runWriter $ logIncrementN 2 4
logIncrementN :: Int -> Int -> WriterLS Int
logIncrementN x 0 = return x
logIncrementN x n = do
  y <- logIncrement x
  logIncrementN y (n-1)

--Functia map în context monadic
isPos :: Int -> WriterLS Bool
isPos x = if (x>= 0) then (Writer (True, ["poz"])) else (Writer (False, ["neg"]))
--apel: map runWriter $ map isPos [1,-2,3]
--rez: [(True,["poz"]),(False,["neg"]),(True,["poz"])]

-- 4. Definiti o functie care se comportă similar cu map, dar efectul final este
-- înlăntuirea efectelor. Signatura acestei functii este:
conc :: (a, [b]) -> ([a], [b]) -> ([a], [b])
conc (a, b) (sa, sb) = (a:sa, b ++ sb)

mapWriterLS :: (a -> WriterLS b) -> [a] -> WriterLS [b]
mapWriterLS f xs = Writer $ foldr conc ([], []) $ map (runWriter . f) xs
--apel: runWriter $ mapWriterLS isPos [1,-2,3]
