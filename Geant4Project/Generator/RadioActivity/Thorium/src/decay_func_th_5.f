
      function decay_func_th_5(x)

C Probability density function for 224Ra decay time.

      implicit none

      include 'decay_th.inc'

      real*4 x,decay_func_th_5

      decay_func_th_5=exp(-x/tau(5))/(0.99996*tau(5))

      return

      end

