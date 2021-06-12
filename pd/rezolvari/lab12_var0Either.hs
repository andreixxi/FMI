--- Monada Either

-- data Either a b = Left a | Right b

type M a = Either String a

showM :: Show a => M a -> String
showM (Left s) = "Error: " ++ s
showM (Right a) = "Success: " ++ show a

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
  Nothing -> Left ("unbound variable:" ++ n)

interp :: Term -> Environment -> M Value
interp (Var name) env = case (lookup name env) of
    Just v -> return v
    Nothing -> Left ("unbound variable:" ++ name)
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
add v1 v2 = Left("should be numbers: " ++ show v1 ++ ", " ++ show v2)

app :: Value -> Value -> M Value
app (Fun f) v = f v
app f _ = Left("should be function: " ++ show f)

test :: Term -> String
test t = showM $ interp t []

pgm1:: Term
pgm1 = App
          (Lam "x" ((Var "x") :+: (Var "x")))
          ((Con 10) :+:  (Con 11))

pgm2 :: Term
pgm2 = App (Var "x") ((Con 10) :+: (Con 11))
-- RULAT urm:
-- test pgm    = "Success: 7"
-- test pgm1   = "Success: 42"
-- interp pgm []  = Right 7
-- interp (App (Con 7) (Con 2)) []    = Left "should be function: 7"
-- test pgm2    = "Error: unbound variable:x"
