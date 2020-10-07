
      subroutine pb212_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 212Pb beta decay.
C
C 10/22/2001 A. Piepke
C
C 10/28/2001 A.P. Implemented internal conversion for 115 & 238.6 & 300.1 keV transitions.
C                 These energies are close to the solar threshold.
C

        implicit none

        include 'decay_th.inc'
        include 'momentum.inc'
        include 'fermi_bin.inc'

        integer i,j,k
	real*4 rndm,rndm_g,rndm_conv	! Random number
        real*4 rndm3(3)
	logical*4 tfg/.false./	! Marks the first decay for which the random
				! number generator has to be initialized.
        real*4 total_energy     ! Total energy in [GeV]
        real*4 beta(nr_beta_bins_pb212) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_pb212(nr_branch_pb212,nr_beta_bins_pb212)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

	if(.not.tfg)then

C Convert branching ratios into probability distribution.
           write(*,*)'212Pb'
           write(*,*)'Beta branching ratio :  1', branch_pb212(1)
           do i=1,nr_branch_pb212
              if(i.gt.1)then
                 branch_pb212(i)=branch_pb212(i)+branch_pb212(i-1)
                 write(*,*)'Beta branching ratio : ',i, branch_pb212(i)
              endif
              write(*,*)'Gamma branching ratio: ',i,' 1',
     1        branch_gam_pb212(i,1)
              do j=2,nr_branch_gam_pb212
                 branch_gam_pb212(i,j)=branch_gam_pb212(i,j)+
     1                            branch_gam_pb212(i,j-1)
              write(*,*)'Gamma branching ratio: ',
     1        i,j, branch_gam_pb212(i,j)
              enddo
           enddo

           do i=1,nr_branch_pb212

C              write(*,*)'Beta branching ratio : ',i, branch_pb212(i)
C              write(*,*)'Gamma branching ratio: ',i, branch_gam_pb212(i)
C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_pb212(i),83,212,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_pb212(i)))then
                 write(*,*)'>>>Beta array too long or short in: ',
     1           'pb212_momentum'
                 write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                 write(*,*)'Expected             : ',
     1           int(1.e6*e_beta_pb212(i))
                 if(fpoint_nr.gt.int(1.e6*e_beta_pb212(i)))then
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
C     1        branch_pb212(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                 beta_pb212(i,j)=beta(j)
C                write(*,*)j,beta(j)
                 if(beta(j).lt.beta(j-1).and.j.ne.1)then
                    write(*,*)'212Pb Cummulative beta distribution',
     1              ' not monotonic!'
                    stop
C                   read(*,*)
                 endif
              enddo
C              read(*,*)
           enddo

C Set new seed value for the random number generator.
           is=is+990181599
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'Initialize random number generator PB212_MOMENTUM'

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

        if(rndm.le.branch_pb212(1))then     ! 212Pb ground state decay
C Ground state decay.
           nr_part=1                       ! One particle is emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_pb212(1))
             beta(j)=beta_pb212(1,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 212Pb ground state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb212(1)),0.,1.,energy(1))
C           call rnhran(beta,int(1.e6*e_beta_pb212(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

c*************************************************************************************

        elseif(rndm.gt.branch_pb212(1).and.rndm.le.branch_pb212(2))then   ! Decay into state 238.6 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 2'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_pb212(2))
             beta(j)=beta_pb212(2,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 212Pb first exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb212(2)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6

C Nuclear M1 transition has high conversion coefficient (c=0.9). Decide between
C Gamma and conversion electron. Wheighted average of K-shell capture x-ray
C energies is 78.7 keV for Bi.

           call ranlux(rndm_conv,1)
           if(rndm_conv.le.branch_gam_conv_pb212(1))then
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb212(2,1)
           else
              nr_part=3                       ! Two particles are emitted
              pid(2)=11                       ! Conversion electron
              mass(2)=m_e                     ! Save rest mass
              energy(2)=e_gam_pb212(2,1)-x_ray_pb212  ! Less x-ray energy
              pid(3)=22                       ! x-ray
              mass(3)=m_g                     ! Save rest mass
              energy(3)=x_ray_pb212           ! x-ray energy
           endif

c*************************************************************************************

        else                               ! Decay into excited state 415.3 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 3'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_pb212(3))
             beta(j)=beta_pb212(3,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 212Pb second exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb212(3)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
C One 415.2 keV gamma emitted
           if(rndm_g.le.branch_gam_pb212(3,1))then
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb212(3,1)

C Two gammas emitted: 300.1 keV & 115.2 keV. Conversion implemented.
           else

C Nuclear 300 keV M1 transition has high conversion coefficient (c=0.47). Decide between
C Gamma and conversion electron. Wheighted average of K-shell capture x-ray
C energies is 78.7 keV for Bi.

              call ranlux(rndm_conv,1)
              if(rndm_conv.le.branch_gam_conv_pb212(2))then
                 nr_part=4                       ! Four particles are emitted
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! Save rest mass
                 energy(2)=e_gam_pb212(3,2)
                 pid(3)=11                       ! Conversion electron
                 mass(3)=m_e                     ! Save rest mass
                 energy(3)=e_gam_pb212(3,3)-x_ray_pb212 ! This transition is fully converted (c=7.0)
                 pid(4)=22
                 mass(4)=m_g
                 energy(4)=x_ray_pb212
              else
                 nr_part=5                       ! Five particles are emitted
                 pid(2)=11                       ! Conversion electron
                 mass(2)=m_e                     ! 
                 energy(2)=e_gam_pb212(3,2)-x_ray_pb212
                 pid(3)=22
                 mass(3)=m_g
                 energy(3)=x_ray_pb212
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! Save rest mass
                 energy(4)=e_gam_pb212(3,3)-x_ray_pb212 ! This transition is fully converted (c=7.0)
                 pid(5)=22
                 mass(5)=m_g
                 energy(5)=x_ray_pb212
              endif
           endif

c*************************************************************************************

        endif

c*************************************************************************************
c*************************************************************************************

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
