import Data.Char
initials :: String -> String -> String
initials firstname lastname = (toUpper f):fs ++ ". " ++ (toUpper l):ls ++ "."
    where (f:fs) = firstname
          (l:ls) = lastname
