import Data.Char
--https://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems
--model test
--1. scrieti o functie care numara cate propozitii sunt intr-un text dat. puteti scrie o functie auxiliara sfChr care verifica daca un caracter e sfarsit de propozitie. consideram semne de sfarsit de propozitie: '.', '?', '!', ':'. puteti folosi doar recursie, functii din categoria A si sfChr
sfChr :: Char -> Bool
sfChr x = if elem x ['?', '!', '.', ':'] then True else False

ex1 :: [Char] -> Integer
ex1 [] = 0
ex1 prop = sum $ [if sfChr x == True then 1 else 0 | x <- prop ]
--ex1 "Maria are 110 ani. eu am o papusa? tu ce spui: hai la mare!"

--2. scrieti o functie liniiN care are ca parametru o matrice de numere intregi [[Int]] si un nr intreg n si verifica daca toate liniile de lungime n din matirce au doar element strict pozitive. puteti folosi functii din categ A B C (fara recursie, descrieri de liste si and).
pozitive :: [Int] -> Bool
pozitive list = filter (>=0) list == list

--returneaza liniiile din matrice de lungime n
lungimeN :: [[Int]] -> Int -> [[Int]]
lungimeN matrix  n = filter ((==n) . length) matrix

liniiN :: [[Int]] -> Int -> Bool
liniiN matrice n = foldr (&&) True ( map pozitive (lungimeN matrice n) )

--3
{-
data Punct = Pt [ Int ]
            deriving Show
data Arb = Vid | F Int | N Arb Arb
            deriving Show
class ToFromArb a where
      toArb :: a -> Arb
      fromArb :: Arb -> a
--Sa se scrie o instantta a clasei ToFromArb pentru !!tipul de date Punct!! astfel incat lista coordonatelor punctului sa coincida cu frontiera arborelui.
instance ToFromArb Punct where
  --punct in arbore
  toArb (Pt x) = ptToArb x
    where
      ptToArb [] = Vid
      ptToArb (h:t) = N (F h) (ptToArb t)
  --arbore in punct
  fromArb arb = Pt (ptFromArb arb)
    where
      ptFromArb Vid = []
      ptFromArb (F n) = [n]
      ptFromArb (N a1 a2) = ptFromArb a1 ++ ptFromArb a2
-}
-------------
--4
data Pereche = P Int Int
              deriving Show
data Lista = L [Pereche]
            deriving Show
data Expresie = I Int | Add Expresie Expresie | Mul Expresie Expresie
  --deriving Show
class ClassExp m where
  toExp :: m -> Expresie
--a) sa se scrie o instanta a clasei ClassExp pentru tipul Lista ai functia toExp sa transforme o lista de perechi astfel: o pereche devine inmultirea dintre cele doua elemente, iar intre elementele listei se aplica operatia de adunare. pentru lista vida puteti considera ca expresia corespunzatoare este I 0.
instance ClassExp Lista where
  toExp (L l) = listToExp l
    where
      listToExp [] = I 0
      listToExp [P x y] = Mul (I x) (I y)
      listToExp (P x y : t) = Add (Mul (I x) (I y)) (listToExp t)

--b) sa se faca o instanta pentru clasa Show pentru tipul Expresie ai sa se faca afisarea folosind simbolurile * si + pentru inmultire si adunare, iar la expresiile numerice afisarea sa nu contina constructorul I.
instance Show Expresie where
  show (I x) = show x
  show (Add e1 e2) = "(" ++ show e1 ++ "+" ++ show e2 ++ ")"
  show (Mul e1 e2) = "(" ++ show e1 ++ "*" ++ show e2 ++ ")"

-------------
--5
data Pereche2 a b = MyP a b deriving Show
data ListaP a = MyL [a] deriving Show
class MyMapping m where
  mymap :: (Pereche2 a b -> Pereche2 b a) -> m (Pereche2 a b) -> m (Pereche2 b a)
  myfilter :: (Pereche2 a b -> Bool) -> m (Pereche2 a b) -> m (Pereche2 a b)
--sa se instantieze clasa MyMapping pentru tipul de date ListaP, ai mymap sa functioneze similar cu map (pe liste) si myfilter cu filter(pe liste)
instance MyMapping ListaP where
  mymap func (MyL []) = MyL []
  mymap func (MyL (h : t)) = MyL ((func h) : aux)
    where
      MyL aux = mymap func (MyL t)

  myfilter cond (MyL []) = MyL []
  myfilter cond (MyL (h : t))
      | cond h =  MyL(h : aux)
      | otherwise = MyL aux
        where
          MyL aux = myfilter cond (MyL t)
lp :: ListaP (Pereche2 Int Char)
lp = MyL[MyP 97 'a', MyP 3 'b', MyP 100 'd']

--------------
--6
-- sa se scrie o functie care pentru o lista de numere intregi afiseaza suma dintre diferenta dintre doua elemente consecutive daca ambele numere sunt divizibile cu 3 sau produsul dintre ele, altfel.(fara recursie, descrieri de liste si functia sum -> foldr map)
calc :: (Int, Int) -> Int
calc (x, y)
  | x `mod` 3 == 0 && y `mod` 3 == 0 = x - y
  | otherwise = x * y
rez, rezRec, rezComp :: [Int] -> Int
rez l = foldr(+) 0 $ map calc (zip l (tail l))
rezRec [] = 0
rezRec [x, y] = calc (x, y)
rezRec (x:y:xs) = calc(x, y) + rezRec (y:xs)
rezComp l = sum [calc (x, y)  | (x, y) <- zip l (tail l)]

-------
--7.
--sa se scrie o functie care primeste ca parametru o matrice de numere intregi si un numar n intreg si verifica daca liniile care au doar elemente pare au lungimea mai mare decat n.
andV :: [Bool] -> Bool
andV l = foldr (&&) True l
allEven :: [Int] -> Bool
allEven l =  andV $ map even l
f7 :: [[Int]] -> Int -> Bool
f7 l n = andV $ map (\v -> not (allEven v) || (length v) > n) l

--8
-- sa se scrie o functie care primeste ca argumente doua siruri de caractere si afiseaza cel mai lung prefix comun
f8 :: String -> String -> String
f8 s1 s2 = [x | (x, y) <- zip s1 s2 , x == y]
-- = map (\(x, _) -> x) $ takeWhile (\(c1, c2) -> c1 == c2) $ zip s1 s2


--9
do_it_recursiv (a:[]) = a : []
do_it_recursiv ((x1,y1):t) = if y2 == y1
                             then do_it_recursiv ((x1 + x2,y1) : (tail t))
                             else (x1,y1) : do_it_recursiv t
                             where
                               (x2,y2) = head t

encode_modified l = do_it_recursiv (map (\x -> (1, toUpper x) ) l )

pack :: String -> [String]
pack [] = []
pack [x] = [[x]]
pack (x:xs) = if x `elem` (head (pack xs))
              then (x:(head (pack xs))):(tail (pack xs))
              else [x]:(pack xs)

-- Funcție care elimină literele duplicate consecutive dintr-un șir.
-- Doar recursie și funcții din categoria A.
elimDuplicCons :: String -> String
elimDuplicCons "" = ""
elimDuplicCons [caracter] = [caracter]
elimDuplicCons (a:b:c) =
    if a == b then
        -- Sărim peste `b` și aplicăm recursiv funcția
        elimDuplicCons (a : c)
    else
        -- Punem `a` (care știm că e distinct), și continuăm recursiv
        -- de la al doilea caracter
        a : elimDuplicCons (b : c)

-- Pentru două list date, calculează suma produselor de forma x_i^2 * y_i^2,
-- cu x_i din x și y_i din y.
-- Pentru liste de lungimi diferite, aruncă o eroare.
-- Doar funcții de nivel înalt.
sumaProdPatrat :: [Int] -> [Int] -> Int
sumaProdPatrat x y =
    if length x /= length y then
        error "Listele au lungimi diferite"
    else
        let
            x2 = map (^2) x
            y2 = map (^2) y
            perechi = zip x2 y2
            produse = map (\(a, b) -> a * b) perechi
        in
            foldr (+) 0 produse

{-Sa se scrie o functie care pentru un sir de caractere calculeaza suma codificarilor caracterelor din sir folosind urmatoarea codificare:

	Caracterul e vocala => 1

	Caracterul e consoana => 2

	Caracterul e cifra => 3

	Orice altceva => -1?-}
chr2 :: Char -> Int
chr2 char
    | elem char "1234567890"  = 3
    | elem char "aeiouAEIOU" = 1
    | elem char "qwrtypsdfghjklzxcvbnmQWRTYPSDFGHJKLZXCVBNM" = 2
    | otherwise = -1

codifica :: [Char] -> Int
codifica prop = sum [ chr2 x | x <- prop]

charSum :: String -> Int
charSum [] = 0
charSum (h:t)
    | (toLower h) `elem` "aeiou" = 1 + charSum t
    | h `elem` ['0'..'9'] = 3 + charSum t
    | (toLower h) `elem` ['a'..'z'] = 2 + charSum t
    | otherwise = -1 + charSum t



--Sa se scrie o functie care pentru o lista de nr intregi l si 2 numere x si y afiseaza lista formata din listele de divizori ale pozitiilor elementelor din intervalul [x,y]. Pozitiile incep de la 0.
factori :: Integral a => a -> [a]
factori n = [ x | x <- [1..n], n `mod` x == 0 ]

func :: [Integer] -> Integer -> Integer -> [[Integer]]
func [] _ _= [[]]
func l x y = [ factori poz | (el,poz) <- zip l [0..], el>=x && el<=y ]


data Enciclopedie = Intrare String String| Lista String [Enciclopedie]
   deriving Show
lenEnciclopedie :: Enciclopedie -> Int
lenEnciclopedie (Lista str []) = 0
lenEnciclopedie (Lista str ((Intrare _ _ ):t)) = 1 + (lenEnciclopedie (Lista str t))
lenEnciclopedie (Lista str ((Lista innerStr innerList ):t)) = lenEnciclopedie (Lista innerStr innerList)  + lenEnciclopedie (Lista str t)
enc1 = Lista "animal"[Lista "mamifer"[Intrare "elefant" "acesta e un elefant", Intrare "caine" "acesta este un caine", Intrare "pisica" "aceasta este o pisica"], Intrare "animale domestice" "definitie"]

instance Eq Enciclopedie where
    (==) = eqEnciclopedie
eqEnciclopedie :: Enciclopedie -> Enciclopedie -> Bool
eqEnciclopedie (Intrare x1 x2) (Intrare y1 y2) = [toLower a | a <- x1] == [toLower a | a <-y1] && x2 == y2
eqEnciclopedie (Lista str1 enc1) (Lista str2 enc2) = [toLower a | a <- str1] == [toLower a | a <- str2] && enc1 == enc2
