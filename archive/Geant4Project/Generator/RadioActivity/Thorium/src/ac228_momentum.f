
      subroutine ac228_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 228Ac beta decay.
C
C 11/1/2001 A. Piepke
C

        implicit none

        include 'decay_th.inc'
        include 'momentum.inc'
        include 'fermi_bin.inc'

        integer i,j,k
        real*4 rndm,rndm_g,rndm_g1,rndm_g2,rndm_conv,rndm_conv1 ! Random numbers
        real*4 rndm3(3)
        logical*4 tfg/.false./  ! Marks the first decay for which the random
                                ! number generator has to be initialized.
        real*4 total_energy     ! Total energy in [GeV]
        real*4 beta(nr_beta_bins_ac228) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_ac228(nr_branch_ac228,nr_beta_bins_ac228)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

        if(.not.tfg)then

C Convert branching ratios into probability distribution.
           write(*,*)'>>>228Ac'
           write(*,*)'Beta branching ratio :  1', branch_ac228(1)
           do i=1,nr_branch_ac228               ! i: Loop over the excited states
              if(i.gt.1)then
                 branch_ac228(i)=branch_ac228(i)+branch_ac228(i-1)
                 write(*,*)'Beta branching ratio : ',i, branch_ac228(i)
              endif
              do k=1,nr_branch_gam_ac228_level  ! k: Loop over all sub levels
                 write(*,*)'Gamma branching ratio: ',i,k,' 1',
     1           branch_gam_ac228(i,k,1)
                 do j=2,nr_branch_gam1_ac228
                    branch_gam_ac228(i,k,j)=branch_gam_ac228(i,k,j)+
     1                            branch_gam_ac228(i,k,j-1)
                    write(*,*)'Gamma branching ratio: ',
     1              i,k,j, branch_gam_ac228(i,k,j)
                 enddo
              enddo
           enddo

C Loop over all excited states

           do i=1,nr_branch_ac228

C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_ac228(i),90,228,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_ac228(i)))then
                 write(*,*)'>>>Beta array too long or short in: ',
     1           'ac228_momentum'
                 write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                 write(*,*)'Expected             : ',
     1           int(1.e6*e_beta_ac228(i))
                 if(fpoint_nr.gt.int(1.e6*e_beta_ac228(i)))then
                    stop
                 endif
              endif
              fpoint_nr = int(1.e6*e_beta_ac228(i))
              do j=1,fpoint_nr
                beta(j)=probfermi_s(j)
              enddo
C Initialize random number generator by calculating the cumulative the distributions.
              call hispre(beta,fpoint_nr)
C             call rnhpre(beta,fpoint_nr)
C              write(*,*)'Beta branching state: ',i,' branch: ',
C     1        branch_ac228(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                 beta_ac228(i,j)=beta(j)
C                write(*,*)j,beta(j)
                 if(beta(j).lt.beta(j-1).and.j.ne.1)then
                    write(*,*)'228Ac cummulative beta distribution',
     1              ' not monotonic! Array filling'
                    stop
C                   read(*,*)
                 endif
              enddo
C              read(*,*)
           enddo

C Set new seed value for the random number generator.
           is=is+84884
           call rluxgo(lux,is,0,0)! Set new seed values. 
           write(*,*)'Initialize random number generator AC228_MOMENTUM'

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

        if(rndm.le.branch_ac228(1))then    ! E=57.8 keV excited state
C Decay into E=57.8 keV excited state.
           pid(1)=11                       ! Beta electron
           mass(1)=m_e                     ! 
C Get random beta energy
           do j=1,int(1.e6*e_beta_ac228(1))
             beta(j)=beta_ac228(1,j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 57.8 keV state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(1)),0.,1.,energy(1))
C           call rnhran(beta,int(1.e6*e_beta_ac228(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6
C Get gamma energy
           nr_part=2                       ! Two particles are emitted
           pid(2)=11                       ! Conversion electron
           mass(2)=m_e
           energy(2)=e_gam_ac228(1,1)

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(1).and.rndm.le.branch_ac228(2))then   ! Decay into excited state E=396.1 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 2'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(2))
             beta(j)=beta_ac228(2,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 396.1 keV state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(2)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(2,1,1))then
C Decay into second excited state 338.3 & 57.8 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(2,1)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     !
              energy(3)=e_gam_ac228(2,2)
           else
C Decay into second excited state 209.3 & 129.1 & 57.8 keV gammas or conversion.
C Decide whether 129.1 keV transition should be converted.
              call ranlux(rndm_conv,1)
              if(rndm_conv.le.branch_gam_conv_ac228(1))then   ! Gamma emission

C Decay into second excited state 209.3 & 129.1 & 57.8 keV (converted) gammas emitted
                 nr_part=4                       ! Four particles are emitted
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! 
                 energy(2)=e_gam_ac228(2,3)
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(2,4)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(2,5)
              else
C Decay into second excited state 209.3 & 129.1 (converted) & 57.8 keV (converted) gammas emitted
                 nr_part=5                       ! Five particles are emitted
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! 
                 energy(2)=e_gam_ac228(2,3)
                 pid(3)=11                       ! Conversion electron
                 mass(3)=m_e                     ! 
                 energy(3)=e_gam_ac228(2,4)-x_ray_k_ac228
                 pid(4)=22                       ! K x-ray
                 mass(4)=m_g                     ! 
                 energy(4)=x_ray_k_ac228
                 pid(5)=11                       ! Conversion electron
                 mass(5)=m_e                     ! 
                 energy(5)=e_gam_ac228(2,5)
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(2).and.rndm.le.branch_ac228(3))then   ! Decay into third excited state E=969.0 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 3'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(3))
             beta(j)=beta_ac228(3,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 969.0 keV state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(3)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(3,1,1))then
C Decay into 3rd excited state 969.0 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(3,1)
           else
C Decay into 3rd excited state 911.2 & 57.8 (converted) keV gammas or conversion.
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(3,2)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(3,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(3).and.rndm.le.branch_ac228(4))then   ! Decay into fourth excited state E=1022.5 keV.

C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 4'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(4))
             beta(j)=beta_ac228(4,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1022.5 keV state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(4)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(4,1,1))then
C Decay into 4th excited state 968.8 * 57.8 (converted) keV gamma emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(4,1)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(4,2)
           else
C Decay into 4th excited state 835.7 & 129.1 (converted) & 57.8 (converted) keV gammas or conversion.
C Decide whether 129.1 keV transition should be converted.
              call ranlux(rndm_conv,1)
              if(rndm_conv.le.branch_gam_conv_ac228(1))then   ! 1291.1 keV: gamma emission
                 nr_part=4                       ! Four particles are emitted
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! 
                 energy(2)=e_gam_ac228(4,3)
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(4,4)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(4,5)
              else                               ! 129.1 keV: conversion electron emission
                 nr_part=5                       ! Five particles are emitted
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! 
                 energy(2)=e_gam_ac228(4,3)
                 pid(3)=11                       ! Conversion electron
                 mass(3)=m_e                     ! 
                 energy(3)=e_gam_ac228(4,4)-x_ray_k_ac228
                 pid(4)=22                       ! Conversion electron
                 mass(4)=m_g                     ! 
                 energy(4)=x_ray_k_ac228         ! 
                 pid(5)=11                       ! K x-ray
                 mass(5)=m_e                     ! 
                 energy(5)=e_gam_ac228(4,5)
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(4).and.rndm.le.branch_ac228(5))then   ! Decay into fifth excited state E=1123.0 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 5'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(5))
             beta(j)=beta_ac228(5,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1123.0 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(5)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(5,1,1))then
C Emit 1065.2 keV gamma
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(5,1)
C Decide which gammas should follow
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(5,2,1))then
C Emit 328 keV gamma
                 nr_part=3                       ! Three particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(5,2)
              else
C Decay 270 & 57.8 (converted) keV.
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(5,4)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(5,5)
              endif
           elseif(rndm_g.gt.branch_gam_ac228(5,1,1).and.rndm_g.le.
     1            branch_gam_ac228(5,1,2))then
C Emit 795.0 keV gamma.
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(5,6)
C Decide which gammas should follow
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(5,3,1))then
C Emit 338.3 & 57.8 (converted) keV gammas
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(5,7)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(5,8)
              else
C Emit 209.3 & 129.1 & 57.8 (converted) gammas
C Decide whether 129.1 keV transition should be converted.
                 call ranlux(rndm_conv,1)
                 if(rndm_conv.le.branch_gam_conv_ac228(1))then   ! 129.1 keV gamma emission
                    nr_part=5                       ! Five particles are emitted
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(5,10)
                    pid(4)=22                       ! Gamma
                    mass(4)=m_g                     ! 
                    energy(4)=e_gam_ac228(5,11)
                    pid(5)=11                       ! Conversion electron
                    mass(5)=m_e
                    energy(5)=e_gam_ac228(5,12)
                 else                               ! 129.1 keV converted
                    nr_part=6                       ! Six particles are emitted
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(5,10)
                    pid(4)=11                       ! Conversion electron
                    mass(4)=m_e                     ! 
                    energy(4)=e_gam_ac228(5,11)-x_ray_k_ac228
                    pid(5)=22                       ! K x-ray
                    mass(5)=m_g
                    energy(5)=x_ray_k_ac228
                    pid(6)=11                       ! Conversion electron
                    mass(6)=m_e
                    energy(6)=e_gam_ac228(5,12)
                 endif
              endif
           else
C Emit 154.0 keV gamma.
C Decide whether 154.0 keV transition should be converted.
              call ranlux(rndm_conv,1)
              if(rndm_conv.le.branch_gam_conv_ac228(2))then   ! 154.0 keV gamma emission
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! 
                 energy(2)=e_gam_ac228(5,13)
C Decide which gammas should follow
                 call ranlux(rndm_g1,1)
                 if(rndm_g1.le.branch_gam_ac228(5,4,1))then
C Emit 969.0 keV gamma
                    nr_part=3                       ! Three particles are emitted
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(5,14)
                 else
C Emit 911.2 & 57.8 (converted) gammas
                    nr_part=4                       ! Four particles are emitted
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(5,16)
                    pid(4)=11                       ! Conversion electron
                    mass(4)=m_e                     ! 
                    energy(4)=e_gam_ac228(5,17)
                 endif
              else                                  ! 154.0 keV transition is converted
                 pid(2)=11                       ! Conversion electron
                 mass(2)=m_e                     ! 
                 energy(2)=e_gam_ac228(5,13)-x_ray_k_ac228
                 pid(3)=22                       ! K x-ray
                 mass(3)=m_g                     ! 
                 energy(3)=x_ray_k_ac228
C Decide which gammas should follow
                 call ranlux(rndm_g1,1)
                 if(rndm_g1.le.branch_gam_ac228(5,4,1))then
C Emit 969.0 keV gamma
                    nr_part=4                       ! Four particles are emitted
                    pid(4)=22                       ! Gamma
                    mass(4)=m_g                     ! 
                    energy(4)=e_gam_ac228(5,14)
                 else
C Emit 911.2 & 57.8 (converted) gammas
                    nr_part=5                       ! Five particles are emitted
                    pid(4)=22                       ! Gamma
                    mass(4)=m_g                     ! 
                    energy(4)=e_gam_ac228(5,16)
                    pid(5)=11                       ! Conversion electron
                    mass(5)=m_e                     ! 
                    energy(5)=e_gam_ac228(5,17)
                 endif
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(5).and.rndm.le.branch_ac228(6))then   ! Decay into sixth excited state E=1153.5 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 6'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(6))
             beta(j)=beta_ac228(6,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1153.5 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(6)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(6,1,1))then
C Emit 1053.5 keV gamma
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(6,1)
           elseif(rndm_g.gt.branch_gam_ac228(6,1,1).and.
     1     rndm_g.le.branch_gam_ac228(6,1,2))then
C Emit 1095.7 keV gamma.
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(6,2)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(6,3)
           elseif(rndm_g.gt.branch_gam_ac228(6,1,2).and.rndm_g.le.
     1            branch_gam_ac228(6,1,3))then
C Emit 321.6 keV gamma.
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(6,4)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! 
              energy(3)=e_gam_ac228(6,5)
           else
C Emit 278.7 keV gamma/e.
C Decide whether 278.7 keV transition should be converted.
              call ranlux(rndm_conv,1)
              if(rndm_conv.le.branch_gam_conv_ac228(3))then   ! 278.7 keV gamma emission
C Emit 278.7 keV gamma
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! 
                 energy(2)=e_gam_ac228(6,6)
C Decide which gammas should follow
                 call ranlux(rndm_g1,1)
                 if(rndm_g1.le.branch_gam_ac228(6,2,1))then
C Emit 688.1 keV gamma
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(6,7)
C Decide whether 129.1 keV transition should be converted.
                    call ranlux(rndm_conv1,1)
                    if(rndm_conv1.le.branch_gam_conv_ac228(1))then   ! 129.1 keV gamma emission
C Emit 129.1 keV gamma
                       nr_part=5                    ! Five particles are emitted
                       pid(4)=22                    ! Gamma
                       mass(4)=m_g                  ! 
                       energy(4)=e_gam_ac228(6,8)
                       pid(5)=11                    ! Conversion electron
                       mass(5)=m_e                  ! 
                       energy(5)=e_gam_ac228(6,9)
                    else
C Emit 129.1 keV transition converted
                       nr_part=6                    ! Six particles are emitted
                       pid(4)=11                    ! Conversion electron
                       mass(4)=m_e                  ! 
                       energy(4)=e_gam_ac228(6,8)-x_ray_k_ac228
                       pid(5)=22                    ! K x-ray
                       mass(5)=m_g                  ! 
                       energy(5)=x_ray_k_ac228
                       pid(6)=11                    ! Conversion electron
                       mass(6)=m_e                  ! 
                       energy(6)=e_gam_ac228(6,9)
                    endif
                 elseif(rndm_g.gt.branch_gam_ac228(6,2,1).and.
     1                  rndm_g.le.branch_gam_ac228(6,2,2))then
C Emit 546.5 keV gamma
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(6,11)
C Decide which gammas should follow
                    call ranlux(rndm_g2,1)
                    if(rndm_g2.le.branch_gam_ac228(6,3,1))then
C Emit 328.0 keV gamma
                       nr_part=4                    ! Four particles are emitted
                       pid(4)=22                    ! Gamma
                       mass(4)=m_g                  ! 
                       energy(4)=e_gam_ac228(6,12)
                    else
C Emit 270.2 & 57.8 (converted) gammas
                       nr_part=5                    ! Five particles are emitted
                       pid(4)=22                    ! Gamma
                       mass(4)=m_g                  ! 
                       energy(4)=e_gam_ac228(6,15)
                       pid(5)=11                    ! Conversion electron
                       mass(5)=m_e                  ! 
                       energy(5)=e_gam_ac228(6,16)
                    endif
                 else 
C Emit 478.8 keV gamma
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(6,18)
C Decide which gammas should follow
                    call ranlux(rndm_g2,1)
                    if(rndm_g2.le.branch_gam_ac228(6,4,1))then
C Emit 338.3 & 57.8 (converted) keV gammas
                       nr_part=5                    ! Five particles are emitted
                       pid(4)=22                    ! Gamma
                       mass(4)=m_g                  ! 
                       energy(4)=e_gam_ac228(6,19)
                       pid(5)=11                    ! Conversion electron
                       mass(5)=m_e                  ! 
                       energy(5)=e_gam_ac228(6,20)                    
                    else
C Emit 209.3 & 129.1 & 57.8 (converted) keV gammas
                       nr_part=6                    ! Six particles are emitted
                       pid(4)=22                    ! Gamma
                       mass(4)=m_g                  ! 
                       energy(4)=e_gam_ac228(6,23)
                       pid(5)=22                    ! Gamma
                       mass(5)=m_g                  ! 
                       energy(5)=e_gam_ac228(6,24)
                       pid(6)=11                    ! Conversion electron
                       mass(6)=m_e                  ! 
                       energy(6)=e_gam_ac228(6,25)                    
                    endif
                 endif

              else                               ! 278.7 keV transition is converted
C Emit 278.7 keV converted
                 pid(2)=11                       ! Conversion electron
                 mass(2)=m_e                     ! 
                 energy(2)=e_gam_ac228(6,6)-x_ray_k_ac228
                 pid(3)=22                       ! K x-ray
                 mass(3)=m_g                     ! 
                 energy(3)=x_ray_k_ac228
C Decide which gammas should follow
                 call ranlux(rndm_g1,1)
                 if(rndm_g1.le.branch_gam_ac228(6,2,1))then
C Emit 688.1 keV gamma
                    pid(4)=22                       ! Gamma
                    mass(4)=m_g                     ! 
                    energy(4)=e_gam_ac228(6,7)
C Decide whether 129.1 keV transition should be converted.
                    call ranlux(rndm_conv1,1)
                    if(rndm_conv1.le.branch_gam_conv_ac228(1))then   ! 129.1 keV gamma emission
C Emit 129.1 keV gamma
                       nr_part=6                    ! Six particles are emitted
                       pid(5)=22                    ! Gamma
                       mass(5)=m_g                  ! 
                       energy(5)=e_gam_ac228(6,8)
                       pid(6)=11                    ! Conversion electron
                       mass(6)=m_e                  ! 
                       energy(6)=e_gam_ac228(6,9)
                    else
C Emit 129.1 keV transition converted
                       nr_part=7                    ! Seven particles are emitted
                       pid(5)=11                    ! Conversion electron
                       mass(5)=m_e                  ! 
                       energy(5)=e_gam_ac228(6,8)-x_ray_k_ac228
                       pid(6)=22                    ! K x-ray
                       mass(6)=m_g                  ! 
                       energy(6)=x_ray_k_ac228
                       pid(7)=11                    ! Conversion electron
                       mass(7)=m_e                  ! 
                       energy(7)=e_gam_ac228(6,9)
                    endif
                 elseif(rndm_g.gt.branch_gam_ac228(6,2,1).and.
     1                  rndm_g.le.branch_gam_ac228(6,2,2))then
C Emit 546.5 keV gamma
                    pid(4)=22                       ! Gamma
                    mass(4)=m_g                     ! 
                    energy(4)=e_gam_ac228(6,11)
C Decide which gammas should follow
                    call ranlux(rndm_g2,1)
                    if(rndm_g2.le.branch_gam_ac228(6,3,1))then
C Emit 328.0 keV gamma
                       nr_part=5                    ! Five particles are emitted
                       pid(5)=22                    ! Gamma
                       mass(5)=m_g                  ! 
                       energy(5)=e_gam_ac228(6,12)
                    else
C Emit 270.2 & 57.8 (converted) gammas
                       nr_part=6                    ! Six particles are emitted
                       pid(5)=22                    ! Gamma
                       mass(5)=m_g                  ! 
                       energy(5)=e_gam_ac228(6,15)
                       pid(6)=11                    ! Conversion electron
                       mass(6)=m_e                  ! 
                       energy(6)=e_gam_ac228(6,16)
                    endif
                 else 
C Emit 478.8 keV gamma
                    pid(4)=22                       ! Gamma
                    mass(4)=m_g                     ! 
                    energy(4)=e_gam_ac228(6,18)
C Decide which gammas should follow
                    call ranlux(rndm_g2,1)
                    if(rndm_g2.le.branch_gam_ac228(6,4,1))then
C Emit 338.3 & 57.8 (converted) keV gammas
                       nr_part=6                    ! Six particles are emitted
                       pid(5)=22                    ! Gamma
                       mass(5)=m_g                  ! 
                       energy(5)=e_gam_ac228(6,19)
                       pid(6)=11                    ! Conversion electron
                       mass(6)=m_e                  ! 
                       energy(6)=e_gam_ac228(6,20)                    
                    else
C Emit 209.3 & 129.1 & 57.8 (converted) keV gammas
                       nr_part=7                    ! Seven particles are emitted
                       pid(5)=22                    ! Gamma
                       mass(5)=m_g                  ! 
                       energy(5)=e_gam_ac228(6,23)
                       pid(6)=22                    ! Gamma
                       mass(6)=m_g                  ! 
                       energy(6)=e_gam_ac228(6,24)
                       pid(7)=11                    ! Conversion electron
                       mass(7)=m_e                  ! 
                       energy(7)=e_gam_ac228(6,25)                    
                    endif
                 endif
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(6).and.rndm.le.branch_ac228(7))then   ! Decay into seventh excited state E=1168.4 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 7'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(7))
             beta(j)=beta_ac228(7,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1168.4 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(7)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(7,1,1))then
C Emit 1110.6 & 57.8 (converted) keV gamma
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(7,1)
              pid(3)=11                       ! Conversion electorn
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(7,2)
           elseif(rndm_g.gt.branch_gam_ac228(7,1,1).and.
     1            rndm_g.le.branch_gam_ac228(7,1,2))then
C Emit 840.4 keV gamma.
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(7,3)
C Decide which of the two possible de-excitation modes to use.
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(7,2,1))then
C Emit 328.0 keV gamma
                 nr_part=3                       ! Three particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(7,4)
              else
C Emit 270.2 & 57.8 (converted) gammas
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(7,6)
                 pid(4)=11                       ! Conversion electorn
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(7,7)
              endif
           elseif(rndm_g.gt.branch_gam_ac228(7,1,2).and.
     1            rndm_g.le.branch_gam_ac228(7,1,3))then
C Emit 772.3 keV gamma.
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(7,8)
C Decide which of the two possible de-excitation modes to use.
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(7,3,1))then
C Emit 338.3 & 57.8 (converted) gammas
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(7,9)
                 pid(4)=11                       ! Conversion electorn
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(7,10)
              else
C Eit 209.3 & 129.1 * 57.8 (converted) gammas
C Decide whether 129.1 keV transition should be converted.
                 call ranlux(rndm_conv1,1)
                 if(rndm_conv1.le.branch_gam_conv_ac228(1))then   ! 129.1 keV gamma emission
C Emit 129.1 keV gamma 
                    nr_part=5                       ! Five particles are emitted
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(7,12)
                    pid(4)=22                       ! Gamma
                    mass(4)=m_g                     ! 
                    energy(4)=e_gam_ac228(7,13)
                    pid(5)=11                       ! Conversion electorn
                    mass(5)=m_e                     ! 
                    energy(5)=e_gam_ac228(7,14)
                 else
C 127.1 keV transition is converted
                    nr_part=6                       ! Six particles are emitted
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(7,12)
                    pid(4)=11                       ! Conversion electron
                    mass(4)=m_e                     ! 
                    energy(4)=e_gam_ac228(7,13)-x_ray_k_ac228
                    pid(5)=22                       ! K x-ray
                    mass(5)=m_g                     ! 
                    energy(5)=x_ray_k_ac228
                    pid(6)=11                       ! Conversion electorn
                    mass(6)=m_e                     ! 
                    energy(6)=e_gam_ac228(7,14)
                 endif
              endif
           else
C Emit 199.4 keV gamma
C Decide which of the two possible de-excitation modes to use.
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(7,4,1))then
C Emit 969 keV gamma
                 nr_part=3                       ! Three particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(7,16)
              else
C Emit 911.2 & 57.8 (converted) KeV gammas
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(7,18)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(7,19)
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(7).and.rndm.le.branch_ac228(8))then   ! Decay into eighth excited state E=1531.5 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 8'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(8))
             beta(j)=beta_ac228(8,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1531.5 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(8)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)

           if(rndm_g.le.branch_gam_ac228(8,1,1))then
C Emit 562.5 keV gamma
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(8,1)
C Decide which of the two possible de-excitation modes to use.
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(8,2,1))then
C Emit 969.0 keV gamma
                 nr_part=3                       ! Three particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(8,2)
              else
C Emit 911.2 & 57.8 (converted) keV gammas
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(8,4)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(8,5)
              endif

           elseif(rndm_g.gt.branch_gam_ac228(8,1,1).and.
     1            rndm_g.le.branch_gam_ac228(8,1,2))then
C Emit 509.0 keV gamma.
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(8,6)
C Decide which of the two possible de-excitation modes to use.
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(8,3,1))then
C Emit 964.8 & 57.8 (converted) keV gammas
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(8,7)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(8,8)
              else
C Emit 835.7 & 129.1 & 57.8 (converted) keV gammas.
C Decide whether 129.1 keV transition should be converted.
                 call ranlux(rndm_conv1,1)
                 if(rndm_conv1.le.branch_gam_conv_ac228(1))then   ! 129.1 keV gamma emission
C Emit 129.1 keV gamma 
                    nr_part=5                       ! Five particles are emitted
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(8,10)
                    pid(4)=22                       ! Gamma
                    mass(4)=m_g                     ! 
                    energy(4)=e_gam_ac228(8,11)
                    pid(5)=11                       ! Conversion electron
                    mass(5)=m_e                     ! 
                    energy(5)=e_gam_ac228(8,12)
                 else
C 129.1 keV transition converted
                    nr_part=6                       ! Six particles are emitted
                    pid(3)=22                       ! Gamma
                    mass(3)=m_g                     ! 
                    energy(3)=e_gam_ac228(8,10)
                    pid(4)=11                       ! Conversion electron
                    mass(4)=m_e                     ! 
                    energy(4)=e_gam_ac228(8,11)-x_ray_k_ac228
                    pid(5)=22                       ! K x-ray
                    mass(5)=m_g                     ! 
                    energy(5)=x_ray_k_ac228
                    pid(6)=11                       ! Conversion electron
                    mass(6)=m_e                     ! 
                    energy(6)=e_gam_ac228(8,12)
                 endif
              endif

           else
C Emit 99.5 keV (converted) gamma
C Decide whether 99.5 keV transition should be converted.
              call ranlux(rndm_conv1,1)
              if(rndm_conv1.le.branch_gam_conv_ac228(4))then   ! 99.5 keV gamma emission
C Emit 99.5 keV gamma 
                 pid(2)=22                       ! Gamma
                 mass(2)=m_g                     ! 
                 energy(2)=e_gam_ac228(8,13)
C Decide which of the two possible de-excitation modes to use.
                 call ranlux(rndm_g1,1)
                 if(rndm_g1.le.branch_gam_ac228(8,4,1))then
C Emit 463.0 keV gamma
                    pid(3)=22                    ! Gamma
                    mass(3)=m_g                  ! 
                    energy(3)=e_gam_ac228(8,14)
C Decide which of the two possible de-excitation modes to use.
                    call ranlux(rndm_g2,1)
                    if(rndm_g2.le.branch_gam_ac228(8,5,1))then
C Emit 969.0 keV gamma
                       nr_part=4
                       pid(4)=22                 ! Gamma
                       mass(4)=m_g               ! 
                       energy(4)=e_gam_ac228(8,15)
                    else
C Emit 911.2 & 57.8 (converted) keV gammas
                       nr_part=5
                       pid(4)=22                 ! Gamma
                       mass(4)=m_g               ! 
                       energy(4)=e_gam_ac228(8,18)
                       pid(5)=11                 ! Conversion electron
                       mass(5)=m_e               ! 
                       energy(5)=e_gam_ac228(8,19)
                    endif
                 else
C Emit 409.5 keV gamma
                    pid(3)=22                    ! Gamma
                    mass(3)=m_g                  ! 
                    energy(3)=e_gam_ac228(8,21)
C Decide which of the two possible de-excitation modes to use.
                    call ranlux(rndm_g2,1)
                    if(rndm_g2.le.branch_gam_ac228(8,6,1))then
C Emit 964.8 & 57.8 (converted) keV gammas
                       nr_part=5
                       pid(4)=22                 ! Gamma
                       mass(4)=m_g               ! 
                       energy(4)=e_gam_ac228(8,22)
                       pid(5)=11                 ! Conversion electron
                       mass(5)=m_e               ! 
                       energy(5)=e_gam_ac228(8,23)
                    else
C Emit 835.7 & 129.1 & 57.8 (converted) gammas
                       nr_part=6
                       pid(4)=22                 ! Gamma
                       mass(4)=m_g               ! 
                       energy(4)=e_gam_ac228(8,26)
                       pid(5)=22                 ! Gamma
                       mass(5)=m_g               ! 
                       energy(5)=e_gam_ac228(8,27)
                       pid(6)=11                 ! Conversion electron
                       mass(6)=m_e               ! 
                       energy(6)=e_gam_ac228(8,28)
                    endif
                 endif

              else
C 99.5 keV transition is converted
                 pid(2)=11                       ! Conversion electron
                 mass(2)=m_e                     ! 
                 energy(2)=e_gam_ac228(8,13)-x_ray_l_ac228
                 pid(3)=22                       ! L x-ray
C This was used till 5/9/2002
C                 mass(3)=m_e                     !
C Corrected 5/9/2002
                 mass(3)=m_g
                 energy(3)=x_ray_l_ac228
C Decide which of the two possible de-excitation modes to use.
                 call ranlux(rndm_g1,1)
                 if(rndm_g1.le.branch_gam_ac228(8,4,1))then
C Emit 463.0 keV gamma
                    pid(4)=22                    ! Gamma
                    mass(4)=m_g                  ! 
                    energy(4)=e_gam_ac228(8,14)
C Decide which of the two possible de-excitation modes to use.
                    call ranlux(rndm_g2,1)
                    if(rndm_g2.le.branch_gam_ac228(8,5,1))then
C Emit 969.0 keV gamma
                       nr_part=5
                       pid(5)=22                 ! Gamma
                       mass(5)=m_g               ! 
                       energy(5)=e_gam_ac228(8,15)
                    else
C Emit 911.2 & 57.8 (converted) keV gammas
                       nr_part=6
                       pid(5)=22                 ! Gamma
                       mass(5)=m_g               ! 
                       energy(5)=e_gam_ac228(8,18)
                       pid(6)=11                 ! Conversion electron
                       mass(6)=m_e               ! 
                       energy(6)=e_gam_ac228(8,19)
                    endif
                 else
C Emit 409.5 keV gamma
                    pid(4)=22                    ! Gamma
                    mass(4)=m_g                  ! 
                    energy(4)=e_gam_ac228(8,21)
C Decide which of the two possible de-excitation modes to use.
                    call ranlux(rndm_g2,1)
                    if(rndm_g2.le.branch_gam_ac228(8,6,1))then
C Emit 964.8 & 57.8 (converted) keV gammas
                       nr_part=6
                       pid(5)=22                 ! Gamma
                       mass(5)=m_g               ! 
                       energy(5)=e_gam_ac228(8,22)
                       pid(6)=11                 ! Conversion electron
                       mass(6)=m_e               ! 
                       energy(6)=e_gam_ac228(8,23)
                    else
C Emit 835.7 & 129.1 & 57.8 (converted) gammas
                       nr_part=7
                       pid(5)=22                 ! Gamma
                       mass(5)=m_g               ! 
                       energy(5)=e_gam_ac228(8,26)
                       pid(6)=22                 ! Gamma
                       mass(6)=m_g               ! 
                       energy(6)=e_gam_ac228(8,27)
                       pid(7)=11                 ! Conversion electron
                       mass(7)=m_e               ! 
                       energy(7)=e_gam_ac228(8,28)
                    endif
                 endif
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(8).and.rndm.le.branch_ac228(9))then   ! Decay into ninth excited state E=1638.3 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 9'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(9))
             beta(j)=beta_ac228(9,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1638.3 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(9)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(9,1,1))then
C Emit 1638.3 keV gamma
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(9,1)
           else
C Emit 1580.5 & 57.8 (converted) gammas
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(9,2)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(9,3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(9).and.rndm.le.branch_ac228(10))then   ! Decay into tenth excited state E=1646.0 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 10'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(10))
             beta(j)=beta_ac228(10,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1646.0 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(10)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(10,1,1))then
C Emit 1588.2 & 57.8 (converted) keV gammas
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(10,1)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(10,2)
           else
C Emit 1459.1 & 129.1 & 57.8 (converted) gammas
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(10,3)
C Decide whether 129.1 keV transition should be converted.
              call ranlux(rndm_conv1,1)
              if(rndm_conv1.le.branch_gam_conv_ac228(1))then   ! 129.1 keV gamma emission
C Emit 129.1 keV gamma 
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(10,4)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(10,5)
              else
C 129.1 keV transition is converted
                 nr_part=5                       ! Five particles are emitted
                 pid(3)=11                       ! Conversion electron
                 mass(3)=m_e                     ! 
                 energy(3)=e_gam_ac228(10,4)-x_ray_k_ac228
                 pid(4)=22                       ! K x-ray
                 mass(4)=m_g                     ! 
                 energy(4)=x_ray_k_ac228
                 pid(5)=11                       ! Conversion electron
                 mass(5)=m_e                     ! 
                 energy(5)=e_gam_ac228(10,5)
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(10).and.rndm.le.
     1         branch_ac228(11))then   ! Decay into eleventh excited state E=1682.8 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 11'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(11))
             beta(j)=beta_ac228(11,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1682.8 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(11)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(11,1,1))then
C Emit 1625.1 & 57.8 (converted) keV gammas
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(11,1)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(11,2)
           else
C Emit 1495.9 & 129.1 & 57.8 (converted) gammas
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(11,3)
C Decide whether 129.1 keV transition should be converted.
              call ranlux(rndm_conv1,1)
              if(rndm_conv1.le.branch_gam_conv_ac228(1))then   ! 129.1 keV gamma emission
C Emit 129.1 keV gamma 
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(11,4)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(11,5)
              else
C 129.1 keV transition is converted
                 nr_part=5                       ! Five particles are emitted
                 pid(3)=11                       ! Conversion electron
                 mass(3)=m_e                     ! 
                 energy(3)=e_gam_ac228(11,4)-x_ray_k_ac228
                 pid(4)=22                       ! K x-ray
                 mass(4)=m_g                     ! 
                 energy(4)=x_ray_k_ac228
                 pid(5)=11                       ! Conversion electron
                 mass(5)=m_e                     ! 
                 energy(5)=e_gam_ac228(11,5)
              endif
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_ac228(11).and.rndm.le.
     1         branch_ac228(12))then   ! Decay into twelfth excited state E=1688.4 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 12'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(12))
             beta(j)=beta_ac228(12,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1688.4 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(12)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(12,1,1))then
C Emit 1630.6 & 57.8 (converted) keV gammas
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(12,1)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(12,2)
           else
C Emit 1501.6 & 129.1 & 57.8 (converted) gammas
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(12,3)
C Decide whether 129.1 keV transition should be converted.
              call ranlux(rndm_conv1,1)
              if(rndm_conv1.le.branch_gam_conv_ac228(1))then   ! 129.1 keV gamma emission
C Emit 129.1 keV gamma 
                 nr_part=4                       ! Four particles are emitted
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(12,4)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(12,5)
              else
C 129.1 keV transition is converted
                 nr_part=5                       ! Five particles are emitted
                 pid(3)=11                       ! Conversion electron
                 mass(3)=m_e                     ! 
                 energy(3)=e_gam_ac228(12,4)-x_ray_k_ac228
                 pid(4)=22                       ! K x-ray
                 mass(4)=m_g                     ! 
                 energy(4)=x_ray_k_ac228
                 pid(5)=11                       ! Conversion electron
                 mass(5)=m_e                     ! 
                 energy(5)=e_gam_ac228(12,5)
              endif
           endif

c*************************************************************************************

        else                                                                ! Decay into thirteenth excited state E=1724.3 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! 
C          write(*,*)'Beta branch 13'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_ac228(13))
             beta(j)=beta_ac228(13,j)
C             write(*,*)j,beta(j)
             if(beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 228Ac 1724.3 keV exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_ac228(13)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_ac228(13,1,1))then
C Emit 1666.5 & 57.8 (converted) keV gammas
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(13,1)
              pid(3)=11                       ! Conversion electron
              mass(3)=m_e                     ! 
              energy(3)=e_gam_ac228(13,2)
           elseif(rndm_g.gt.branch_gam_ac228(13,1,1).and.
     1            rndm_g.le.branch_gam_ac228(13,1,2))then
C Emit 755.3 keV gamma.
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(13,3)
C Decide which of the two possible de-excitation modes to use.
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(13,2,1))then
C Emit 969.0 keV gamma
                 nr_part=3
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(13,4)
              else
C Emit 911.2 & 57.8 (converted) gammas.
                 nr_part=4                       ! 
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(13,6)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(13,7)
              endif
           else
C Emit 701.7 keV gamma
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! 
              energy(2)=e_gam_ac228(13,8)
C Decide which of the two possible de-excitation modes to use.
              call ranlux(rndm_g1,1)
              if(rndm_g1.le.branch_gam_ac228(13,3,1))then
C Emit 964.8 & 57.8 (converted) gammas.
                 nr_part=4                       ! 
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(13,9)
                 pid(4)=11                       ! Conversion electron
                 mass(4)=m_e                     ! 
                 energy(4)=e_gam_ac228(13,10)
              else
C Emit 835.7 & 129.1 & 57.8 (converted) gammas.
C 129.1 keV is not converted! Population is too small.
                 nr_part=5                       ! 
                 pid(3)=22                       ! Gamma
                 mass(3)=m_g                     ! 
                 energy(3)=e_gam_ac228(13,12)
                 pid(4)=22                       ! Gamma
                 mass(4)=m_g                     ! 
                 energy(4)=e_gam_ac228(13,13)
                 pid(5)=11                       ! Conversion electron
                 mass(5)=m_e                     ! 
                 energy(5)=e_gam_ac228(13,14)
              endif
           endif

c*************************************************************************************

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
