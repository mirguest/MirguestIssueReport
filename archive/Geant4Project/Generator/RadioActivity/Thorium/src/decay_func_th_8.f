
      function decay_func_th_8(x)

C Probability density function for 212Pb decay time.

      implicit none

      include 'decay_th.inc'

      real*4 x,decay_func_th_8

      decay_func_th_8=exp(-x/tau(8))/(0.99996*tau(8))

      return

      end

