
      subroutine po214_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 214Po decay.
C
C 8/27/2001 A. Piepke
C
C 9/30/2001 A.P. Save particles rest mass. 
C

        implicit none

        include 'decay.inc'
        include 'momentum.inc'

        integer i
	real*4 rndm		! Random number
        real*4 rndm3(3)
	logical*4 tfg/.false./	! Marks the first decay for which the random
				! number generator has to be initialized.
        real*4 total_energy     ! Total energy in [GeV]

C Initializations to be done during the first call.

	if(.not.tfg)then
C Set new seed value for the random number generator.
           is=is+10046
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'! Initialize random number generator PO214_MOMENTUM'
C Don't go in here again.
	   tfg=.true.
	endif

C Reset all arrays for this decay.

        do i=1,array_e
           energy(i)=0.
           pid(i)=0.
           mass(i)=0.
        enddo
        do i=1,array_p
           momentum(i)=0.
        enddo

C Ground state decay.
        nr_part=1                       ! One particle is emitted
        pid(1)=9802004                  ! Alpha
        mass(1)=m_alpha                 ! Save rest mass
        energy(1)=e_alpha_po214(1)
C Convert kinetic energy into total momentum.
        total_energy=sqrt(energy(1)*(energy(1)+2.*m_alpha))
C Get momentum vector with isotropic angular distribution.
        call ran_momentum(total_energy,momentum_in)
	momentum(1)=momentum_in(1)
	momentum(2)=momentum_in(2)
	momentum(3)=momentum_in(3)

        return

        end
