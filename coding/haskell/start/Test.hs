main = do putStrLn "What is 2+2?"
          x <- readLn
          if x == 4
              then putStrLn "You are right!"
              else putStrLn "You are wrong!"
