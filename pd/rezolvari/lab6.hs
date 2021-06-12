import Data.List (nub)
import Data.Maybe (fromJust)

--ex 1
data Fruct
    = Mar String Bool
    | Portocala String Int
      --deriving(Show) -- pt a afisa

--instantiere manuala (personalizata)
instance Show Fruct where
  show (Mar str b) = str ++ " " ++ (if b then "are viermi " else "nu are viermi ")
  show (Portocala str i) = str ++ " are " ++ show i ++ " felii"

ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10
listaFructe = [Mar "Ionatan" False, Portocala "Sanguinello" 10, Portocala "Valencia" 22, Mar "Golden Delicious" True, Portocala "Sanguinello" 15, Portocala "Moro" 12, Portocala "Tarocco" 3, Portocala "Moro" 12, Portocala "Valencia" 2, Mar "Golden Delicious" False, Mar "Golden" False, Mar "Golden" True]

--a
ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala soi int) = elem soi ["Sanguinello", "Moro", "Tarocco"]
ePortocalaDeSicilia _ = False

test_ePortocalaDeSicilia1 = ePortocalaDeSicilia (Portocala "Moro" 12) == True
test_ePortocalaDeSicilia2 = ePortocalaDeSicilia (Mar "Ionatan" True) == False

--b
nrFelii :: Fruct -> Int
nrFelii (Portocala s i) = i
nrFelii _ = 0

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia [] = 0
nrFeliiSicilia (x:xs)
  | ePortocalaDeSicilia x = nrFelii x + nrFeliiSicilia xs
  | otherwise = nrFeliiSicilia xs

nrFeliiSicilia2 list = sum $ map(\ (Portocala s i) -> i) (filter ePortocalaDeSicilia list)

nrFeliiSicilia3 list = sum [i | Portocala s i <- list, elem s ["Sanguinello", "Moro", "Tarocco"]]

test_nrFeliiSicilia = nrFeliiSicilia listaFructe == 52

--c
nrMereViermi :: [Fruct] -> Int
nrMereViermi list = length [x | x@(Mar s True) <- list] --x contine merele cu nrMereViermi
--in variabila x duc obiectul (Mar s True) (merele cu viermi)

test_nrMereViermi = nrMereViermi listaFructe == 2


--ex 2
type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa
  deriving Show

caine = Caine "zdreanta" "rasa"
pisica = Pisica "pisica"

--a
vorbeste :: Animal -> String
vorbeste (Pisica _) = "meow"
vorbeste (Caine _ _) = "woof"

--b
--pt a returna elemente de tip maybe fie just ceva, fie nothing
rasa :: Animal -> Maybe String
rasa (Caine _ r) = Just r
rasa _ = Nothing


--3
type Nume = String
data Prop
    = Var Nume
    | F
    | T
    | Not Prop
    | Prop :|: Prop
    | Prop :&: Prop
    | Prop :->: Prop
    | Prop :<->: Prop
    deriving (Eq, Read)
infixr 2 :|:
infixr 3 :&:

--ex 1
-- (P ∨ Q) ∧ (P ∧ Q)
p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

-- (P ∨ Q) ∧ (¬P ∧ ¬Q)
p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not (Var "P") :|: Not (Var "Q"))

-- (P ∧ (Q ∨ R)) ∧ ((¬P ∨ ¬Q) ∧ (¬P ∨ ¬R))
p3 :: Prop
p3 = (Var "P" :&: (Var "Q" :|: Var "R")) :&: (((Not (Var "P") :|: Not (Var "Q")) :&: (Not (Var "P") :|: Not (Var "R"))))


-- ex 2
instance Show Prop where
    show (Var p) = p
    show (Not p) = "(~" ++ show p ++ ")"
    show (T) = "True"
    show (F) = "False"
    show (p1 :|: p2) = "(" ++ show p1 ++ "|" ++ show p2 ++ ")"
    show (p1 :&: p2) = "(" ++ show p1 ++ "&" ++ show p2 ++ ")"
    show (p1 :->: p2) = "(" ++ show p1 ++ "->" ++ show p2 ++ ")"
    show (p1 :<->: p2) = "(" ++ show p1 ++ "<->" ++ show p2 ++ ")"

test_ShowProp :: Bool
test_ShowProp = show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"


----- ex 3
-- Definit, i o funct, ie eval care dat fiind o expresie logică s, i un mediu de evaluare,
-- calculează valoarea de adevăr a expresiei.
type Env = [(Nume, Bool)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

impl :: Bool -> Bool -> Bool
impl False _ = True
impl _ x = x

echiv :: Bool -> Bool -> Bool
echiv x y = x==y

eval :: Prop -> Env -> Bool
eval T e = True
eval F e = False
eval (Var p) e = impureLookup p e -- cauta valoarea variabilei p in e
eval (Not p) e = not (eval p e)
eval (p :|: q) e = eval p e || eval q e
eval (p :&: q) e = eval p e && eval q e
eval (p :->: q) e = eval p e `impl` eval q e --functii definite de profa
eval (p :<->: q) e = eval p e `echiv` eval q e

test_eval = eval  (Var "P" :|: Var "Q") [("P", True), ("Q", False)] == True


--4 Definiti o functie variabile care colectează lista tuturor variabilelor dintr-o
-- formulă.
variabile :: Prop -> [Nume]
variabile (Var p) = [p]
variabile (Not p) = nub $ variabile p
variabile (p :&: q) = nub $ variabile p ++ variabile q
variabile (p :|: q) = nub $ variabile p ++ variabile q
variabile (p :->: q) = nub $ variabile p ++ variabile q
variabile (p :<->: q) = nub $ variabile p ++ variabile q
variabile _ = [] -- T si F

test_variabile = variabile (Not (Var "P") :&: Var "Q") == ["P", "Q"]


--5.  Dată fiind o listă de nume, definiti toate atribuirile de valori de adevăr posibile
-- pentru ea.
envs :: [Nume] -> [Env]
envs [] = []
envs [x] = [[(x, False)], [(x, True)]] --pt o lista formata dintr un sng element
envs (str:xs) = let r = envs xs in map (\x -> (str, False) : x) r ++ map (\x -> (str, True) : x) r

test_envs =
      envs ["P", "Q"]
      ==
      [ [ ("P",False)
        , ("Q",False)
        ]
      , [ ("P",False)
        , ("Q",True)
        ]
      , [ ("P",True)
        , ("Q",False)
        ]
      , [ ("P",True)
        , ("Q",True)
        ]
      ]

--6 Definit, i o funct, ie satisfiabila care dată fiind o Propozit, ie verifică dacă aceasta
-- este satisfiabilă.
satisfiabila :: Prop -> Bool
satisfiabila p = or $ map (eval p) $ envs $ variabile p
--envs $ variabile p -> lista de forma [[("P",False),("Q",False)],[("P",False),("Q",True)],[("P",True),("Q",False)],[("P",True),("Q",True)]]
-- map (eval p) $ envs $ variabile p => [False,False,False,True]
-- aplic sau pe valorile de adevar

test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q") == True
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P") == False


-- 7
-- O propozitie este validă dacă se evaluează la True pentru orice interpretare a
-- varibilelor. O forumare echivalenta este aceea că o propozitie este validă dacă
-- negatia ei este nesatisfiabilă.
valida :: Prop -> Bool
valida p = satisfiabila (Not p) == False

test_valida1 = valida (Not (Var "P") :&: Var "Q") == False
test_valida2 = valida (Not (Var "P") :|: Var "P") == True
