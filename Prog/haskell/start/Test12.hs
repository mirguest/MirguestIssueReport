
bmiTell :: (RealFloat a) => a -> String

bmiTell bmi
    | bmi <= 18.5 = "You're underweight!"
    | bmi <= 25.0 = "You're supposedly normal."
    | bmi <= 30.0 = "You're fat!"
    | otherwise   = "You're a whale!"

bmiTell' :: (RealFloat a) => a -> a -> String
bmiTell' height weight = bmiTell (weight / (height^2))

bmiTell'' :: (RealFloat a) => a -> a -> String
bmiTell'' weight height
    | bmi <= skinny = "You're underweight!"
    | bmi <= normal = "You're supposedly normal."
    | bmi <= fat    = "You're fat!"
    | otherwise     = "You're a whale!"
    where bmi = weight / height^2
          (skinny,normal,fat)   = (18.5, 25.0, 30.0)

calcBmis :: (RealFloat a) => [(a,a)] -> [a]
calcBmis xs = [bmi w h | (w, h) <- xs]
    where bmi weight height = weight / height ^ 2
