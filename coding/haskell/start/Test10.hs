tell :: (Show a) => [a] -> String
tell [] = "This list is empty"
tell (x:[]) = "This list has one element: " ++ show x
tell (x:y:[]) = "This list has two elements: " ++ show x
                ++ " and "
                ++ show y
tell (x:y:_) = "This list is long. The first two elements are:"
                ++ show x
                ++ " and "
                ++ show y
