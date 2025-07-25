module PE2 where

data GridTree a = EmptyTree | GridTree a [GridTree a] deriving (Show, Eq)

findNode :: a -> GridTree a -> (Int, Int) -> a
findNode def EmptyTree _ = def
findNode def (GridTree val children) (0, 0) = val
findNode def (GridTree _ children) (targetx, targety) = 
    findAtRow children 1 targetx targety
  where
    findAtRow [] _ _ _ = def
    findAtRow nodes currentx targetx targety
      | currentx == targetx = searchy nodes 0 targety
      | otherwise = 
          let nextLevel = collectChildren nodes
          in findAtRow nextLevel (currentx + 1) targetx targety

    searchy [] _ _ = def
    searchy (EmptyTree : rest) col targety = searchy rest (col + 1) targety
    searchy (GridTree val _ : rest) col targety
      | col == targety = val
      | otherwise = searchy rest (col + 1) targety

    collectChildren [] = []
    collectChildren (EmptyTree : rest) = collectChildren rest
    collectChildren (GridTree _ cs : rest) = cs ++ collectChildren rest
    


findLocationOf :: (Eq a) => a -> GridTree a -> (Int, Int)
findLocationOf searchx EmptyTree = (-1, -1)
findLocationOf searchx tree =
  let list = makeList (depthlist tree 0)
  in searchIn searchx list


searchIn :: (Eq a) => a -> [(Int, Int, a)] -> (Int, Int)
searchIn _ [] = (-1, -1)
searchIn searchx ((x, y, val):xs)
  | searchx == val = (x, y)
  | otherwise        = searchIn searchx xs

depthlist :: GridTree a -> Int -> [(Int, a)]
depthlist EmptyTree _ = []
depthlist (GridTree val children) depth =
    (depth, val) : concatMap (\child -> depthlist child (depth + 1)) children

makeList :: [(Int, a)] -> [(Int, Int, a)]
makeList tree =
  let
    maxDepth :: [(Int, a)] -> Int
    maxDepth xs = maximum [dep | (dep, _) <- xs]

    maxtree        = maxDepth tree
    allDepths = [ groupByDepth dep 0 tree | dep <- [0..maxtree] ]
  in concat allDepths

groupByDepth :: Int -> Int -> [(Int, a)] -> [(Int, Int, a)]
groupByDepth _ _ [] = []
groupByDepth targetDepth numb ((depth, val):xs)
  | targetDepth == depth = (depth, numb, val) : groupByDepth targetDepth (numb + 1) xs
  | otherwise            = groupByDepth targetDepth numb xs

insertNode :: a -> GridTree a -> (Int, Int) -> GridTree a
insertNode newVal tree (x, y)
  | x <= treeDepth tree =
      let
          parents = nodesAtLevel (x - 1) tree
          (p, idx) = chooseParent parents y
      in updateAtPath p (\(GridTree v cs) -> GridTree v (insertAtIndex cs idx (GridTree newVal []))) tree
  | otherwise =
      let d = treeDepth tree
          parents = nodesAtLevel d tree
          (p, idx) = case parents of
                       [] -> error "x"
                       _  -> let (p', GridTree _ cs) = head parents
                             in (p', if y <= length cs then y else length cs)
      in updateAtPath p (\(GridTree v cs) -> GridTree v (insertAtIndex cs idx (GridTree newVal []))) tree

chooseParent :: [(Path, GridTree a)] -> Int -> (Path, Int)
chooseParent [] _ = error "x"
chooseParent ps y = go ps y
  where
    go :: [(Path, GridTree a)] -> Int -> (Path, Int)
    go [(p, GridTree _ cs)] y = (p, if y <= length cs then y else length cs)
    go ((p, GridTree _ cs) : rest) y
         | y <= length cs = (p, y)
         | otherwise      = go rest (y - length cs)

type Path = [Int]

nodesAtLevel :: Int -> GridTree a -> [(Path, GridTree a)]
nodesAtLevel 0 t = [([], t)]
nodesAtLevel n (GridTree _ cs) = collect cs 0
  where
    collect [] _ = []
    collect (c:rest) i =
      let childResults = nodesAtLevel (n - 1) c
          withPaths = [ (i : p, node) | (p, node) <- childResults ]
      in withPaths ++ collect rest (i + 1)

updateAtPath :: Path -> (GridTree a -> GridTree a) -> GridTree a -> GridTree a
updateAtPath [] f t = f t
updateAtPath (i:is) f (GridTree v cs) =
  GridTree v (updateListAt i (\child -> updateAtPath is f child) cs)

updateListAt :: Int -> (a -> a) -> [a] -> [a]
updateListAt 0 f (x:xs) = f x : xs
updateListAt i f (x:xs) = x : updateListAt (i-1) f xs
updateListAt _ _ [] = error "x"

insertAtIndex :: [a] -> Int -> a -> [a]
insertAtIndex xs i newElem =
  let (front, back) = splitAt i xs
  in front ++ [newElem] ++ back

treeDepth :: GridTree a -> Int
treeDepth (GridTree _ []) = 0
treeDepth (GridTree _ cs) = 1 + maximum (map treeDepth cs)