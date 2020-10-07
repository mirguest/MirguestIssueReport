
      function decay_func_th_3(x)

C Probability density function for 228Ac decay time.

      implicit none

      include 'decay_th.inc'

      real*4 x,decay_func_th_3

      decay_func_th_3=exp(-x/tau(3))/(0.99996*tau(3))

      return

      end

