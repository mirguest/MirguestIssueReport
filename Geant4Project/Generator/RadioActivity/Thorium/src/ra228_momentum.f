
      subroutine ra228_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 228Ra decay.
C
C 10/20/2001 A. Piepke
C

        implicit none

        include 'decay_th.inc'
        include 'momentum.inc'
        include 'fermi_bin.inc'

        integer i,j
	real*4 rndm,rndm_g	! Random number
        real*4 rndm3(3)
	logical*4 tfg/.false./	! Marks the first decay for which the random
				! number generator has to be initialized.
        real*4 total_energy     ! Total energy in [GeV]

        real*4 beta(nr_beta_bins_ra228) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_ra228(nr_branch_ra228,nr_beta_bins_ra228)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

	if(.not.tfg)then
C Convert branching ratios into probability distribution.
           do i=2,nr_branch_ra228
              branch_ra228(i)=branch_ra228(i)+branch_ra228(i-1)
           enddo

           do i=1,nr_branch_ra228
C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_ra228(i),89,228,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_ra228(i)))then
                write(*,*)'>>>Beta array too long or short in: ',
     1          'th234_momentum'
                write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                write(*,*)'Expected             : ',
     1          int(1.e6*e_beta_ra228(i))
                stop
              endif
              do j=1,fpoint_nr
                beta(j)=probfermi_s(j)
              enddo
C Initialize random number generator by calculating the cumulative the distributions.
              call hispre(beta,fpoint_nr)
C             call rnhpre(beta,fpoint_nr)
C              write(*,*)'Beta branching state: ',i,' branch: ',
C     1        branch_ra228(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                beta_ra228(i,j)=beta(j)
                if(beta(j).lt.beta(j-1).and.j.ne.1)then
                   write(*,*)'Cummulative beta distribution',
     1             ' not monotonic!'
                   stop
                endif
              enddo
           enddo

C Set new seed value for the random number generator.
           is=is+3664
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'Initialize random number generator RA228_MOMENTUM'
C Don't go in here again.
	   tfg=.true.
	endif

C Stop here!

C        write(*,*)
C        do i=1,nr_branch_ra228
C           write(*,*)'Beta branching state: ',i,' branch: ',
C     1     branch_ra228(i)
C           write(*,*)'*****************************'
C           do j=1,nr_branch_gam_ra228
C              write(*,*)'Gamma branching ratio. State: ',i,
C     1        ' Gamma: ',j,' branching: ',branch_gam_ra228(i,j)
C           enddo
C        enddo
C
C        do i=1,nr_branch_ra228
C           read(*,*)
C           write(*,*)'*********************'
C           write(*,*)'Beta branch: ',i
C           do j=1,int(1.e6*e_beta_ra228(1))
C              write(*,*)'Energy [kV]: ',j,'  ',beta_ra228(i,j)
C           enddo
C        enddo

C        read(*,*)

C Reset all arrays for this decay.

        nr_part=0
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

c*************************************************************************************

C Decay into 6.7 keV state.
        if(rndm.le.branch_ra228(1))then    ! 228Ra E=6.7 keV state decay
           nr_part=2                       ! Two particles are emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_ra228(1))
             beta(j)=beta_ra228(1,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!'
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ra228(1)),0.,1.,energy(1))
C          call rnhran(beta,int(1.e6*e_beta_ra228(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6       ! Convert from [keV] to [GeV].
C Convert kinetic energy into total momentum of electron.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(1)=momentum_in(1)
	   momentum(2)=momentum_in(2)
	   momentum(3)=momentum_in(3)
C Conversion electron
           pid(2)=11                       ! Electron: transition is fully converted.
           mass(2)=m_e
           energy(2)=e_gam_ra228(1,1)
C Convert kinetic energy into total momentum of electron.
           total_energy=sqrt(energy(2)*(energy(2)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(4)=momentum_in(1)
	   momentum(5)=momentum_in(2)
	   momentum(6)=momentum_in(3)

c*************************************************************************************

C Decay into excited state 20.2 keV.
        elseif(rndm.gt.branch_ra228(1).and.rndm.le.branch_ra228(2))then ! decay into first excited state.
C Generate the beta electron
           nr_part=3                       ! Three particles are emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_ra228(2))
             beta(j)=beta_ra228(2,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!'
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ra228(2)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(1)=momentum_in(1)
	   momentum(2)=momentum_in(2)
	   momentum(3)=momentum_in(3)
C Secondaries
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           pid(3)=11                       ! Conversion electron
           mass(3)=m_e                     ! Save rest mass
           energy(2)=e_gam_ra228(2,1)
           energy(3)=e_gam_ra228(2,2)
C Convert kinetic energy into total momentum for the gamma.
           total_energy=energy(2)
C Get momentum vector with isotropic angular distribution for first gamma.
           call ran_momentum(total_energy,momentum_in)
	   momentum(4)=momentum_in(1)
	   momentum(5)=momentum_in(2)
	   momentum(6)=momentum_in(3)
C Convert kinetic energy into total momentum for the second gamma.
           total_energy=sqrt(energy(3)*(energy(3)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(7)=momentum_in(1)
	   momentum(8)=momentum_in(2)
	   momentum(9)=momentum_in(3)

c*************************************************************************************

C Decay excited 33.1 keV state.
        elseif(rndm.gt.branch_ra228(2))then ! decay into second excited state.
C Generate the beta electron
           nr_part=3                       ! Three particles are emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_ra228(3))
             beta(j)=beta_ra228(3,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!'
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ra228(3)),0.,1.,energy(1))
           energy(1)=energy(1)*.1e-6
C Convert kinetic energy into total momentum of electron.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution for first gamma.
           call ran_momentum(total_energy,momentum_in)
	   momentum(1)=momentum_in(1)
	   momentum(2)=momentum_in(2)
	   momentum(3)=momentum_in(3)
C Secondaries
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           pid(3)=11                       ! Conversion electron
           mass(3)=m_e                     ! Save rest mass
           energy(2)=e_gam_ra228(3,1)
           energy(3)=e_gam_ra228(3,2)
C Convert kinetic energy into total momentum for the gamma.
           total_energy=energy(2)
C Get momentum vector with isotropic angular distribution for first gamma.
           call ran_momentum(total_energy,momentum_in)
	   momentum(4)=momentum_in(1)
	   momentum(5)=momentum_in(2)
	   momentum(6)=momentum_in(3)
C Convert kinetic energy into total momentum for the second gamma.
           total_energy=sqrt(energy(3)*(energy(3)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(7)=momentum_in(1)
	   momentum(8)=momentum_in(2)
	   momentum(9)=momentum_in(3)

        endif

        return

        end
