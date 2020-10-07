
      function decay_func_th_11(x)

C Probability density function for 208Tl decay time.

      implicit none

      include 'decay_th.inc'

      real*4 x,decay_func_th_11

      decay_func_th_11=exp(-x/tau(11))/(0.99996*tau(11))

      return

      end

