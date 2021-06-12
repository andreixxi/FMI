data Expr = X | Y | Z
            | Plus Expr Expr
            | Ori Expr Expr

newtype Reader a = Reader {runReader :: Int -> Int -> Int -> a}

instance Monad (Reader Int) where
  return x = Reader (\_ -> x)
  ma >>= k = Reader f
    where f env = let a = runReader ma env
                  in  runReader (k a) env

instance Applicative (Reader Int) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor (Reader Int) where
  fmap f ma = pure f <*> ma

ask :: Reader env env
ask = Reader id

eval :: Expr -> Reader Int
eval (X) = return X
eval (Y) = return Y
eval (Z) = return Z
eval (Plus e1 e2) = do
  val1 <- eval e1
  val2 <- eval e2
  return (val1 + val2)
eval (Ori e1 e2) = do
  val1 <- eval e1
  val2 <- eval e2
  return (val1 * val2)
