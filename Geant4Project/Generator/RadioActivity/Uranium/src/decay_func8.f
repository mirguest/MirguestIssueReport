
      function decay_func8(x)

C Probability density function for 218Po decay time.

      implicit none

      include 'decay.inc'

      real*4 x,decay_func8

      decay_func8=exp(-x/tau(8))/(0.99996*tau(8))

      return

      end

