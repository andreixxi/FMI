
---Monada Reader


newtype Reader env a = Reader { runReader :: env -> a }


instance Monad (Reader env) where
  return x = Reader (\_ -> x)
  ma >>= k = Reader f
    where f env = let a = runReader ma env
                  in  runReader (k a) env



instance Applicative (Reader env) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance Functor (Reader env) where
  fmap f ma = pure f <*> ma


ask :: Reader env env
ask = Reader id

local :: (r -> r) -> Reader r a -> Reader r a
local f ma = Reader $ (\r -> (runReader ma)(f r))

-- Reader Person String
--ex 1
data Person = Person { name :: String, age :: Int }

-- 1.1 Definiti functiile
showPersonN :: Person -> String
showPersonN p = "NAME: " ++ (name p)
--showPersonN $ Person "ada" 20

showPersonA :: Person -> String
showPersonA p = "AGE: " ++ show (age p)
-- showPersonA $ Person "ada" 20

-- 1.2 Combinând functiile definite la punctul 1.1, definiti functia
showPerson :: Person -> String
showPerson p = showPersonN p ++ ", " ++ showPersonA p
-- showPerson $ Person "ada" 20

-- 1.3 Folosind monada Reader, definiti variante monadice pentru cele trei functii
-- definite anterior. Variantele monadice vor avea tipul:

--apel: runReader mshowPersonN $ Person "ada" 20
mshowPersonN ::  Reader Person String
mshowPersonN = do
  p <- ask
  return (showPersonN p)

--apel: runReader mshowPersonA $ Person "ada" 20
mshowPersonA ::  Reader Person String
mshowPersonA = do
  p <- ask
  return (showPersonA p)

--apel: runReader mshowPerson $ Person "ada" 20
mshowPerson :: Reader Person String
mshowPerson = do
  p <- ask
  return (showPerson p)
