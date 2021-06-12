import Data.List

power :: Maybe Int -> Int -> Int
power Nothing n = 2 ^ n
power (Just m) n = m ^ n

divide :: Int -> Int -> Maybe Int
divide n 0 = Nothing
divide n m = Just (n `div` m)

right :: Int -> Int -> Int
right n m = case divide n m of
              Nothing -> 3
              Just r -> r + 3

-- data Either a b = Left a | Right b
myList :: [Either Int String]
myList = [Left 4, Left 1, Right "hello", Left 2, Right " ", Right "world", Left 17]

addInts, addInts' :: [Either Int String] -> Int
addInts [] = 0
addInts (Left x : xs) = x + addInts xs
addInts (Right x : xs) = addInts xs
addInts' l = sum[x | Left x <-l]

addStrs, addStrs' :: [Either Int String] -> String
addStrs [] = ""
addStrs(Left x : xs) = addStrs xs
addStrs(Right x : xs) = x ++ addStrs xs
addStrs' l = concat[x | Right x <- l]

type Name = String
data Prop = Var Name
            | F
            | T
            | Not Prop
            | Prop :|: Prop
            | Prop :&: Prop
            deriving (Eq, Ord)
type Names = [Name]
type Env = [(Name, Bool)] --evaluare variabile

showProp :: Prop -> String
showProp (Var x) = x
showProp F = "False"
showProp T = "True"
showProp (Not p) = "~(" ++ showProp p ++ ")"
showProp (p1 :|: p2) = "(" ++ showProp p1 ++ "|" ++ showProp p2 ++")"
showProp (p1 :&: p2) = "(" ++ showProp p1 ++ "&" ++ showProp p2 ++ ")"

prop :: Prop
prop = (Var "a" :&: Not (Var "b"))

names :: Prop -> Names
names (Var x) = [x]
names F = []
names T = []
names (Not p) = names p
names (p1 :|: p2) = nub (names p1 ++ names p2)
names (p1 :&: p2) = nub (names p1 ++ names p2)

lookUp :: Eq a => [(a, b)] -> a -> b
lookUp env cautat = head [bool | (val, bool) <- env, val == cautat]

eval :: Env -> Prop -> Bool
eval e (Var x) = lookUp e x
eval e F = False
eval e T = True
eval e (Not p) = not $ eval e p
eval e (p1 :|: p2) = eval e p1 || eval e p2
eval e (p1 :&: p2) = eval e p1 && eval e p2

p0 :: Prop
p0 = (Var "a" :&: Not (Var "a"))
e0 :: Env
e0 = [("a", True)]

p1 :: Prop
p1 = (Var "a" :&: Var "b") :|: (Not(Var "a") :&: Not (Var "b"))
e1 :: Env
e1 = [( "a", False), ("b", False)]

envs :: Names -> [Env]
envs [] = [[]]
envs (x:xs) = [(x, False) : e | e <- envs xs ]++
              [(x, True) : e | e <- envs xs ]


data Exp = Lit Int
          | Add Exp Exp
          | Mul Exp Exp
showExp :: Exp -> String
showExp (Lit n) = show n
showExp (Add e1 e2 ) = par ( showExp e1 ++ "+" ++ showExp e2 )
showExp (Mul e1 e2 ) = par ( showExp e1 ++ "*" ++ showExp e2 )

par :: String -> String
par s = "(" ++ s ++ ")"

instance Show Exp where
  show = showExp

exp0 :: Exp
exp0 = Add(Lit 2)(Mul(Lit 3)(Lit 3))

-- evalExp :: Exp -> Int
-- evalExp (Lit n) = n
-- evalExp (Add e1 e2) = evalExp e1 + evalExp e2
-- evalExp (Mul e1 e2) = evalExp e1 * evalExp e2

foldExp fLit fAdd fMul (Lit n) = fLit n
foldExp fLit fAdd fMul (Add e1 e2) = fAdd v1 v2
          where
            v1 = foldExp fLit fAdd fMul e1
            v2 = foldExp fLit fAdd fMul e2
foldExp fLit fAdd fMul (Mul e1 e2) = fMul v1 v2
          where
            v1 = foldExp fLit fAdd fMul e1
            v2 = foldExp fLit fAdd fMul e2
-- evalExp = foldExp fLit (+) (*)
--   where
--     fLit (Lit x) = x
{-
data BinaryTree a = Empty
                  | Node (BinaryTree a ) a (BinaryTree a )
                  deriving Show
height :: BinaryTree a -> Int
height Empty = 0
height (Node l _ r) = 1 + max (height l) (height r)

inord :: BinaryTree a -> [a]
inord Empty = []
inord (Node l rad r) = inord l ++ [rad] ++ inord r
-}

data BTree a = Leaf a
              | Node ( BTree a ) ( BTree a )
              --deriving Show
exTree = Node (Node (Leaf 'a') (Leaf 'b')) (Leaf 'c')

showBT :: Show a => BTree a -> String
showBT (Leaf a) = show a
showBT (Node l r) = "(" ++ showBT l ++ "),(" ++ showBT r ++ ")"
instance (Show a) => Show (BTree a) where
  show = showBT

sumBTree :: BTree Integer -> Integer
sumBTree (Leaf x) = x
sumBTree (Node t1  t2) = sumBTree(t1) + sumBTree(t2)

sumFoldBTree :: ( a -> b -> b ) -> b -> BTree a -> b
sumFoldBTree f i (Leaf x) = f x i
sumFoldBTree f i (Node t1 t2) = sumFoldBTree f (sumFoldBTree f i t2) t1

myTree = Node ( Node ( Leaf 1 ) ( Leaf 2 ) ) ( Node ( Leaf 3 ) ( Leaf 4 ) )
--foldr (+) 0 myTree

instance Foldable BTree where
  foldr = sumFoldBTree
myTree2 = Node ( Node ( Leaf "1" ) ( Leaf "2" ) ) ( Node ( Leaf "3" ) ( Leaf "4" ) )
--foldr (++) [] myTree2
