
      function decay_func11(x)

C Probability density function for 214Po decay time.

      implicit none

      include 'decay.inc'

      real*4 x,decay_func11

      decay_func11=exp(-x/tau(11))/(0.99996*tau(11))

      return

      end
