
      function decay_func9(x)

C Probability density function for 2214Pb decay time.

      implicit none

      include 'decay.inc'

      real*4 x,decay_func9

      decay_func9=exp(-x/tau(9))/(0.99996*tau(9))

      return

      end

