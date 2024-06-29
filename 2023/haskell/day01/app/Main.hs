module Main where 

import Data.Char (isDigit)

main :: IO ()
main =
  readFile "input.txt"
    >>= return . solve . lines
    >>= print
  >>
  readFile "input.txt"
    >>= return . solve2 . lines
    >>= print


------------------------------------------
-- Solutions
------------------------------------------

solve :: [String] -> Int
solve calibration_values =
  sum (map (\x -> list_to_int (extract_digit_numbers x [])) calibration_values)

solve2 :: [String] -> Int 
solve2 calibration_values =
  sum (map (\x -> list_to_int (extract_all_numbers x [])) calibration_values) 

------------------------------------------
-- Helpers
-----------------------------------------

remove_first_char :: String -> String
remove_first_char [] = []
remove_first_char (_:xs) = xs

extract_all_numbers :: String -> [Int] -> [Int]
extract_all_numbers string numbers = 
  let next_string = remove_first_char string in
  case string of
  []                      -> numbers
  ('z':'e':'r':'o':_)     -> extract_all_numbers next_string (0:numbers) 
  ('o':'n':'e':_)         -> extract_all_numbers next_string (1:numbers)
  ('t':'w':'o':_)         -> extract_all_numbers next_string (2:numbers)
  ('t':'h':'r':'e':'e':_) -> extract_all_numbers next_string (3:numbers)
  ('f':'o':'u':'r':_)     -> extract_all_numbers next_string (4:numbers)
  ('f':'i':'v':'e':_)     -> extract_all_numbers next_string (5:numbers)
  ('s':'i':'x':_)         -> extract_all_numbers next_string (6:numbers)
  ('s':'e':'v':'e':'n':_) -> extract_all_numbers next_string (7:numbers)
  ('e':'i':'g':'h':'t':_) -> extract_all_numbers next_string (8:numbers)
  ('n':'i':'n':'e':_)     -> extract_all_numbers next_string (9:numbers)
  (x:_) | isDigit x       -> extract_all_numbers next_string ((read [x] :: Int):numbers)
  _                       -> extract_all_numbers next_string numbers

extract_digit_numbers :: String -> [Int] -> [Int]
extract_digit_numbers string numbers = case string of
  []                 -> numbers
  (x:xs) | isDigit x -> extract_digit_numbers xs ((read [x] :: Int):numbers)
  (_:xs)             -> extract_digit_numbers xs numbers


list_to_int :: [Int] -> Int
list_to_int [] = 0
list_to_int numeric_values = (last numeric_values) * 10 + (head numeric_values)

