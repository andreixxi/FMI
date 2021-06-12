--- Monada Maybe


  --- Limbajul si  Interpretorul
type M a = Maybe a

showM :: Show a => M a -> String
showM (Just a) = show a
showM Nothing = "<wrong>"

type Name = String

data Term = Var Name
          | Con Integer
          | Term :+: Term
          | Lam Name Term
          | App Term Term
  deriving (Show)

pgm :: Term
pgm = App
  (Lam "y"
    (App
      (App
        (Lam "f"
          (Lam "y"
            (App (Var "f") (Var "y"))
          )
        )
        (Lam "x"
          (Var "x" :+: Var "y")
        )
      )
      (Con 3)
    )
  )
  (Con 4)

data Value = Num Integer
           | Fun (Value -> M Value)

instance Show Value where
  show (Num x) = show x
  show (Fun _) = "<function>"

type Environment = [(Name, Value)]

lookupM :: Name -> Environment -> M Value
lookupM n env = case lookup n env of
  Just v -> return v
  Nothing -> Nothing

interp :: Term -> Environment -> M Value
interp (Var name) env = case (lookup name env) of
    Just v -> return v
    Nothing -> Nothing
--case verifica rezultatul intors de lookup
interp (Con i) _ = return (Num i) --pt constante
interp (t1 :+: t2) env = do
    v1 <- interp t1 env
    v2 <- interp t2 env
    add v1 v2
interp (Lam name term) env = return $ Fun (\v -> interp term ((name, v) : env))
interp (App t1 t2) env = do
  f <- interp t1 env
  v <- interp t2 env
  app f v

add :: Value -> Value -> M Value
add (Num v1) (Num v2) = return (Num(v1 + v2))
add _ _ = Nothing

app :: Value -> Value -> M Value
app (Fun f) v = f v
app _ _ = Nothing

test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))

-- RULAT urm:
-- test pgm
-- test pgm1
