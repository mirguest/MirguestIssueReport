
      function decay_func3(x)

C Probability density function for 234mPa decay time.

      implicit none

      include 'decay.inc'

      real*4 x,decay_func3

      decay_func3=exp(-x/tau(3))/(0.99996*tau(3))

      return

      end

