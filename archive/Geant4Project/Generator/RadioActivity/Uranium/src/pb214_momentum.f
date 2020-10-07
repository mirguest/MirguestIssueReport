
      subroutine pb214_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 214Pb beta decay.
C
C 8/29/2001 A. Piepke
C
C 9/30/2001 A.P. Save particles rest mass. 
C
C 10/27/2001 A.P. Calculation of cummulative gamma branching ratios was faulty.
C                 Index numbering was mixed up. Corrected.
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
        real*4 beta(nr_beta_bins_pb214) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_pb214(nr_branch_pb214,nr_beta_bins_pb214)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

	if(.not.tfg)then

C Convert branching ratios into probability distribution.
           write(*,*)'! 214Pb'
           write(*,*)'! Beta branching ratio:  1',branch_pb214(1)
           do i=2,nr_branch_pb214
              branch_pb214(i)=branch_pb214(i)+branch_pb214(i-1)
              write(*,*)'! Beta branching ratio: ',i, branch_pb214(i)
           enddo
C Convert gamma branching ratios into cummulative distribution.
           do i=1,nr_branch_pb214
              write(*,*)'! Beta branch: ',i,
     1             ' gamma branching ratio:  1', 
     1             branch_gam_pb214(i,1)
              do j=2,nr_branch_gam_pb214
                 branch_gam_pb214(i,j)=branch_gam_pb214(i,j)+
     1                branch_gam_pb214(i,j-1)
                 write(*,*)'! Beta branch: ',i,
     1                ' gamma branching ratio: ',
     1                j, branch_gam_pb214(i,j)
              enddo
           enddo

           do i=1,nr_branch_pb214

C              write(*,*)'Beta branching ratio : ',i, branch_pb214(i)
C              write(*,*)'Gamma branching ratio: ',i, branch_gam_pb214(i)
C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_pb214(i),83,214,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_pb214(i)))then
                 write(*,*)'>>>Beta array too long or short in: ',
     1           'pb214_momentum'
                 write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                 write(*,*)'Expected             : ',
     1           int(1.e6*e_beta_pb214(i))
                 if(fpoint_nr.gt.int(1.e6*e_beta_pb214(i)))then
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
C     1        branch_pb214(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                 beta_pb214(i,j)=beta(j)
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
           is=is+81523452
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'! Initialize random number generator PB214_MOMENTUM'

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

        if(rndm.le.branch_pb214(1))then     ! 214Pb ground state decay
C Ground state decay.
           nr_part=1                       ! One particle is emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_pb214(1))
             beta(j)=beta_pb214(1,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Pb ground state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb214(1)),0.,1.,energy(1))
C           call rnhran(beta,int(1.e6*e_beta_pb214(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

c*************************************************************************************

        elseif(rndm.gt.branch_pb214(1).and.rndm.le.branch_pb214(2))then   ! Decay into first excited state 295.2 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 2'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_pb214(2))
             beta(j)=beta_pb214(2,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Pb first exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb214(2)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_pb214(2,1))then
C Decay into first excited state one 295.2 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(2,1)

           else
C Decay into first excited state two 242.0 + 53.2 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(2,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_pb214(2,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_pb214(2).and.rndm.le.branch_pb214(3))then   ! Decay into second excited state 351.9 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 3'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_pb214(3))
             beta(j)=beta_pb214(3,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Pb second exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb214(3)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decay into second excited state one 351.9 keV gamma emitted
           nr_part=2                       ! Two particles are emitted
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           energy(2)=e_gam_pb214(3,1)

c*************************************************************************************

        elseif(rndm.gt.branch_pb214(3).and.rndm.le.branch_pb214(4))then   ! Decay into third excited state 533.7 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 4'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_pb214(4))
             beta(j)=beta_pb214(4,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Pb third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb214(4)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_pb214(4,1))then
C Decay into third excited state one 533.6 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(4,1)

           elseif(rndm_g.gt.branch_gam_pb214(4,1).and.
     1            rndm_g.le.branch_gam_pb214(4,2))then
C Decay into third excited state two 480.4 + 53.2 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(4,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_pb214(4,3)
           else
C Decay into first excited state two 274.8 + 258.9 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(4,4)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_pb214(4,5)
           endif

c*************************************************************************************

        else                          ! Decay into fourth excited state 839.0 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 5'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_pb214(5))
             beta(j)=beta_pb214(5,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Pb fourth exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_pb214(5)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_pb214(5,1))then
C Decay into third excited state one 839.0 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(5,1)

           elseif(rndm_g.gt.branch_gam_pb214(5,1).and.
     1            rndm_g.le.branch_gam_pb214(5,2))then
C Decay into first excited state two 786.0 + 53.2 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(5,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_pb214(5,3)
           elseif(rndm_g.gt.branch_gam_pb214(5,2).and.
     1            rndm_g.le.branch_gam_pb214(5,3))then
C Decay into first excited state two 580.1 + 258.9 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(5,4)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_pb214(5,5)
           else
C Decay into first excited state two 487.1 + 351.9 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_pb214(5,6)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_pb214(5,7)
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
