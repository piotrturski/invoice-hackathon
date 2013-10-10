module Words (toWords) where

import Data.List.Split

-- indexedNumbers -> [(1,"jeden"), (2,"dwa"), ...]
indexedNumbers = concatMap (\(x, y) -> zip x (words y) )
        [
        ([1..], "jeden dwa trzy cztery pięć sześć siedem osiem dziewięć dziesięć jedenaście dwanaście trzynaście czternaście piętnaście szesnaście siedemnaście osiemnaście dziewiętnaście"),
        ([20,30..], "dwadzieścia trzydzieści czterdzieści pięćdziesiąt sześćdziesiąt siedemdziesiąt osiemdziesiąt dziewiećdziesiąt"),
        ([100,200..], "sto dwieście trzysta czterysta pięćset sześćset siedemset osiemset dziewięćset")
        ]

-- divide number to list of numbers of at most 3 digits; 1567 -> [1, 567]
toSmallNumbers :: Int -> [Int]
toSmallNumbers = reverse . map (read . reverse) . chunksOf 3 . reverse . show
        
 -- 625 -> (600, txt); 16 -> (16, txt); 25 -> (20, txt)
firstWord :: Int -> (Int, String)
firstWord n = last . takeWhile ((n >=) . fst) $ indexedNumbers

-- convert < 1000 number to text
smallToWords :: Int -> String
smallToWords n = unwords $ toWord2 [] n
  where toWord2 acc n 
         | n <= 0 = acc
         | otherwise = let (nextNumber, txt) = firstWord n 
                        in toWord2 (acc ++ [txt]) $ n - nextNumber

-- number to list of words. each word if for number < 1000; 2119 -> ["dwa","sto dziew..."]
wordsOfSmallParts:: Int -> [String]
wordsOfSmallParts = map smallToWords . toSmallNumbers

-- add units to list of texts
toWords n = unwords . reverse . map (\(x,y) -> x ++ y) . filter (not.null.fst) . zip (reverse $ wordsOfSmallParts n) $ ["", " tys.", " mln."]
