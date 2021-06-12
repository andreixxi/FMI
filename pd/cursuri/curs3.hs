data Person1 = Person String String Int
data Person = Pers { firstName :: String,
                        lastName :: String,
                        age :: Int
                      }
              deriving (Eq) --derivare automata pt Eq

instance Show Person where
  --show (Pers p n v) = p ++ " " ++ n ++ " are varsta " ++ show v
  show p = "NUME: " ++ lastName p ++ " PRENUME: " ++ firstName p ++ "VARSTA: " ++ show (age p)

nextYear :: Person -> Person
nextYear p = p { age = age p + 1 }

ionel = Pers "Ionel" "Ion" 20
ionel2 = Pers { firstName = "Ionel",
                lastName = "Ion",
              age = 21}
--trb implementate instantele Eq, Show

eMajor :: Person -> Bool
eMajor p = (age p) >= 18


data Nat = Zero | Succ Nat

cinci = Succ (Succ (Succ (Succ (Succ Zero))))

natToInt :: Nat -> Int
natToInt Zero = 0
natToInt (Succ n) = 1 + natToInt n
