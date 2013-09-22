
take' :: (Num i, Ord i) => i -> [a] -> [a]

take' n _
    | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x: take' (n-1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

repeat' :: a -> [a]
repeat' x = x:repeat' x
