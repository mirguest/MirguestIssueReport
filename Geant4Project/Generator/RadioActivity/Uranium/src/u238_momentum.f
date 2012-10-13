
      subroutine u238_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 238U decay.
C
C 8/12/2001 A. Piepke
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
C Convert branching ratios into probability distribution.
           do i=2,nr_branch_u238
              branch_u238(i)=branch_u238(i)+branch_u238(i-1)
           enddo

C Set new seed value for the random number generator.
           is=is+9383
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'! Initialize random number generator U238_MOMENTUM'
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

C Decide which decay branch to generate.

        call ranlux(rndm,1)

        if(rndm.le.branch_u238(1))then     ! 238U ground state decay
C Ground state decay.
           nr_part=1                       ! One particle is emitted
           pid(1)=9802004                  ! Alpha
           mass(1)=m_alpha                 ! Save rest mass
           energy(1)=e_alpha_u238(1)
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_alpha))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(1)=momentum_in(1)
	   momentum(2)=momentum_in(2)
	   momentum(3)=momentum_in(3)

        elseif(rndm.gt.branch_u238(1).and.rndm.le.branch_u238(2))then ! decay into first excited state.
C Decay into first excited state
           nr_part=2                       ! Two particles are emitted
           pid(1)=9802004                  ! Alpha
           mass(1)=m_alpha                 ! Save rest mass
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           energy(1)=e_alpha_u238(2)
           energy(2)=e_gam_u238(2)
C Convert kinetic energy into total momentum of alpha.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_alpha))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(1)=momentum_in(1)
	   momentum(2)=momentum_in(2)
	   momentum(3)=momentum_in(3)
C Convert kinetic energy into total momentum for the gamma.
           total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(4)=momentum_in(1)
	   momentum(5)=momentum_in(2)
	   momentum(6)=momentum_in(3)

        elseif(rndm.gt.branch_u238(2))then ! decay into first excited state.
C Decay into second excited state
           nr_part=3                       ! Three particles are emitted
           pid(1)=9802004                  ! Alpha
           mass(1)=m_alpha                 ! Save rest mass
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           pid(3)=22                       ! Gamma
           mass(3)=m_g                     ! Save rest mass
           energy(1)=e_alpha_u238(3)
           energy(2)=e_gam_u238(2)
           energy(3)=e_gam_u238(3)
C Convert kinetic energy into total momentum for alpha.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_alpha))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(1)=momentum_in(1)
	   momentum(2)=momentum_in(2)
	   momentum(3)=momentum_in(3)
C Convert kinetic energy into total momentum for the first gamma.
           total_energy=energy(2)
C Get momentum vector with isotropic angular distribution for first gamma.
           call ran_momentum(total_energy,momentum_in)
	   momentum(4)=momentum_in(1)
	   momentum(5)=momentum_in(2)
	   momentum(6)=momentum_in(3)
C Convert kinetic energy into total momentum for the second gamma.
           total_energy=energy(3)
C Get momentum vector with isotropic angular distribution for first gamma.
           call ran_momentum(total_energy,momentum_in)
	   momentum(7)=momentum_in(1)
	   momentum(8)=momentum_in(2)
	   momentum(9)=momentum_in(3)
        endif

        return

        end
