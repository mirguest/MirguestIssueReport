
      function decay_func_th_7(x)

C Probability density function for 216Po decay time.

      implicit none

      include 'decay_th.inc'

      real*4 x,decay_func_th_7

      decay_func_th_7=exp(-x/tau(7))/(0.99996*tau(7))

      return

      end

