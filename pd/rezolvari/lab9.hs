import Data.Char
import Data.List
-- import Data.List.Split
-- exemplul 1, rulez 'ioString' in terminal, apoi introduc un cuvant si ENTER
prelStr strin = map toUpper strin
ioString = do
  putStrLn $ "Introdu un cuvant\n"
  strin <- getLine
  putStrLn $ "Intrare\n" ++ strin
  let strout = prelStr strin
  putStrLn $ "Iesire\n" ++ strout

-- exemplul 2, rulez 'ioNumber' in terminal, apoi introduc un numar si ENTER
prelNo noin = sqrt noin
ioNumber = do
  putStrLn $ "Introdu un numar\n"
  noin <- readLn :: IO Double
  putStrLn $ "Intrare\n" ++ (show noin)
  let noout = prelNo noin
  putStrLn $ "Iesire"
  print noout

-- exemplul 3
inoutFile = do
  sin <- readFile "C:/Users/andrei/Desktop/an3/pd/rezolvari/Input.txt"
  putStrLn $ "Intrare\n" ++ sin
  let sout = prelStr sin
  putStrLn $ "Iesire\n" ++ sout
  writeFile "C:/Users/andrei/Desktop/an3/pd/rezolvari/Output.txt" sout

-- Exercitiul 1
-- Scrieti un program care citeste de la tastatură un număr n si o secventă de n
-- persoane, pentru fiecare persoană citind numele si varsta. Programul trebuie sa
-- afiseze persoana (sau persoanele) cu varsta cea mai mare. Presupunem ca varsta
-- este exprimata printr-un Int.
-- ex1 :: IO ()
-- ex1 = do
--   putStrLn $ "n=\n"
--   noin <- readLn :: IO Int -- citesc un int
--   let i = 0
--   let persoane = []
--   let varste = []
--   let vmax = 0
--   if i < n then do
--     nume <- readLn :: Io String
--     varsta <- readLn :: IO Int
--     if varsta > vmax then do -- parcurg pt a afla varsta maxima
--       varste ++ [varsta]
--       persoane ++ [nume]
--       vmax <- varsta
--     else do
--       vmax <- vmax
--     i += 1
--   else do
--     i <- 0
--     let persoaneBatrane = []
--     if i < n then
--       if varste[i] == vmax then
--         persoaneBatrane ++ persoane[i]
--       else
--         persoaneBatrane
--       i += 1
--     else do
--       putStrLn $ "Varsta maxima este" ++ (show vmax)
--       if length persoaneBatrane == 1
--         then do putStrLn $ "Cea mai batrana persoana este: " ++ (show persoaneBatrane)
--       else do
--         putStrLn $ "Cele mai batrane persoane sunt: " ++ (show persoaneBatrane)

-- Exercitiul 1
-- Scrieti un program care citeste de la tastatură un număr n si o secventă de n
-- persoane, pentru fiecare persoană citind numele si varsta. Programul trebuie sa
-- afiseze persoana (sau persoanele) cu varsta cea mai mare. Presupunem ca varsta
-- este exprimata printr-un Int.
readOne :: IO (String, Integer)
readOne = do
    --putStrLn $ "introdu numele"
    name <- getLine
    --putStrLn $ "introdu varsta"
    age  <- readLn :: IO Integer
    return (name, age)

maxAll :: Integer -> IO (String, Integer)
maxAll n
    | n < 0 = return ("Nobody", 0)
    | n == 1 = readOne
    | otherwise = do
        (name1, age1) <- maxAll (n-1)
        (name2, age2) <- readOne
        if age2 > age1
          then return (name2, age2)
        else return (name1, age1)

ex1 :: IO ()
ex1 = do
    putStrLn $ "N ="
    n <- readLn :: IO Integer
    if n <= 0 then putStrLn "Numarul N este prea mic"
    else do
        putStrLn "Numarul N este bun"
        (name, age) <- maxAll n
        putStrLn ("Cel mai in varsta este " ++ name ++ " (" ++ show age ++ " ani).")


-- Exercitiul 2
-- Aceeasi cerintă ca mai sus, dar datele se citesc dintr-un fisier de intrare, în care
-- fiecare linie contine informatia asociată unei persoane, numele si varsta fiind
-- separate prin vigulă (vedeti fisierul ex2.in).
-- Indicatie: pentru a separa numele de varsta puteti folosi functia splitOn din
-- modulul Data.List.Split.

s `splitOn` t
  | t == "" = [""]
  |s`isPrefixOf` t = "" : splitOn s (drop (length s) t)
  | 1 > 0 = (a:c) : d
    where
      a:b = t
      c:d = s `splitOn`b

citirePersoane :: IO ()
citirePersoane = do
  input <- readFile "C:/Users/andrei/Desktop/an3/pd/rezolvari/ex2.in"
  let linii = lines input
  let numeL = []
  let varstaL = []
  forM linii $ \linie -> do --pt feicare linie
    let [nume, varsta] = splitOn "," linie --separ dupa virgula
    numeL ++ [nume]
    varstaL ++ [varsta]
  return $ (numeL, varstaL)

ex2 :: IO ()
ex2 = do
  (name, age) <- citirePersoane
  putStrLn ("Cel mai in varsta este " ++ name )
