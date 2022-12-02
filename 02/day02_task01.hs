import System.IO  
import Control.Monad
import Data.List
import Data.Maybe

xScore = 1
yScore = 2
zScore = 3

lineSize = 4

opponentMoves = ["A", "B", "C"]
myMoves = ["X", "Y", "Z"]

-- Convert from just to an actual int
toInt x = fromJust x

-- loss = 0, draw = 3, win = 6
evalMatch opponent me = do
    let rating = opponent - me
    if rating == 0 then 3
    else if (||) (rating == 1) (rating == -2) then 0
    else 6

-- Index of the move + 1
baseRating move = toInt(elemIndex move myMoves) + 1

main = do
    content <- readFile "input.txt"
    let contentSize = length content
    let lineCount = div contentSize lineSize
    let zeroConst = contentSize - contentSize -- This will create an IO Int
    let loop x = do
        if x == lineCount then zeroConst else do
            let opponentMove = take 1 (drop (0 + x * 4) content)
            let myMove = take 1 (drop (2 + x * 4) content)
            let matchResult = evalMatch opponent me where
                opponent = toInt (elemIndex (opponentMove) opponentMoves)
                me = toInt (elemIndex (myMove) myMoves)
            matchResult + loop (x + 1) + (baseRating myMove)
    let result = loop 0
    print result
    