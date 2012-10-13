
      function decay_func_th_6(x)

C Probability density function for 220Rn decay time.

      implicit none

      include 'decay_th.inc'

      real*4 x,decay_func_th_6

      decay_func_th_6=exp(-x/tau(6))/(0.99996*tau(6))

      return

      end

