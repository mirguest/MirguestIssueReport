data Tree a =
    EmptyTree |
    Node a (Tree a) (Tree a)
    deriving (Show, Read, Eq)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmtryTree
