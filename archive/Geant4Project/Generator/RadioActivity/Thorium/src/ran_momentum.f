
      subroutine ran_momentum(total_energy,momentum_in)

C
C Subroutine that calculates a random momentum vector. Total energy is given on input.
C
C A. Piepke 10/24/2001
C
C The range of cos(theta) was only from 0 to 1. Therefore only up ward going momentum
C vectors were produced. As a result the *.asc file had never a momentum vector with
C a negative p3 component. This error has been corrected by ranging cos(theta) from
C -1 to 1.
C
C A. Piepke 5/6/2002
C

        implicit none

        include 'decay_th.inc'
        include 'momentum.inc'

        real*4 rndm3(3)
	logical*4 tfg/.false./	! Marks the first decay for which the random
				! number generator has to be initialized.
        real*4 total_energy     ! Total energy in [GeV]

C Initializations to be done during the first call.

	if(.not.tfg)then
C Set new seed value for the random number generator.
           is=is+88487
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'Initialize random number generator RAN_MOMENTUM'
C Don't go in here again.
	   tfg=.true.
	endif

C Generate two random angles: phi and cos(theta)
        call ranlux(rndm3,3)
	phi=two_pi*rndm3(1)             ! Range: 0 to 2 pi [rad].
C -> This was the coding up to 5/6/2002. Only upward momenta are produced.
C	cos_theta=rndm3(2)              ! Range: 0. to 1.
C -> Coding introduced 5/6/2002
	cos_theta=2.*rndm3(2)-1.        ! Range: -1. to 1.
	sin_theta=sqrt(1.-cos_theta**2) !
C Calculate the three components of the momentum vector.
	momentum_in(1)=total_energy*sin_theta*cos(phi)
	momentum_in(2)=total_energy*sin_theta*sin(phi)
	momentum_in(3)=total_energy*cos_theta

        return

        end
