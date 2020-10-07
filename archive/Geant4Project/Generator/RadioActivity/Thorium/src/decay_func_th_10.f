
      function decay_func_th_10(x)

C Probability density function for 212Po decay time.

      implicit none

      include 'decay_th.inc'

      real*4 x,decay_func_th_10

      decay_func_th_10=exp(-x/tau(10))/(0.99996*tau(10))

      return

      end

