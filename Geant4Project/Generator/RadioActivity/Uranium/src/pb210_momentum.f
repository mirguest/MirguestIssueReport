
      subroutine pb210_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 210Pb decay.
C
C 8/27/2001 A. Piepke
C
C 9/30/2001 A.P. Save particles rest mass. 
C

        implicit none

        include 'decay.inc'
        include 'momentum.inc'
        include 'fermi_bin.inc'

        integer i,j
	real*4 rndm,rndm_g	! Random number
        real*4 rndm3(3)
	logical*4 tfg/.false./	! Marks the first decay for which the random
				! number generator has to be initialized.
        real*4 total_energy     ! Total energy in [GeV]
        real*4 beta(nr_beta_bins_pb210) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_pb210(nr_branch_pb210,nr_beta_bins_pb210)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

	if(.not.tfg)then

C Convert branching ratios into probability distribution.
           do i=2,nr_branch_pb210
              branch_pb210(i)=branch_pb210(i)+branch_pb210(i-1)
           enddo

           do i=1,nr_branch_pb210

C              write(*,*)'Beta branching ratio : ',i, branch_pb210(i)
C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_pb210(i),83,210,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_pb210(i)))then
                 write(*,*)'>>>Beta array too long or short in: ',
     1           'pb210_momentum'
                 write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                 write(*,*)'Expected             : ',
     1           int(1.e6*e_beta_pb210(i))
                 if(fpoint_nr.gt.int(1.e6*e_beta_pb210(i)))then
                    stop
                 endif
              endif
              do j=1,fpoint_nr
                beta(j)=probfermi_s(j)
              enddo
C Initialize random number generator by calculating the cumulative the distributions.
              call hispre(beta,fpoint_nr)
C             call rnhpre(beta,fpoint_nr)
C              write(*,*)'Beta branching state: ',i,' branch: ',
C     1        branch_pb210(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                 beta_pb210(i,j)=beta(j)
C                write(*,*)j,beta(j)
                 if(beta(j).lt.beta(j-1))then
                    write(*,*)'Cummulative beta distribution',
     1              ' not monotonic!'
                    stop
C                   read(*,*)
                 endif
              enddo
C              read(*,*)
           enddo

C Set new seed value for the random number generator.
           is=is+19858585
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'! Initialize random number generator PB210_MOMENTUM'

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

c*************************************************************************************

        if(rndm.le.branch_pb210(1))then     ! 210Pb ground state decay
C Ground state decay.
           nr_part=1                       ! One particle is emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_pb210(1))
             beta(j)=beta_pb210(1,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 210Pb ground state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb210(1)),0.,1.,energy(1))
C           call rnhran(beta,int(1.e6*e_beta_pb210(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(1)=momentum_in(1)
	   momentum(2)=momentum_in(2)
	   momentum(3)=momentum_in(3)

c*************************************************************************************

        else                               ! decay into second excited state 46.5 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C           write(*,*)'Beta branch 2'
C           write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_pb210(2))
             beta(j)=beta_pb210(2,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 210Pb first exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb210(2)),0.,1.,energy(1))
C           write(*,*)'Random e energy in [keV]: ',energy(1)
C           read(*,*)
           energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(1)=momentum_in(1)
	   momentum(2)=momentum_in(2)
	   momentum(3)=momentum_in(3)

C Decay into first excited state one gamma emitted
           nr_part=2                       ! Two particles are emitted
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           energy(2)=e_gam_pb210(1)
C           write(*,*)'Gamma energy: ',energy(2)
C Convert kinetic energy into total momentum for the gamma.
           total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
	   momentum(4)=momentum_in(1)
	   momentum(5)=momentum_in(2)
	   momentum(6)=momentum_in(3)

        endif

        return

        end
