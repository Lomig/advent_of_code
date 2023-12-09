module Main where

main :: IO ()
main =
  readFile "input.txt" >>= \raw_readings ->
    let readings :: [[Int]]
        readings = map (map read . words) $ lines raw_readings in
    do
    putStrLn $ "Part 1 – " ++ show (extrapolate readings)
    putStrLn $ "Part 2 – " ++ show (extrapolate (map reverse readings))


------------------------------------------
-- Solutions
------------------------------------------

extrapolate :: [[Int]] -> Int
extrapolate readings = sum $ map find_increase readings


------------------------------------------
-- Helpers
-----------------------------------------

find_increase :: [Int] -> Int
find_increase single_reading
  | all (== 0 ) single_reading = 0
  | otherwise = (last single_reading) + find_increase (reduced_reading single_reading)


reduced_reading :: [Int] -> [Int]
reduced_reading [] = []
reduced_reading [_] = []
reduced_reading (x1:x2:xs) = (x2 - x1:reduced_reading (x2:xs))
