
      function decay_func10(x)

C Probability density function for 214Bi decay time.

      implicit none

      include 'decay.inc'

      real*4 x,decay_func10

      decay_func10=exp(-x/tau(10))/(0.99996*tau(10))

      return

      end

