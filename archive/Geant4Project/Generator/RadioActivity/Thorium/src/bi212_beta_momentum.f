
      subroutine bi212_beta_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 212Bi beta decay.
C
C 10/22/2001 A. Piepke
C

        implicit none

        include 'decay_th.inc'
        include 'momentum.inc'
        include 'fermi_bin.inc'

        integer i,j
        real*4 rndm,rndm_g      ! Random number
        real*4 rndm3(3)
        logical*4 tfg/.false./  ! Marks the first decay for which the random
                                ! number generator has to be initialized.
        real*4 total_energy     ! Total energy in [GeV]
        real*4 beta(nr_beta_bins_bi212_b) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.
        real*4 beta_bi212_b(nr_branch_bi212_b,nr_beta_bins_bi212_b)
                                ! Two dimensional array that hold the beta spectra of all
                                ! deacy branches.
                                ! First index: identifies the decay branch. 1: ground state decay and so on. 
                                ! Second index: numbers the energy bins in [keV].

C Initializations to be done during the first call.

        if(.not.tfg)then

C Convert branching ratios into probability distribution.
           write(*,*)'212Bi beta decay'
           write(*,*)'Beta branching ratio :  1', branch_bi212_b(1)
           do i=1,nr_branch_bi212_b
              if(i.gt.1)then
                 branch_bi212_b(i)=branch_bi212_b(i)+branch_bi212_b(i-1)
                 write(*,*)'Beta branching ratio : ',i, 
     1           branch_bi212_b(i)
              endif
              write(*,*)'Gamma branching ratio: ',i,' 1',
     1                  branch_gam_bi212_b(i,1)
              do j=2,nr_branch_gam_bi212_b
                 branch_gam_bi212_b(i,j)=branch_gam_bi212_b(i,j)+
     1                            branch_gam_bi212_b(i,j-1)
              write(*,*)'Gamma branching ratio: ',i,j, 
     1        branch_gam_bi212_b(i,j)
              enddo
           enddo

           do i=1,nr_branch_bi212_b

C              write(*,*)'Beta branching ratio : ',i, branch_bi212_b(i)
C              write(*,*)'Gamma branching ratio: ',i, branch_gam_bi212_b(i)
C Calculate beta distributions.
              call fermi_bin(1000.*e_beta_bi212_b(i),84,212,0)
              if(fpoint_nr.ne.int(1.e6*e_beta_bi212_b(i)))then
                 write(*,*)'>>>Beta array too long or short in: ',
     1           'bi212_beta_momentum'
                 write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
                 write(*,*)'Expected             : ',
     1           int(1.e6*e_beta_bi212_b(i))
                 if(fpoint_nr.gt.int(1.e6*e_beta_bi212_b(i)))then
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
C     1        branch_bi212_b(i)
C              write(*,*)'*****************************'
              do j=1,fpoint_nr
                 beta_bi212_b(i,j)=beta(j)
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
           is=is+123456
           call rluxgo(lux,is,0,0)! Set new seed values. 
           write(*,*)'Initialize random number generator 
     -     BI212_BETA_MOMENTUM'

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

        if(rndm.le.branch_bi212_b(1))then  ! 212Bi ground state beta decay
C Ground state decay.
           nr_part=1                       ! One particle is emitted
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
           do j=1,int(1.e6*e_beta_bi212_b(1))
             beta(j)=beta_bi212_b(1,j)
             if(j.gt.1.and.beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 212Bi ground state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi212_b(1)),0.,1.,energy(1))
C           call rnhran(beta,int(1.e6*e_beta_bi212_b(1)),0.,1.,energy(1))
           energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
           momentum(1)=momentum_in(1)
           momentum(2)=momentum_in(2)
           momentum(3)=momentum_in(3)

c*************************************************************************************

        elseif(rndm.gt.branch_bi212_b(1).and.rndm.le.
     1         branch_bi212_b(2))then   
                                ! Decay into excited state 727.3 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 2'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi212_b(2))
             beta(j)=beta_bi212_b(2,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 212Bi first exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi212_b(2)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
           momentum(1)=momentum_in(1)
           momentum(2)=momentum_in(2)
           momentum(3)=momentum_in(3)

C Decay into first excited state one 727.3 keV gamma emitted
           nr_part=2                       ! Two particles are emitted
           pid(2)=22                       ! Gamma
           mass(2)=m_g                     ! Save rest mass
           energy(2)=e_gam_bi212_b(2,1)
C           write(*,*)'Gamma energy: ',energy(2)
C Convert kinetic energy into total momentum for the gamma.
           total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
           momentum(4)=momentum_in(1)
           momentum(5)=momentum_in(2)
           momentum(6)=momentum_in(3)

c*************************************************************************************

        elseif(rndm.gt.branch_bi212_b(2).and.rndm.le.
     1         branch_bi212_b(3))then   ! Decay into excited state 1512.7 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 3'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi212_b(3))
             beta(j)=beta_bi212_b(3,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 212Bi second exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi212_b(3)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
           momentum(1)=momentum_in(1)
           momentum(2)=momentum_in(2)
           momentum(3)=momentum_in(3)

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi212_b(3,1))then
C Decay into second excited state one 1512.7 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi212_b(3,1)
C             write(*,*)'Gamma energy: ',energy(2)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(4)=momentum_in(1)
              momentum(5)=momentum_in(2)
              momentum(6)=momentum_in(3)
           else
C Decay into second excited state two 785.4 & 727.3 keV gamma emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi212_b(3,2)
C             write(*,*)'Gamma energy: ',energy(2)
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(3)=e_gam_bi212_b(3,3)
C             write(*,*)'Gamma energy: ',energy(3)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(4)=momentum_in(1)
              momentum(5)=momentum_in(2)
              momentum(6)=momentum_in(3)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(3)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(7)=momentum_in(1)
              momentum(8)=momentum_in(2)
              momentum(9)=momentum_in(3)
           endif

c*************************************************************************************

        elseif(rndm.gt.branch_bi212_b(3).and.rndm.le.
     1         branch_bi212_b(4))then   ! Decay into excited state 1620.7 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 4'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi212_b(4))
             beta(j)=beta_bi212_b(4,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 212Bi third exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi212_b(4)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
           momentum(1)=momentum_in(1)
           momentum(2)=momentum_in(2)
           momentum(3)=momentum_in(3)

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi212_b(4,1))then
C Decay into third excited state one 1620.7 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi212_b(4,1)
C              write(*,*)'Gamma energy: ',energy(2)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(4)=momentum_in(1)
              momentum(5)=momentum_in(2)
              momentum(6)=momentum_in(3)

           else
C Decay into third excited state two 893.4 + 727.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi212_b(4,2)
              energy(3)=e_gam_bi212_b(4,3)
C              write(*,*)'Gamma energy: ',energy(2),energy(3)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(4)=momentum_in(1)
              momentum(5)=momentum_in(2)
              momentum(6)=momentum_in(3)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(3)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(7)=momentum_in(1)
              momentum(8)=momentum_in(2)
              momentum(9)=momentum_in(3)
           endif

c*************************************************************************************

        else                          ! Decay into excited state 1806.0 keV.
C Generate the beta electron
           pid(1)=11                       ! Electron
           mass(1)=m_e                     ! Save rest mass
C          write(*,*)'Beta branch 5'
C          write(*,*)'*****************************'
           do j=1,int(1.e6*e_beta_bi212_b(5))
             beta(j)=beta_bi212_b(5,j)
C             write(*,*)j,beta(j)
             if(j.gt.1.and.beta(j).lt.beta(j-1).and.j.ne.1)then
                write(*,*)'Cummulative beta distribution',
     1          ' not monotonic!. 212Bi fourth exct. state: ',j,beta(j)
                stop
             endif
           enddo
           call hisran(beta,int(1.e6*e_beta_bi212_b(5)),0.,1.,energy(1))
C          write(*,*)'Random e energy in [keV]: ',energy(1)
C          read(*,*)
           energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
           total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
           call ran_momentum(total_energy,momentum_in)
           momentum(1)=momentum_in(1)
           momentum(2)=momentum_in(2)
           momentum(3)=momentum_in(3)

C Decide which of the two possible de-excitation modes to use.
           call ranlux(rndm_g,1)
           if(rndm_g.le.branch_gam_bi212_b(5,1))then
C Decay into third excited state one 1805.9 keV gamma emitted
              nr_part=2                       ! Two particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi212_b(5,1)
C              write(*,*)'Gamma energy: ',energy(2)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(4)=momentum_in(1)
              momentum(5)=momentum_in(2)
              momentum(6)=momentum_in(3)

           else
C Decay into first excited state two 1078.6 + 727.3 keV gammas emitted
              nr_part=3                       ! Three particles are emitted
              pid(2)=22                       ! Gamma
              mass(2)=m_g                     ! Save rest mass
              pid(3)=22                       ! Gamma
              mass(3)=m_g                     ! Save rest mass
              energy(2)=e_gam_bi212_b(5,2)
              energy(3)=e_gam_bi212_b(5,3)
C              write(*,*)'Gamma energy: ',energy(2),energy(3)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(2)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(4)=momentum_in(1)
              momentum(5)=momentum_in(2)
              momentum(6)=momentum_in(3)
C Convert kinetic energy into total momentum for the gamma.
              total_energy=energy(3)
C Get momentum vector with isotropic angular distribution.
              call ran_momentum(total_energy,momentum_in)
              momentum(7)=momentum_in(1)
              momentum(8)=momentum_in(2)
              momentum(9)=momentum_in(3)
           endif
        endif

        return

        end
