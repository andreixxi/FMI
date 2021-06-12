pare :: [Int] -> [Int]
pare l
  | filter (even) l == l = l
  | otherwise = []
lungime :: [Int] -> Int-> Bool
lungime l n
  | length l > n = True
  | otherwise = False
f ::[[Int]] -> Int -> Bool
f matr n = foldr (&&) True $ map (\x-> (lungime x n) && (pare x == x)) matr
--returneaza liniiile din matrice de lungime n
-- lungimeN :: [[Integer]] -> Int -> [[Integer]]
-- -- lungimeN matrix  n = filter ((>n) . length) matrix
-- lungimeN matrix n = filter ((even) . (\x -> x) ) matrix
--
-- matrice = [[1,2,3],[2,4,6,8,8],[2,3,4,5,6,7,8],[2,2,2,2,2,2,2]
