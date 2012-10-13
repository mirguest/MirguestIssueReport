
      subroutine th234_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 234Th decay.
C
C 8/26/2001 A. Piepke
C
C 9/30/2001 A.P. Save particles rest mass. 
C
C 11/4/2001 A.P. Handling of the "momentum" array changed. Code is shorter now.
C

        implicit none

        include 'decay.inc'
        include 'momentum.inc'
        include 'fermi_bin.inc'

        integer i,j,k
	real*4 rndm,rndm_g	! Random number
        real*4 rndm3(3)
	logical*4 tfg/.false./	! Marks the first decay for which the random
				! number generator has to be initialized.
        real*4 total_energy     ! Total energy in [GeV]

        real*4 beta(nr_beta_bins_th234) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_th234(nr_branch_th234,nr_beta_bins_th234)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

	if(.not.tfg)then
C Convert branching ratios into probability distribution.
           write(*,*)'! 234Th'
           write(*,*)'! Beta branching ratio:  1',branch_th234(1)
           do i=2,nr_branch_th234
              branch_th234(i)=branch_th234(i)+branch_th234(i-1)
              write(*,*)'! Beta branching ratio: ',i, branch_th234(i)
           enddo

           do i=1,nr_branch_th234
C Integrate the gamma branching ratios
              write(*,*)'! Beta branch: ',i,
     1             ' gamma branching ratio:  1', 
     1             branch_gam_th234(i,1)
              do j=2,nr_branch_gam_th234
                 branch_gam_th234(i,j)=branch_gam_th234(i,j)+
     1                branch_gam_th234(i,j-1)
                 write(*,*)'! Beta branch: ',i,
     1                ' gamma branching ratio: ',
     1                j, branch_gam_th234(i,j)
              enddo
C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_th234(i),91,234,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_th234(i)))then
                write(*,*)'>>>Beta array too long or short in: ',
     1          'th234_momentum'
                write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                write(*,*)'Expected             : ',
     1          int(1.e6*e_beta_th234(i))
                stop
              endif
              do j=1,fpoint_nr
                beta(j)=probfermi_s(j)
              enddo
C Initialize random number generator by calculating the cumulative the distributions.
              call hispre(beta,fpoint_nr)
C             call rnhpre(beta,fpoint_nr)
C              write(*,*)'Beta branching state: ',i,' branch: ',
C     1        branch_th234(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                beta_th234(i,j)=beta(j)
                if(beta(j).lt.beta(j-1).and.j.ne.1)then
                   write(*,*)'Cummulative beta distribution',
     1             ' not monotonic!'
                   stop
                endif
              enddo
           enddo

C Set new seed value for the random number generator.
           is=is+85774
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'! Initialize random number generator TH234_MOMENTUM'
C Don't go in here again.
	   tfg=.true.
	endif

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

C Decay into 73.9 keV state.
        if(rndm.le.branch_th234(1))then    ! 234Th first excited state decay
           nr_part=1                       ! One particle is emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_th234(1))
             beta(j)=beta_th234(1,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!'
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_th234(1)),0.,1.,energy(1))
C          call rnhran(beta,int(1.e6*e_beta_th234(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6       ! Convert from [keV] to [GeV].

c*************************************************************************************

C Decay into second excited state 166.3 keV.
        elseif(rndm.gt.branch_th234(1).and.rndm.le.branch_th234(2))then ! decay into first excited state.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_th234(2))
             beta(j)=beta_th234(2,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!'
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_th234(2)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_th234(2,1))then
C Decay into second excited state one 92.4 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_th234(2,1)

           else
C Decay into second excited state two 62.9 + 29.5 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_th234(2,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_th234(2,3)
           endif

c*************************************************************************************

C Decay into third excited 186.7 keV state.
        elseif(rndm.gt.branch_th234(2))then ! decay into second excited state.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_th234(3))
             beta(j)=beta_th234(3,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!'
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_th234(3)),0.,1.,energy(1))
           energy(1)=energy(1)*.1e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_th234(3,1))then
C Decay into third excited state one 112.8 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_th234(3,1)
           else
C Decay into third excited state two 83.3 + 29.5 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_th234(3,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_th234(3,3)
           endif

C************************************************************************************************8

C All beta branches done.

       endif

C Save the data
        do k=1,nr_part
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(k)*(energy(k)+2.*mass(k)))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(3*k-2)=momentum_in(1)
	   momentum(3*k-1)=momentum_in(2)
	   momentum(3*k)=momentum_in(3)
        enddo

        return

        end
