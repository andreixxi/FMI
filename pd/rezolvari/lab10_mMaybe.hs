{- Monada Maybe este definita in GHC.Base

instance Monad Maybe where
  return = Just
  Just va  >>= k   = k va
  Nothing >>= _   = Nothing


instance Applicative Maybe where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)

instance Functor Maybe where
  fmap f ma = pure f <*> ma
-}

-- 1. Definiti operatorul de compunere a functiilor îmbogătite
(<=<) :: (a -> Maybe b) -> (c -> Maybe a) -> c -> Maybe b
f <=< g = (\ x -> g x >>= f)

-- 1.1 Creati singuri exemple prin care să întelegeti functionarea acestui operator.
--(<=<) f g 8
f :: Int -> Maybe Int
f x = if x > 0 then Just x
              else Just (-x)
g :: Int -> Maybe Int
g x = if x `mod` 2 == 0 then Just (x `div` 2)
                        else Just (x)


--colegi
f1::String -> Maybe Integer
f2::Integer -> Maybe String
f1 x = Just (read x+2)
f2  = return . show
x = (f1 <=< f2) 3

{-
f1 :: Int -> Maybe Int
f1 0 = Nothing
f1 x = Just $ mod 1000 x
f2 :: Int -> Maybe Int
f2 x = Just $ x * x
(f1 <=< f2) 13 -- apelul pentru testare (155)

f2 :: Int -> Maybe Int
f2 x = Just $ x * x
f3 :: Int -> Maybe Int
f3 x = Just $ abs x
f4 :: Int -> Maybe Int
f4 0 = Nothing
f4 x = Just $ -x
asoc :: (Int -> Maybe Int) -> (Int -> Maybe Int) -> (Int -> Maybe Int) -> Int -> Bool
asoc f g h x =  (h <=< (g <=< f)) x == ((h <=< g) <=< f) x
asocTest :: Int -> Bool
asocTest x = asoc f2 f3 f4 x

quickCheck asocTest -- apelul pentru testare

-}

-- 1.2 Definiti proprietatea
asoc :: (Int -> Maybe Int) -> (Int -> Maybe Int) -> (Int -> Maybe Int) -> Int -> Bool
asoc f g h x = undefined

pos :: Int -> Bool
pos  x = if (x>=0) then True else False

foo :: Maybe Int ->  Maybe Bool
foo  mx =  mx  >>= (\x -> Just (pos x))

-- 2.2 Cititi notatia do din cursul 9. Definiti functia foo folosind notatia do.
-- fooDO (Just 10) --apel
fooDO mx = do
  x <- mx
  Just (pos x)

-- 3. Vrem să definim o functie care adună două valori de tip Maybe Int
-- 3.1 Definiti addM prin orice metodă (de exemplu, folosind sabloane).
addM1 :: Maybe Int -> Maybe Int -> Maybe Int
addM1 Nothing _ = Nothing
addM1 _ Nothing = Nothing
addM1 (Just x) (Just y) = Just (x+y)

-- 3.2 Definiti addM folosind operatii monadice si notatia do.
addM2 :: Maybe Int -> Maybe Int -> Maybe Int
addM2 mx my = do
  x <- mx
  y <- my
  return (x+y)

addM3 mx my = mx >>= (\ x -> my >>= (\ y -> return (x+y)))

--testadd (Just 5) (Just 10)
testadd mx my = addM1 mx my == addM2 mx my && addM1 mx my == addM3 mx my

-- 4. Să se treacă în notatia do urmatoarele functii:
cartesian_product xs ys = xs >>= ( \x -> (ys >>= \y-> return (x,y)))

cartesian_productDO xs ys = do
  x <- xs
  y <- ys
  return (x, y)

--prod (+) [1,2] [3,4]
prod f xs ys = [f x y | x <- xs, y<-ys]
prodDO f xs ys = do
  x <- xs
  y <- ys
  return (f x y)
prodS f xs ys = xs >>= (\x -> ys >>= (\y -> return (f x y)))

myGetLine :: IO String
myGetLine = getChar >>= \x ->
        if x == '\n' then
          return []
        else
          myGetLine >>= \xs -> return (x:xs)
myGetLineDO :: IO String
myGetLineDO = do
  x <- getChar
  if x == '\n'
    then return []
  else
    do
      xs <- myGetLineDO
      return (x:xs)

-- 5. Să se treacă în notatia cu secventiere urmatoarea functie:
prelNo noin = sqrt noin
ioNumber = do
    noin <- readLn :: IO Float -- citesc un float
    putStrLn $ "Intrare\n" ++ (show noin)
    let noout = prelNo noin
    putStrLn $ "Iesire"
    print noout


ioNumberSecv = (readLn :: IO Float)  >>=
            (\
            noin -> putStrLn ( "Intrare\n" ++ (show noin)) >> --fara egal pt ca nu am <- sus
            (let noout = prelNo noin
            in (putStrLn "Iesire" >>
                print noout))
            )

--return 3 :: Maybe Int
-- Just 3
-- (Just 3) >>= (\ x -> if (x>0) then Just (x*x) else Nothing)
-- Just 9
