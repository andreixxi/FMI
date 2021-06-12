import Data.Maybe (fromJust)
import Data.List (nub)

data Fruct = Mar String Bool | Portocala String Int

ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10
listaFructe = [Mar "Ionatan" False,
              Portocala "Sanguinello" 10,
              Portocala "Valencia" 22,
              Mar "Golden Delicious" True,
              Portocala "Sanguinello" 15,
              Portocala "Moro" 12,
              Portocala "Tarocco" 3,
              Portocala "Moro" 12,
              Portocala "Valencia" 2,
              Mar "Golden Delicious" False,
              Mar "Golden" False,
              Mar "Golden" True]

--1 a
ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala s n) = if s `elem` ["Tarocco", "Moro", "Sanguinello"] then True else False
ePortocalaDeSicilia _ = False

test_ePortocalaDeSicilia1 = ePortocalaDeSicilia (Portocala "Moro" 12) == True
test_ePortocalaDeSicilia2 = ePortocalaDeSicilia (Mar "Ionatan" True) == False

--b
felii :: Fruct -> Int
felii (Portocala s i ) = i

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia l = sum [felii x | x<-l, ePortocalaDeSicilia x]

test_nrFeliiSicilia = nrFeliiSicilia listaFructe == 52

--c
eMarVierme :: Fruct -> Bool
eMarVierme (Mar s b) = if b == True then True else False
eMarVierme _ = False

nrMereViermi :: [Fruct] -> Int
nrMereViermi l = sum [1 | x<-l, eMarVierme x]

test_nrMereViermi = nrMereViermi listaFructe == 2

--2
type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa

caine = Caine "zdreanta" "rasa"
pisica = Pisica "pisica"

vorbeste :: Animal -> String
vorbeste (Pisica n) = "meow"
vorbeste (Caine n r) = "woof"

rasa :: Animal -> Maybe String
rasa (Pisica n) = Nothing
rasa (Caine n r) = Just r


type Nume = String
data Prop = Var Nume
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


-- 1. (P ∨ Q) ∧ (P ∧ Q)
p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

-- 2. (P ∨ Q) ∧ (¬P ∧ ¬Q)
p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not (Var "P") :&: Not (Var "Q"))

-- 3. (P ∧ (Q ∨ R)) ∧ ((¬P ∨ ¬Q) ∧ (¬P ∨ ¬R))
p3 :: Prop
p3 = (Var "P" :&: (Var "Q" :|: Var "R")) :&: ((Not (Var "P") :|: Not (Var "Q") :&: (Not(Var "P") :|: Not(Var "R"))))

instance Show Prop where
  show  (Var x) = x
  show F = "F"
  show T = "T"
  show (Not p) = "(~" ++ show p ++ ")"
  show (a :|: b) = "(" ++ show a ++ "|" ++ show b ++ ")"
  show (a :&: b) = "(" ++ show a ++ "&" ++ show b ++")"
  show (a :->: b) = "(" ++ show a ++ "->" ++ show b ++")"
  show (a :<->: b) = "(" ++ show a ++ "<->" ++ show b ++")"

test_ShowProp :: Bool
test_ShowProp = show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"

--ex 3
type Env = [(Nume, Bool)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

impl :: Bool -> Bool -> Bool
impl False _ = True
impl _ x = x

echiv :: Bool -> Bool -> Bool
echiv x y = x==y

eval :: Prop -> Env -> Bool
eval (Var x) e = impureLookup x e
eval F e = False
eval T e = True
eval (Not x) e = not (eval x e)
eval (p :|: q) e = eval p e || eval q e
eval (p :&: q) e = eval p e && eval q e
eval (p :->: q) e = eval p e `impl` eval q e --functii definite de profa
eval (p :<->: q) e = eval p e `echiv` eval q e

test_eval = eval (Var "P" :|: Var "Q") [("P", True), ("Q", False)] == True


-- ex 4
variabile :: Prop -> [Nume]
variabile (Var x) = [x]
variabile T = []
variabile F = []
variabile (Not x) = nub $ variabile x
variabile (p :|: q) = nub $ variabile p ++ variabile q
variabile (p :&: q) = nub $ variabile p ++ variabile q
variabile (p :->: q) = nub $ variabile p ++ variabile q
variabile (p :<->: q) = nub $ variabile p ++ variabile q

test_variabile = variabile (Not (Var "P") :&: Var "Q") == ["P", "Q"]

--5
envs :: [Nume] -> [Env]
envs [] = []
envs [x] = [[(x, True), (x, False)]]
envs (str:xs) =
           let r = envs xs
           in map (\x -> (str, False) : x) r ++ map (\x -> (str, True) : x) r

test_envs = envs ["P", "Q"] ==[ [ ("P",False), ("Q",False)],
                                [ ("P",False), ("Q",True)],
                                [ ("P",True), ("Q",False)],
                                [ ("P",True), ("Q",True)]]

--6
satisfiabila :: Prop -> Bool
satisfiabila p = or $ map (eval p) $ envs $ variabile p

test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q") == True
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P") == False

--7
valida :: Prop -> Bool
valida p = satisfiabila (Not p) == False

test_valida1 = valida (Not (Var "P") :&: Var "Q") == False
test_valida2 = valida (Not (Var "P") :|: Var "P") == True
