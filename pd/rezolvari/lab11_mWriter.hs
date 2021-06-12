
--- Monada Writer

newtype WriterS a = Writer { runWriter :: (a, String) }


instance  Monad WriterS where
  return va = Writer (va, "")
  --(>>=) :: WriterS a -> (a -> WriterS b) -> WriterS b
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)
-- (>>) :: m a -> m b -> m b
-- ma >> mb = ma >>= \_ -> mb

instance  Applicative WriterS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance  Functor WriterS where
  fmap f ma = pure f <*> ma

tell :: String -> WriterS ()
tell log = Writer ((), log)

-- 1.1 Definiti functiile logIncrement si logIncrement2 din cursul 9 si testati
-- functionarea lor.
logIncrement :: Int  -> WriterS Int
logIncrement x = do
  tell(" increment " ++ show x)
  return (x + 1)
  -- tell("increment " ++ show x) >> return (x+1)
  -- Writer (x+1, "Called increment with argument " ++ show x ++ "\n")
--apel: runWriter $ logIncrement 3

logIncrement2 :: Int -> WriterS Int
logIncrement2 x = do
  y <- logIncrement x
  logIncrement y
  -- logIncrement x >>= \y -> logIncrement y

logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x 0 =  return x
logIncrementN x n = do
  y <- logIncrement x
  logIncrementN y (n-1)
--apel: runWriter $ logIncrementN 3 4
