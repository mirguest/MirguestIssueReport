-- http://learnyouahaskell.com/higher-order-functions

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)
