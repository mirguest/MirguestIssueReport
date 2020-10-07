
      subroutine bi214_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 214Bi beta decay.
C
C 9/11/2001 A. Piepke
C
C 9/30/2001 A.P. Save particles rest mass. 
C
C 10/27/2001 A.P. Calculation of cummulative gamma branching ratios was faulty.
C                 Index numbering was mixed up. Corrected.
C
C 11/4/2001 A.P. Handling of the "momentum" array changed. Code is shorter now.
C                Mistake in the gamma energies of state 17 corrected.
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
        real*4 beta(nr_beta_bins_bi214) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_bi214(nr_branch_bi214,nr_beta_bins_bi214)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

	if(.not.tfg)then

C Convert branching ratios into probability distribution.
           write(*,*)'! 214Bi'
           write(*,*)'! Beta branching ratio:  1',branch_bi214(1)
           do i=2,nr_branch_bi214
              branch_bi214(i)=branch_bi214(i)+branch_bi214(i-1)
              write(*,*)'! Beta branching ratio: ',i, branch_bi214(i)
           enddo
C Convert gamma branching ratios into cummulative distribution.
           do i=1,nr_branch_bi214
              write(*,*)'! Beta branch: ',i,
     1             ' gamma branching ratio:  1', 
     1             branch_gam_bi214(i,1)
              do j=2,nr_branch_gam_bi214
                 branch_gam_bi214(i,j)=branch_gam_bi214(i,j)+
     1                branch_gam_bi214(i,j-1)
                 write(*,*)'! Beta branch: ',i,
     1                ' gamma branching ratio: ',
     1                j, branch_gam_bi214(i,j)
              enddo
           enddo

           do i=1,nr_branch_bi214

C              write(*,*)'Beta branching ratio : ',i, branch_bi214(i)
C              write(*,*)'Gamma branching ratio: ',i, branch_gam_bi214(i)
C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_bi214(i),84,214,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_bi214(i)))then
                 write(*,*)'>>>Beta array too long or short in: ',
     1           'bi214_momentum'
                 write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                 write(*,*)'Expected             : ',
     1           int(1.e6*e_beta_bi214(i))
                 if(fpoint_nr.gt.int(1.e6*e_beta_bi214(i)))then
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
C     1        branch_bi214(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                 beta_bi214(i,j)=beta(j)
C                write(*,*)j,beta(j)
                 if(j.gt.1.and.beta(j).lt.beta(j-1))then
                    write(*,*)'Cummulative beta distribution',
     1              ' not monotonic!'
                    stop
C                   read(*,*)
                 endif
              enddo
C              read(*,*)
           enddo

C Set new seed value for the random number generator.
           is=is+1
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'! Initialize random number generator BI214_MOMENTUM'

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

        if(rndm.le.branch_bi214(1))then     ! 214Pb ground state decay
C Ground state decay.
           nr_part=1                       ! One particle is emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_bi214(1))
             beta(j)=beta_bi214(1,j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi ground state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(1)),0.,1.,energy(1))
C           call rnhran(beta,int(1.e6*e_beta_bi214(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(1).and.rndm.le.branch_bi214(2))then   ! Decay into first excited state 609.3 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 2'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(2))
             beta(j)=beta_bi214(2,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi first exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(2)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6

C Decay into first excited state one 609.3 keV gamma emitted
           nr_part=2                       ! Two particles are emitted
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           energy(2)=e_gam_bi214(2,1)

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(2).and.rndm.le.branch_bi214(3))then   ! Decay into second excited state 1377.7 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 3'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(3))
             beta(j)=beta_bi214(3,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi second exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(3)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(3,1))then
C Decay into second excited state one 1377.7 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(3,1)
           else
C Decay into second excited state 768.4 + 609.3 keV gammas emitted
              nr_part=3                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              energy(2)=e_gam_bi214(3,2)
              mass(2)=m_g                     ! Save rest mass
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(3,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(3).and.rndm.le.branch_bi214(4))then   ! Decay into third excited state 1415.5 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 4'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(4))
             beta(j)=beta_bi214(4,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(4)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(4,1))then
C Decay into third excited state one 1415.8 keV conversion electron emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=11                       ! Electron! This is an E0 transition.
              mass(2)=m_e                     ! Save rest mass
              energy(2)=e_gam_bi214(4,1)
           else
C Decay into third excited state two 806.2 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(4,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(4,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(4).and.rndm.le.branch_bi214(5))then   ! Decay into 4th excited state 1543.4 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 5'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(5))
             beta(j)=beta_bi214(5,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(5)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(5,1))then
C Decay into 4th excited state one 1543.4 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(5,1)
           else
C Decay into third excited state two 943.1 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(5,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(5,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(5).and.rndm.le.branch_bi214(6))then   ! Decay into 5th excited state 1661.3 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 6'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(6))
             beta(j)=beta_bi214(6,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(6)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(6,1))then
C Decay into 5th excited state one 1661.3 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(6,1)
           else
C Decay into 5th excited state two 1052.0 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(6,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(6,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(6).and.rndm.le.branch_bi214(7))then   ! Decay into 6th excited state 1729.6 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 7'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(7))
             beta(j)=beta_bi214(7,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(7)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(7,1))then
C Decay into 6th excited state one 1729.6 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(7,1)
           else
C Decay into 6th excited state two 1120.3 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(7,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(7,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(7).and.rndm.le.branch_bi214(8))then   ! Decay into 7th excited state 1764.5 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 8'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(8))
             beta(j)=beta_bi214(8,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(8)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(8,1))then
C Decay into 7th excited state one 1729.6 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(8,1)
           else
C Decay into 7th excited state two 1155.2 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(8,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(8,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(8).and.rndm.le.branch_bi214(9))then   ! Decay into 8th excited state 1847.4 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 9'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(9))
             beta(j)=beta_bi214(9,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(9)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(9,1))then
C Decay into 8th excited state one 1847.4 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(9,1)
           else
C Decay into 8th excited state two 1238.1 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(9,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(9,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(9).and.rndm.le.branch_bi214(10))then   ! Decay into 9th excited state 1890.3 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 10'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(10))
             beta(j)=beta_bi214(10,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(10)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decay into 9th excited state two 1281.0 + 609.3 keV gammas emitted
           nr_part=3                       ! Three particles are emitted
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           energy(2)=e_gam_bi214(10,1)
           pid(3)=22                       ! Gamma
           mass(3)=m_g                     ! Save rest mass
           energy(3)=e_gam_bi214(10,2)

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(10).and.
     1          rndm.le.branch_bi214(11))then ! Decay into 10th excited state 1994.6 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 11'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(11))
             beta(j)=beta_bi214(11,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(11)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(11,1))then
C Decay into 10th excited state two 1385.3 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(11,1)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(11,2)
           else
C Decay into 10th excited state three 719.9 + 665.5 + 609.3 keV gammas emitted
              nr_part=4                       ! Four particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(11,3)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(11,4)
              pid(4)=22                       ! Gamma
              mass(4)=m_g                     ! Save rest mass
              energy(4)=e_gam_bi214(11,5)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(11).and.
     1          rndm.le.branch_bi214(12))then ! Decay into 11th excited state 2010.8 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 12'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(12))
             beta(j)=beta_bi214(12,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(12)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(12,1))then
C Decay into 11th excited state two 2010.8 keV gammas emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(12,1)
           else
C Decay into 11th excited state three 1401.5 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(12,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(12,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(12).and.
     1          rndm.le.branch_bi214(13))then ! Decay into 12th excited state 2017.3 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 13'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(13))
             beta(j)=beta_bi214(13,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(13)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decay into 12th excited state three 1408.0 + 609.3 keV gammas emitted
           nr_part=3                       ! Three particles are emitted
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           energy(2)=e_gam_bi214(13,1)
           pid(3)=22                       ! Gamma
           mass(3)=m_g                     ! Save rest mass
           energy(3)=e_gam_bi214(13,2)

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(13).and.
     1          rndm.le.branch_bi214(14))then ! Decay into 13th excited state 2118.6 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 14'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(14))
             beta(j)=beta_bi214(14,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(14)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(14,1))then
C Decay into 13th excited state two 2118.6 keV gammas emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(14,1)
           else
C Decay into 13th excited state three 1509.2 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(14,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(14,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(14).and.
     1          rndm.le.branch_bi214(15))then ! Decay into 14th excited state 2204.1 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 15'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(15))
             beta(j)=beta_bi214(15,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(15)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(15,1))then
C Decay into 14th excited state two 2204.1 keV gammas emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(15,1)
           else
C Decay into 14th excited state three 1594.7 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(15,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(15,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi214(15).and.
     1          rndm.le.branch_bi214(16))then ! Decay into 15th excited state 2447.7 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 16'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(16))
             beta(j)=beta_bi214(16,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(16)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(16,1))then
C Decay into 15th excited state two 2447.9 keV gammas emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(16,1)
           elseif(rndm_g.gt.branch_gam_bi214(16,1).and.
     1             rndm_g.le.branch_gam_bi214(16,2))then
C Decay into 15th excited state three 1838.4 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(16,2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(16,3)
           elseif(rndm_g.gt.branch_gam_bi214(16,2).and.
     1             rndm_g.le.branch_gam_bi214(16,3))then
C Decay into 15th excited state three 1070.0 + 665.5 + 609.3 keV gammas emitted
              nr_part=4                       ! Four particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(16,4)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(16,5)
              pid(4)=22                       ! Gamma
              mass(4)=m_g                     ! Save rest mass
              energy(4)=e_gam_bi214(16,6)
           else
C Decay into 15th excited state three 786.1 + 1661.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(16,7)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(16,8)
           endif

c*************************************************************************************

        else                               ! Decay into 16th excited state 2482.5 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 17'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi214(17))
             beta(j)=beta_bi214(17,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1))then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 214Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi214(17)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi214(17,1))then
C Decay into 16th excited state two 1873.2 + 609.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(17,1)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(17,2)
           elseif(rndm_g.gt.branch_gam_bi214(17,1).and.
     1             rndm_g.le.branch_gam_bi214(17,2))then
C Decay into 16th excited state three 1207.7 + 665.5 + 609.3 keV gammas emitted
              nr_part=4                       ! Four particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(17,3)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(17,4)
              pid(4)=22                       ! Gamma
              mass(4)=m_g                     ! Save rest mass
              energy(4)=e_gam_bi214(17,5)
           elseif(rndm_g.gt.branch_gam_bi214(17,2).and.
     1             rndm_g.le.branch_gam_bi214(17,3))then
C Decay into 16th excited state tow 821.2 + 1661.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(17,6)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(17,7)
           elseif(rndm_g.gt.branch_gam_bi214(17,3).and.
     1             rndm_g.le.branch_gam_bi214(17,4))then
C Decay into 16th excited state two 752.9 + 1120.3 + 609.3 keV gammas emitted
              nr_part=4                       ! Four particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(17,8)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(17,9)
              pid(4)=22                       ! Gamma
              mass(4)=m_g                     ! Save rest mass
              energy(4)=e_gam_bi214(17,10)
           else
C Decay into 16th excited state three 273.9 + 1599.3 + 609.3 keV gammas emitted
              nr_part=4                       ! Four particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi214(17,11)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi214(17,12)
              pid(4)=22                       ! Gamma
              mass(4)=m_g                     ! Save rest mass
              energy(4)=e_gam_bi214(17,13)
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
