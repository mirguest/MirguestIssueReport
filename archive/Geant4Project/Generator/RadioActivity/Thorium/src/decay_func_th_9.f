
      function decay_func_th_9(x)

C Probability density function for 212Bi decay time.

      implicit none

      include 'decay_th.inc'

      real*4 x,decay_func_th_9

      decay_func_th_9=exp(-x/tau(9))/(0.99996*tau(9))

      return

      end

