myCmp :: (Ord a) => a -> a -> Ordering
a `myCmp` b
    | a > b     = GT
    | a == b    = EQ
    | otherwise = LT
