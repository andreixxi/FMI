import Data.List
import Data.Maybe

type Name = String

data  Value  =  VBool Bool
        |VInt Int
        |VFun (Value -> Value)
        |VError

data  Hask  = HTrue | HFalse
        |HIf Hask Hask Hask
        |HLit Int
        |Hask :==: Hask
        |Hask :+:  Hask
        |HVar Name
        |HLam Name Hask
        |Hask :$: Hask
        |Hask :*: Hask
        |HLet Name Hask Hask
        deriving (Read, Show)

infix 4 :==:
infixl 6 :+:
infixl 9 :$:
infixl 7 :*:

type  HEnv  =  [(Name, Value)]

showV :: Value -> String
showV (VBool b)   =  show b
showV (VInt i)    =  show i
showV (VFun _)    =  "<function>"
showV (VError)    =  "<error>"

eqV :: Value -> Value -> Bool
eqV (VBool b) (VBool c)    =  b == c
eqV (VInt i) (VInt j)      =  i == j
eqV (VFun _) (VFun _)      =  error "nu pot egala 2 functii"
eqV (VError ) (VError)      =  error "nu pot egala 2 erori"
eqV _ _               = False

hEval :: Hask -> HEnv -> Value
hEval HTrue r         =  VBool True
hEval HFalse r        =  VBool False
hEval (HIf c d e) r   =
  hif (hEval c r) (hEval d r) (hEval e r)
  where  hif (VBool b) v w  =  if b then v else w
         hif _ _ _ = error "conditia trb sa fie bool"
hEval (HLit i) r      =  VInt i
hEval (d :==: e) r     =  heq (hEval d r) (hEval e r)
  where  heq (VInt i) (VInt j) = VBool (i == j)
         heq  _ _ = error "pot egala doar Int"
hEval (d :+: e) r    =  hadd (hEval d r) (hEval e r)
  where  hadd (VInt i) (VInt j) = VInt (i + j)
         hadd _ _  = error "pot aduna doar Int"
hEval (d :*: e) r    =  hmult (hEval d r) (hEval e r)
 where  hmult (VInt i) (VInt j) = VInt (i * j)
        hmult _ _  = error "pot inmulti doar Int"
hEval (HVar x) r      =  fromMaybe (error "nu a fost gasita variabila") (lookup  x r)
hEval (HLam x e) r    =  VFun (\v -> hEval e ((x,v):r))
hEval (d :$: e) r    =  happ (hEval d r) (hEval e r)
  where  happ (VFun f) v  =  f v
         happ _ _ = error "pot aplica DOAR o functie asupra unei valori"
hEval (HLet nume val expr) env =
  let
    v = hEval val env -- calculez valoarea variabilei
    newE = env ++ [(nume, v)]
  in
    hEval expr newE
run :: Hask -> String
run pg = showV (hEval pg [])

--programul h0
h0 =  (HLam "x" (HLam "y" ((HVar "x") :+: (HVar "y"))))
      :$: (HLit 3)
      :$: (HLit 4)

test_h0 = eqV (hEval h0 []) (VInt 7)

--programul h1
h1 = (HLam "x" (HLam "y" ((HVar "x") :+: (HVar "y"))))
      :$: (HLit 10)
      :$: (HLit 4)
test_h1 = eqV (hEval h1 []) (VInt 14)

--programul h2
h2 = HLit 1 :+: HLit 2 :+: HLit 3 -- 1 + 2 + 3

h3 =  HLam "x" (HLit 1 :+: HVar "x")

h4 = h3 :$: h2 -- 1 + 1 + 2 +3

h5 = HLit 3 :*: HLit 2

h1' = HLet "x" (HLit 3) (HLit 4 :+: HVar "x")
