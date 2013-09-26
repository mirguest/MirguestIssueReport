data Tree a =
    EmptyTree |
    Node a (Tree a) (Tree a)
    deriving (Show, Read, Eq)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmtryTree

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmtryTree = singleton x
treeInsert x (Node a left right)
    | x == a = Node x left right
    | x < a  = Node a (treeInsert x left) right
    | x > a  = Node a left (treeInsert x right)
