module PE3 where

data Cell = SpaceCraft Int | Sand | Rock Int | Pit deriving (Eq, Read, Show)

type Grid = [[Cell]]
type Coordinate = (Int, Int)

data Move = North | East | South | West | PickUp | PutDown deriving (Eq, Read, Show)

data Robot = Robot { name :: String,
                     location :: Coordinate,
                     capacity :: Int,
                     energy :: Int,
                     storage :: Int } deriving (Eq, Read, Show)

-------------------------------------------------------------------------------------------
--------------------------------- DO NOT CHANGE ABOVE -------------------------------------
------------- DUMMY IMPLEMENTATIONS ARE GIVEN TO PROVIDE A COMPILABLE TEMPLATE ------------
------------------- REPLACE THEM WITH YOUR COMPILABLE IMPLEMENTATIONS ---------------------
-------------------------------------------------------------------------------------------
-------------------------------------- PART I ---------------------------------------------

isInGrid :: Grid -> Coordinate -> Bool
isInGrid grid (x, y) =
  y >= 0 && y < length grid &&
  x >= 0 && not (null grid) && x < length (head grid)
-------------------------------------------------------------------------------------------

totalCount :: Grid -> Int
totalCount grid = sum [n | row <- grid, Rock n <- row]

-------------------------------------------------------------------------------------------

coordinatesOfPits :: Grid -> [Coordinate]
coordinatesOfPits grid = 
  lexicographicalSort [(x, y) | y <- [0..(length grid - 1)], x <- [0..(length (grid !! y) - 1)], (grid !! y !! x) == Pit]

-- Helper function to lexicographically sort coordinates by (x, y)
lexicographicalSort :: [Coordinate] -> [Coordinate]
lexicographicalSort [] = []
lexicographicalSort (x:xs) = insertCoord x (lexicographicalSort xs)

-- Insert a coordinate into its correct position in the sorted list
insertCoord :: Coordinate -> [Coordinate] -> [Coordinate]
insertCoord coord [] = [coord]
insertCoord coord@(x1, y1) (y@(x2, y2):ys)
    | compareCoords coord y == LT = coord : y : ys
    | otherwise = y : insertCoord coord ys

-- Compare two coordinates lexicographically by (x, y)
compareCoords :: Coordinate -> Coordinate -> Ordering
compareCoords (x1, y1) (x2, y2)
    | x1 < x2   = LT
    | x1 > x2   = GT
    | y1 < y2   = LT
    | y1 > y2   = GT
    | otherwise = EQ
-------------------------------------------------------------------------------------------


tracePath :: Grid -> Robot -> [Move] -> [Coordinate]
tracePath grid (Robot _ (x, y) _ energy _) moves =
  tracePathWithEnergy energy (x, y) grid moves
checkValid :: Coordinate -> Grid -> Bool
checkValid coord grid = isInGrid grid coord 
checkValidWithoutPit:: Coordinate -> Grid -> Bool
checkValidWithoutPit coord grid = not (elem coord (coordinatesOfPits grid))



tracePathWithEnergy :: Int -> Coordinate -> Grid -> [Move] -> [Coordinate]
tracePathWithEnergy _ coord _ [] = []
tracePathWithEnergy currentEnergy (x, y) grid (move:moves) =
  if move == West then
    if checkValid (x - 1, y) grid && checkValidWithoutPit (x, y) grid && currentEnergy >= 1 then
      (x - 1, y) : tracePathWithEnergy (currentEnergy - 1) (x - 1, y) grid moves
    else
      (x, y) : tracePathWithEnergy (if currentEnergy - 1 > 0 then currentEnergy - 3 else 0) (x, y) grid moves

  else if move == East then
    if checkValid (x + 1, y) grid && checkValidWithoutPit (x, y) grid && currentEnergy >= 1 then
      (x + 1, y) : tracePathWithEnergy (currentEnergy - 1) (x + 1, y) grid moves
    else
      (x, y) : tracePathWithEnergy (if currentEnergy - 1 >= 0 then currentEnergy - 3 else 0) (x, y) grid moves

  else if move == North then
    if checkValid (x, y - 1) grid && checkValidWithoutPit (x, y) grid && currentEnergy >= 1 then
      (x, y - 1) : tracePathWithEnergy (currentEnergy - 1) (x, y - 1) grid moves
    else
      (x, y) : tracePathWithEnergy (if currentEnergy - 1 > 0 then currentEnergy - 3 else 0) (x, y) grid moves

  else if move == South then
    if checkValid (x, y + 1) grid && checkValidWithoutPit (x, y) grid && currentEnergy >= 1 then
      (x, y + 1) : tracePathWithEnergy (currentEnergy - 1) (x, y + 1) grid moves
    else
      (x, y) : tracePathWithEnergy (if currentEnergy - 1 > 0 then currentEnergy - 3 else 0) (x, y) grid moves

  else if move == PickUp then
    if currentEnergy >= 5 then
      (x, y) : tracePathWithEnergy (currentEnergy - 5) (x, y) grid moves
    else
      (x, y) : tracePathWithEnergy 0 (x, y) grid moves

  else if move == PutDown then
    if currentEnergy >= 3 then
      (x, y) : tracePathWithEnergy (currentEnergy - 3) (x, y) grid moves
    else
      (x, y) : tracePathWithEnergy 0 (x, y) grid moves
  else
    error ("Invalid move: " ++ show move)

updateRobotState :: Coordinate -> Robot -> Robot
updateRobotState scCoord (Robot name loc cap energy store) =
    let gain = computeEnergyGain loc scCoord
        newEnergy = min 100 (energy + gain)
    in Robot name loc cap newEnergy store

applyMove :: Grid -> Robot -> Move -> (Grid, Robot)
applyMove grid (Robot name (x, y) cap energy store) move =
  if move == West then
    if checkValid (x - 1, y) grid && checkValidWithoutPit (x, y) grid && energy >= 1 then
      (grid, Robot name (x - 1, y) cap (energy - 1) store)
    else
      let newEnergy = if energy > 1 then energy - 1 else 0
      in (grid, Robot name (x, y) cap newEnergy store)

  else if move == East then
    if checkValid (x + 1, y) grid && checkValidWithoutPit (x, y) grid && energy >= 1 then
     (grid, Robot name (x + 1, y) cap (energy - 1) store)
    else
       let newEnergy = if energy > 1 then energy - 1 else 0
       in (grid, Robot name (x, y) cap newEnergy store)

  else if move == North then
    if checkValid (x, y - 1) grid && checkValidWithoutPit (x, y) grid && energy >= 1 then
      (grid, Robot name (x, y - 1) cap (energy - 1) store)
    else
      let newEnergy = if energy > 1 then energy - 1 else 0
      in (grid, Robot name (x, y) cap newEnergy store)

  else if move == South then
    if checkValid (x, y + 1) grid && checkValidWithoutPit (x, y) grid && energy >= 1 then
     (grid, Robot name (x, y + 1) cap (energy - 1) store)
    else
      let newEnergy = if energy > 1 then energy - 1 else 0
      in (grid, Robot name (x, y) cap newEnergy store)

 else if move == PickUp then
    if energy >= 5 && store < cap && isRockAt grid (x, y) then
      let (Rock n) = getCellAt grid (x, y)
          updatedGrid = setCellAt grid (x, y) (if n > 1 then Rock (n - 1) else Sand)
      in (updatedGrid, Robot name (x, y) cap (energy - 5) (store + 1))
    else
      (grid, Robot name (x, y) cap  (max (energy - 5) 0) store)

  else if move == PutDown then
    if energy >= 3 && store > 0 then
    let (a,b) = head[(b, a) | (a, row) <- zip [0..] grid, (b, x) <- zip [0..] row, isSpaceCraftAt x]
        (SpaceCraft n) = getCellAt grid (a, b)
        updatedGrid = setCellAt grid (a, b) (SpaceCraft (n+1))
    in (updatedGrid, Robot name (x, y) cap (energy - 3) (store - 1))
    else
      (grid, Robot name (x, y) cap  (max (energy - 3) 0) store)

  else
    error ("Invalid move: " ++ show move)


computeEnergyGain :: Coordinate -> Coordinate -> Int
computeEnergyGain (x1, y1) (x2, y2) = max 0 (100 - 20 * (abs (x1 - x2) + abs (y1 - y2)) )

------------------------------------- PART II ----------------------------------------------

energiseRobots :: Grid -> [Robot] -> [Robot]
energiseRobots grid robots = 
    let -- Find the coordinates of the SpaceCraft in the grid
        findSpaceCraft :: Grid -> Coordinate
        findSpaceCraft grid = head [ (x, y) | (y, row) <- zip [0..] grid
                                             , (x, SpaceCraft _) <- zip [0..] row ]
        
        -- Calculate the energy gain for a robot based on its Manhattan distance to the SpaceCraft
        calculateEnergyGain :: Robot -> Coordinate -> Int
        calculateEnergyGain (Robot _ (rx, ry) _ _ _) (sx, sy) = 
            let manhattanDist = abs (rx - sx) + abs (ry - sy)
                energyGain = max 0 (100 - manhattanDist * 20)
            in energyGain
        
        -- Update each robot's energy
        updateRobotEnergy :: Robot -> Coordinate -> Robot
        updateRobotEnergy robot@(Robot n loc cap en strg) spaceCraftCoord =
            let gain = calculateEnergyGain robot spaceCraftCoord
                newEnergy = min 100 (en + gain)  -- Ensure energy doesn't exceed 100
            in robot { energy = newEnergy }

    in -- Find the SpaceCraft position and update the robots
       let spaceCraftCoord = findSpaceCraft grid
       in map (`updateRobotEnergy` spaceCraftCoord) robots

-------------------------------------------------------------------------------------------

applyMoves :: Grid -> Robot -> [Move] -> (Grid, Robot)
applyMoves grid robot [] = (grid, robot)
applyMoves grid robot (m:ms) =
  let (newGrid, newRobot) = applyMove grid robot m
  in applyMoves newGrid newRobot ms

getCellAt :: Grid -> Coordinate -> Cell
getCellAt grid (x, y) = (grid !! y) !! x

setCellAt :: Grid -> Coordinate -> Cell -> Grid
setCellAt grid (x, y) newCell =
  take y grid ++
  [take x (grid !! y) ++ [newCell] ++ drop (x + 1) (grid !! y)] ++
  drop (y + 1) grid

isRockAt :: Grid -> Coordinate -> Bool
isRockAt grid coord =
  let cell = getCellAt grid coord
  in if isRockCell cell then True else False

isRockCell :: Cell -> Bool
isRockCell (Rock n) = n > 0
isRockCell _        = False

isSpaceCraftAt :: Cell -> Bool
isSpaceCraftAt (SpaceCraft _) = True
isSpaceCraftAt _ = False