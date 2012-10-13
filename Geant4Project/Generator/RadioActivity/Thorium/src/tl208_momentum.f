
      subroutine tl208_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 208Tl beta decay.
C
C 10/23/2001 A. Piepke
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
        real*4 beta(nr_beta_bins_tl208) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_tl208(nr_branch_tl208,nr_beta_bins_tl208)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

	if(.not.tfg)then

C Convert branching ratios into probability distribution.
           write(*,*)'208Tl'
           write(*,*)'Beta branching ratio :  1', branch_tl208(1)
           do i=1,nr_branch_tl208
              if(i.gt.1)then
                 branch_tl208(i)=branch_tl208(i)+branch_tl208(i-1)
                 write(*,*)'Beta branching ratio : ',i, branch_tl208(i)
              endif
              write(*,*)'Gamma branching ratio: ',i,' 1',
     1                  branch_gam_tl208(i,1)
              do j=2,nr_branch_gam_tl208
                 branch_gam_tl208(i,j)=branch_gam_tl208(i,j)+
     1                            branch_gam_tl208(i,j-1)
              write(*,*)'Gamma branching ratio: ',
     1                  i,j, branch_gam_tl208(i,j)
              enddo
           enddo

           do i=1,nr_branch_tl208

C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_tl208(i),82,208,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_tl208(i)))then
                 write(*,*)'>>>Beta array too long or short in: ',
     1           'tl208_momentum'
                 write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                 write(*,*)'Expected             : ',
     1           int(1.e6*e_beta_tl208(i))
                 if(fpoint_nr.gt.int(1.e6*e_beta_tl208(i)))then
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
C     1        branch_tl208(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                 beta_tl208(i,j)=beta(j)
C                write(*,*)j,beta(j)
                 if(beta(j).lt.beta(j-1).and.j.ne.1)then
                    write(*,*)'Cummulative beta distribution',
     1              ' not monotonic!'
                    stop
C                   read(*,*)
                 endif
              enddo
C              read(*,*)
           enddo

C Set new seed value for the random number generator.
           is=is+54321
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'Initialize random number generator TL208_MOMENTUM'

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

        if(rndm.le.branch_tl208(1))then    ! E=3197.8 keV excited state
C Decay into E=3197.8 keV excited state.
           nr_part=3                       ! Three particles are emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           pid(2)=22                       ! Gamma
           mass(2)=m_g
           pid(3)=22                       ! Gamma
           mass(3)=m_g
C Get random beta energy
           do j=1,int(1.e6*e_beta_tl208(1))
             beta(j)=beta_tl208(1,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 208Tl first excited state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_tl208(1)),0.,1.,energy(1))
C           call rnhran(beta,int(1.e6*e_beta_tl208(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6
C Get gamma energy
           energy(2)=e_gam_tl208(1,1)
           energy(3)=e_gam_tl208(1,2)

c*************************************************************************************

        elseif(rndm.gt.branch_tl208(1).and.rndm.le.branch_tl208(2))then   ! Decay into excited state E=3475.1 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 2'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_tl208(2))
             beta(j)=beta_tl208(2,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 208Tl second exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_tl208(2)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_tl208(2,1))then
C Decay into second excited state 860.6 & 2614.6 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_tl208(2,1)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_tl208(2,2)
           else

C Nuclear M1 transition has high conversion coefficient (c=0.54). Decide between
C Gamma and conversion electron. Wheighted average of K-shell capture x-ray
C energies is 76.6 keV for Pb.

              call ranlux(rndm_conv,1)
              if(rndm_conv.le.branch_gam_conv_tl208(1))then
C Decay into second excited state 277.4 & 583.2 & 2614.6 keV gammas emitted
                 nr_part=4                       ! Four particles are emitted
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! Save rest mass
                 energy(2)=e_gam_tl208(2,3)
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! Save rest mass
                 energy(3)=e_gam_tl208(2,4)
                 pid(4)=22                       ! Gamma
                 mass(4)=m_g                     ! Save rest mass
                 energy(4)=e_gam_tl208(2,5)
              else
C Convesrion electron and x-ray emitted.
C Decay into second excited state 203.5(e-) & 73.9(x-ray) & 583.2 & 2614.6 keV gammas emitted
                 nr_part=5                       ! Five particles are emitted
                 pid(2)=11                       ! Conversion electron
                 mass(2)=m_e                     ! Save rest mass
                 energy(2)=e_gam_tl208(2,3)-x_ray_tl208
                 pid(3)=22                       ! x-ray
                 mass(3)=m_g        
                 energy(3)=x_ray_tl208
                 pid(4)=22                       ! Gamma
                 mass(4)=m_g                     ! Save rest mass
                 energy(4)=e_gam_tl208(2,4)
                 pid(5)=22                       ! Gamma
                 mass(5)=m_g                     ! Save rest mass
                 energy(5)=e_gam_tl208(2,5)
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_tl208(2).and.rndm.le.branch_tl208(3))then   ! Decay into third excited state E=3708.4 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 3'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_tl208(3))
             beta(j)=beta_tl208(3,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 208Tl third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_tl208(3)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6

C Nuclear M1 transition has high conversion coefficient (c=0.90). Decide between
C Gamma and conversion electron. Wheighted average of K-shell capture x-ray
C energies is 76.6 keV for Pb.

           call ranlux(rndm_conv,1)
           if(rndm_conv.le.branch_gam_conv_tl208(1))then
C Decay into third excited state 510.8 & 583.2 & 2614.6 keV gamma emitted
              nr_part=4                       ! Four particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_tl208(3,1)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_tl208(3,2)
              pid(4)=22                       ! Gamma
              mass(4)=m_g                     ! Save rest mass
              energy(4)=e_gam_tl208(3,3)
           else
C Decay into third excited state 436.9(e-) & 73.9(x-ray) & 583.2 & 2614.6 keV gamma emitted
              nr_part=5                       ! Five particles are emitted
              pid(2)=11                       ! Conversion electron
              mass(2)=m_e                     ! Save rest mass
              energy(2)=e_gam_tl208(3,1)-x_ray_tl208
              pid(3)=22                       ! x-ray
              mass(3)=m_g                     ! Save rest mass
              energy(3)=x_ray_tl208
              pid(4)=22                       ! Gamma
              mass(4)=m_g                     ! Save rest mass
              energy(4)=e_gam_tl208(3,2)
              pid(5)=22                       ! Gamma
              mass(5)=m_g                     ! Save rest mass
              energy(5)=e_gam_tl208(3,3)
           endif
           
c*************************************************************************************

        else                               ! Decay into fourth excited state 3961.0 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 4'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_tl208(4))
             beta(j)=beta_tl208(4,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 208Tl third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_tl208(4)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_tl208(4,1))then
C Decay into fourth excited state 763.4 & 583.2 & 2614.6 keV gammas emitted
              nr_part=4                       ! Four particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_tl208(4,1)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_tl208(4,2)
              pid(4)=22                       ! Gamma
              mass(4)=m_g                     ! Save rest mass
              energy(4)=e_gam_tl208(4,3)
           else

C Nuclear M1 transition has high conversion coefficient (c=0.70). Decide between
C Gamma and conversion electron. Wheighted average of K-shell capture x-ray
C energies is 76.6 keV for Pb.

              call ranlux(rndm_conv,1)
              if(rndm_conv.le.branch_gam_conv_tl208(3))then
C Decay into fourth excited state 252.6 & 510.8 & 583.2 & 2614.6 keV gammas emitted
                 nr_part=5                       ! Five particles are emitted
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! Save rest mass
                 energy(2)=e_gam_tl208(4,4)
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! Save rest mass
                 energy(3)=e_gam_tl208(4,5)
                 pid(4)=22                       ! Gamma
                 mass(4)=m_g                     ! Save rest mass
                 energy(4)=e_gam_tl208(4,6)
                 pid(5)=22                       ! Gamma
                 mass(5)=m_g                     ! Save rest mass
                 energy(5)=e_gam_tl208(4,7)
              else
C 252.6 keV is converted.
C Decay into fourth excited state 252.6 & 510.8 & 583.2 & 2614.6 keV gammas emitted
                 nr_part=6                       ! Six particles are emitted
                 pid(2)=11                       ! Conversion electron
                 mass(2)=m_e                     ! Save rest mass
                 energy(2)=e_gam_tl208(4,4)-x_ray_tl208
                 pid(3)=22                       ! x-ray
                 mass(3)=m_g
                 energy(3)=x_ray_tl208
                 pid(4)=22                       ! Gamma
                 mass(4)=m_g                     ! Save rest mass
                 energy(4)=e_gam_tl208(4,5)
                 pid(5)=22                       ! Gamma
                 mass(5)=m_g                     ! Save rest mass
                 energy(5)=e_gam_tl208(4,6)
                 pid(6)=22                       ! Gamma
                 mass(6)=m_g                     ! Save rest mass
                 energy(6)=e_gam_tl208(4,7)
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
