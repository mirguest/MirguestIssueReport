
      program th_decays

C Program to simulate 232Th decays. It is assumed that the decay series is in
C secular equilibrium. This means that all members decay with the same rate
C determined by the concentration of 232Th feeding the series. Members of the 
C series with short life time are created together with a correlation
C time. All correlated events are stored as a single event. The others are only 
C statistically the same. This program is a modified version of the code 
C "u_decays.f" which simultes 238U decays.
C
C 10/15/2001 A. Piepke
C
C Event time is only saved once for each nuclear decay. Q-value of 234mPa
C beta decay corrected.   
C
C 11/4/2001 A.P.
C
C In subroutine RAN_MOMENTUM the range of cos(theta) was only from 0 to 1. Therefore 
C only up ward going momentum vectors were produced. As a result the *.asc file had 
C never a momentum vector with a negative p3 component. This error has been corrected 
C by ranging cos(theta) from -1 to 1.
C
C A. Piepke 5/6/2002
C
C The decay time is created using a more recent random number generator (funlux). The
C one used previously (funran) created a pathological time ditribution at large time
C differneces. Code compiles now on LINUX machines. Booking range of cos(Q) histograms
C corrected from 0. to 1. to now -1. to 1.
C
C A. Piepke 9/23/2002

C Modified 17aug07 djaffe to make input arguments more compatible with
C                  Daya Bay standards
C                  
C Treatment of arguments is the same as above except that in the
C case of two or more arguments, the second argument is interpreted
C as the random seed.

        implicit none

        include 'decay_th.inc'              ! Data base
        include 'momentum.inc'              ! Variables. Also used by "u_decays.f" in this form.

C Arrays to hold data for correlated decays.

        integer nr_corr                     ! Maximal number of correlated decays.
        parameter(nr_corr=6)
        real*4 momentum_c(array_p,nr_corr)  ! Array holding the momentum [GeV] for correlated decyas.
        real*4 energy_c(array_e,nr_corr)    ! Array holding the kinetic energies [GeV] for correlated decyas.
        integer*4 pid_c(array_e,nr_corr)    ! Array holding the particle id's for correlated decyas.
        real*4 time_c(nr_corr)              ! Event time for correlated events.
        real*4 mass_c(array_e,nr_corr)      ! Particle rest masses in [GeV] for correlated decays.
        integer*4 nr_part_c(nr_corr)        ! Total number of particles generated in this correlated decay.
        character*20 event_txt_c(array_e,nr_corr)! Text identifying the event in correlated chain.

        integer version
        data version/0/
        integer revision
        data revision/0/

C Hbook variables
        logical*4 nt_save                   ! decides whether or not HBOOK ntuple will be created.
        integer*4 npawc
        parameter(npawc=1000000)
        real H
        common/pawc/H(npawc)
        integer*4 id            ! Histogram id.
        integer*4 istat,icycle
        character*20 file_ntuple            ! Name of the optinal ntuple.
        data file_ntuple/'th_decays.hist'/
C Ntuple definitions
        character*20 chtitle,chpath
        integer*4 ntuple_entries            ! Number of entries into ntuple
        parameter(ntuple_entries=34)
        character*8 chtags(ntuple_entries)      ! Names of the variables to be saved in ntuple.
        data chtags(1),chtags(2),chtags(3)/'e1','e2','e3'/
        data chtags(4),chtags(5),chtags(6)/'e4','e5','e6'/
        data chtags(7),chtags(8),chtags(9)/'e7','e8','e9'/
        data chtags(10)/'e10'/
        data chtags(11),chtags(12),chtags(13)/'pid1','pid2','pid3'/
        data chtags(14),chtags(15),chtags(16)/'pid4','pid5','pid6'/
        data chtags(17),chtags(18),chtags(19)/'pid7','pid8','pid9'/
        data chtags(20)/'pid10'/
        data chtags(21),chtags(22),chtags(23)/'m1','m2','m3'/
        data chtags(24),chtags(25),chtags(26)/'m4','m5','m6'/
        data chtags(27),chtags(28),chtags(29)/'m7','m8','m9'/
        data chtags(30)/'m10'/
        data chtags(31),chtags(32),chtags(33)/'tot_nr','nr','brnch_id'/
        data chtags(34)/'time'/
        real*4 nt_data(ntuple_entries)          ! Data stored in ntuple.

C Othe program variables

      integer i,j,k,nr_events,nskip ! Counters
      integer lunasc            ! logical unit for ascii output

        real*4 hit(nr_series_brnch)         ! Counts the number of entries into each independent branch of series.

        real*4 decay_func_th_3              ! Decay time function of 228Ac
        real*4 decay_func_th_6              ! Decay time function of 220Rn
        real*4 decay_func_th_7              ! Decay time function of 216Po
        real*4 decay_func_th_8              ! Decay time function of 212Pb
        real*4 decay_func_th_9              ! Decay time function of 212Bi
        real*4 decay_func_th_10             ! Decay time function of 212Po
        real*4 decay_func_th_11             ! Decay time function of 208Tl

        real*4 rndm             ! Random number
        real*4 rndm_bi          ! Random variable. Decides whether 212Bi beta or alpha decay.
        logical*4 tfg/.false./  ! Marks the first decay for which the random
                                ! number generator has to be initialized.
        real*4 tau_space3(200)  ! Array to create rndom decay time [s]. 228Ac
        real*4 tau_space6(200)  ! Array to create rndom decay time [s]. 220Rn
        real*4 tau_space7(200)  ! Array to create rndom decay time [s]. 216Po
        real*4 tau_space8(200)  ! Array to create rndom decay time [s]. 212Pb
        real*4 tau_space9(200)  ! Array to create rndom decay time [s]. 212Bi
        real*4 tau_space10(200) ! Array to create rndom decay time [s]. 212Po
        real*4 tau_space11(200) ! Array to create rndom decay time [s]. 208Tl
        real*4 time             ! Random correlation time [s].

        character*20 event_txt(12) ! Text identifying the event
        data event_txt(1)/'# 232Th alpha decay'/
        data event_txt(2)/'# 228Ra beta decay'/
        data event_txt(3)/'# 228Ac beta decay'/
        data event_txt(4)/'# 228Th alpha decay'/
        data event_txt(5)/'# 224Ra alpha decay'/
        data event_txt(6)/'# 220Rn alpha decay'/
        data event_txt(7)/'# 216Po alpha decay'/
        data event_txt(8)/'# 212Pb beta decay'/
        data event_txt(9)/'# 212Bi beta decay'/
        data event_txt(10)/'# 212Po alpha decay'/
        data event_txt(11)/'# 212Bi alpha decay'/
        data event_txt(12)/'# 208Tl beta decay'/
        
        external decay_func_th_3      ! Decay time function of 228Ac
        external decay_func_th_6      ! Decay time function of 220Rn
        external decay_func_th_7      ! Decay time function of 216Po
        external decay_func_th_8      ! Decay time function of 212Pb
        external decay_func_th_9      ! Decay time function of 212Bi
        external decay_func_th_10     ! Decay time function of 212Po
        external decay_func_th_11     ! Decay time function of 208Tl

 100    format(i2,2x,i7,2x,i1,2x,i1,2x,e10.4,2x,e10.4,
     1         2x,e10.4,2x,e10.4,2x,e11.5,2x,a20,2x,f8.3)

C Initializations to be done during the first call.

        if(.not.tfg)then

C Define number of events

           nr_events=200000
           nskip= 0
C           nt_save=.true.          ! Create ntuple and histograms.
           nt_save=.false.        ! No HBOOK objects.
           is = 42569             ! Default random seed
           lunasc=20

           CALL DOCMDOPT(nr_events, is, nt_save, lunasc)

C     write something so KLHepEvt reader knows to ignore initialization messages
           write(lunasc,*) 'HEPEVT DATA SENTINEL IS **HEPEVT**'           

           do i=1,nr_series_brnch
              hit(i)=0.
           enddo

C Initialize MINUIT.

           if(nt_save)then

              write(*,*)
              write(*,*)'Initialize HBOOK data structures'

C Book memory for HBOOK.

              call hlimit(npawc)

              call hropen(1,'Th_decays',file_ntuple,'N',1024,istat)
              if(istat.ne.0)then
                 write(*,*)char(7),'>>>Error during booking of ntuple'
                 stop
              endif

C Book row wise ntuple.

              chtitle='232Th decay generator'
              call hbookn(10,chtitle,ntuple_entries,
     1          '//Th_decays',3500,chtags)

              call hcdir(chpath,'R')
              write(*,*)'Current directory: ',chpath
              call hldir('//PAWC','N')

           endif

C Open the ASCII file.

           if (lunasc.eq.20) then
              open(unit=20,file='th_decays.asc',status='unknown')
              write (*,*) ' Writing ascii data to th_decays.asc'
           endif

C Set new seed value for the random number generator.

           call rluxgo(lux,is,0,0)! Set new seed values. 
           write(*,*)'Initialize random number generator Th_DECAYS'

C 232Th angular distribution.

           if(nt_save)then
              call hbook1(100,'^232!Th [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(101,'^232!Th cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif

C 228Ra angular distribution.
           if(nt_save)then
              call hbook1(200,'^228!Ra [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(201,'^228!Ra cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif

C 228Ac angular distribution.
           if(nt_save)then
              call hbook1(300,'^228!Ac [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(301,'^228!Ac cos[Q] distribution',
     1          100,-1.,1.,0.)
              call hbook1(302,'^228!Ac time distribution',
     1          100,0.,10.*tau(3),0.)
           endif
C 228Ac: initialize decay time generation. Use external functions.
           call funlxp(decay_func_th_3,tau_space3,0.,10.*tau(3)) ! 228Ac
C           call funpre(decay_func_th_3,tau_space3,0.,10.*tau(3)) ! 228Ac

C 228Th angular distribution.
           if(nt_save)then
              call hbook1(400,'^228!Th [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(401,'^228!Th cos[Q] distribution',
     1          100,-1.,1.,0.)

C 224Ra angular distribution.
              call hbook1(500,'^224!Ra [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(501,'^224!Ra cos[Q] distribution',
     1          100,-1.,1.,0.)

C 220Rn angular distribution.
              call hbook1(600,'^220!Rn [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(601,'^220!Rn cos[Q] distribution',
     1          100,-1.,1.,0.)
              call hbook1(602,'^220!Rn time distribution',
     1          100,0.,10.*tau(6),0.)
           endif
C 220Rn: initialize decay time generation. Use external functions.
           call funlxp(decay_func_th_6,tau_space6,0.,10.*tau(6)) ! 220Rn
C           call funpre(decay_func_th_6,tau_space6,0.,10.*tau(6)) ! 220Rn

C 216Po angular distribution.
           if(nt_save)then
              call hbook1(700,'^216!Po [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(701,'^216!Po cos[Q] distribution',
     1          100,-1.,1.,0.)
              call hbook1(702,'^216!Po time distribution',
     1          100,0.,10.*tau(7),0.)
           endif
C 216Po: initialize decay time generation. Use external functions.
           call funlxp(decay_func_th_7,tau_space7,0.,10.*tau(7)) ! 216Po
C           call funpre(decay_func_th_7,tau_space7,0.,10.*tau(7)) ! 216Po

C 212Pb angular distribution.
           if(nt_save)then
              call hbook1(800,'^212!Pb [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(801,'^212!Pb cos[Q] distribution',
     1          100,-1.,1.,0.)
              call hbook1(802,'^212!Pb time distribution',
     1          100,0.,10.*tau(8),0.)
           endif
C 212Pb: initialize decay time generation. Use external functions.
           call funlxp(decay_func_th_8,tau_space8,0.,10.*tau(8))      ! 212Pb
C           call funpre(decay_func_th_8,tau_space8,0.,10.*tau(8))      ! 212Pb

C 212Bi angular distribution.
           if(nt_save)then
              call hbook1(900,'^212!Bi [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(901,'^212!Bi cos[Q] distribution',
     1          100,-1.,1.,0.)
              call hbook1(902,'^212!Bi time distribution',
     1          100,0.,10.*tau(9),0.)
           endif
C 212Bi: initialize decay time generation. Use external functions.
           call funlxp(decay_func_th_9,tau_space9,0.,10.*tau(9))      ! 212Bi
C           call funpre(decay_func_th_9,tau_space9,0.,10.*tau(9))      ! 212Bi

C 212Po angular distribution.
           if(nt_save)then
              call hbook1(1000,'^212!Po [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(1001,'^212!Po cos[Q] distribution',
     1          100,-1.,1.,0.)
              call hbook1(1002,'^212!Po time distribution',
     1          100,0.,10.*tau(10),0.)
           endif
C 212Po: initialize decay time generation. Use external functions.
           call funlxp(decay_func_th_10,tau_space10,0.,10.*tau(10))   ! 212Po
C           call funpre(decay_func_th_10,tau_space10,0.,10.*tau(10))   ! 212Po

C 208Tl angular distribution.
           if(nt_save)then
              call hbook1(1100,'^208!Tl [F] distribution',
     1          100,0.,two_pi,0.)
              call hbook1(1101,'^208!Tl cos[Q] distribution',
     1          100,-1.,1.,0.)
              call hbook1(1102,'^208!Tl time distribution',
     1          100,0.,10.*tau(11),0.)
           endif
C 208Tl: initialize decay time generation. Use external functions.
           call funlxp(decay_func_th_11,tau_space11,0.,10.*tau(11))   ! 208Tl
C           call funpre(decay_func_th_11,tau_space11,0.,10.*tau(11))   ! 208Tl

C Done with booking histograms and preparing decay functions.


C Convert branching ratios into probability distribution.
           do i=2,nr_series_brnch
              branch_th(i)=branch_th(i)+branch_th(i-1)
           enddo
           
C     Call each momentum randomizer once to initialize
           call ac228_momentum
           call bi212_alpha_momentum
           call bi212_beta_momentum
           call pb212_momentum
           call po212_momentum
           call po216_momentum
           call ra224_momentum
           call ra228_momentum
           call rn220_momentum
           call th228_momentum
           call th232_momentum
           call tl208_momentum
           
C     Done with initialization, all output from now on should be HEPEVT
           write(lunasc,*) '**HEPEVT**'

C     Don't go in here again.
           tfg=.true.
        endif

C Loop over all decays

        do i=1,nr_events

C Make output for every 10000-th step

           if(mod(float(i),10000.).eq.0.)then
            write(*,*)'! Decay: ',i
           endif

C Initialize all variables.
           
           time=0.
           nr_part=0
           do j=1,array_p
              momentum(j)=0.
              do k=1,nr_corr
                 momentum_c(j,k)=0.
              enddo
           enddo
           do j=1,array_e
              energy(j)=0.
              pid(j)=0.
              mass(j)=0.
              do k=1,nr_corr
                 energy_c(j,k)=0.
                 pid_c(j,k)=0.
                 mass_c(j,k)=0.
                 time_c(k)=0.
                 nr_part_c(k)=0
                 event_txt_c(j,k)='                    '
              enddo
           enddo
           do j=1,ntuple_entries
              nt_data(j)=0.
           enddo

C Generate a randum namber and decide what part of the Th-series to generate.

           call ranlux(rndm,1)

C*********************************************************************************
C*********************************************************************************

           if(rndm.le.branch_th(1))then                             ! 232Th
              hit(1)=hit(1)+1
C Generate one 232Th alpha decay. Two branches are implemented.
              call th232_momentum
              if(nt_save)then
                 call hfill(100,phi,0.,1.)                          ! Last azimutal angle.
                 call hfill(101,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                      ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=1.                                     ! Identify this decay branch.
                 nt_data(34)=0
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif
C Save generator data
              if (i.gt.nskip) then
                 write(lunasc,*)nr_part
                 do j=1,nr_part
                    write(lunasc,100) 1,
     1                   int(pid(j)),
     1                   version,
     1                   revision,
     1                   momentum(3*j-2),
     1                   momentum(3*j-1),
     1                   momentum(3*j),
     1                   mass(j),
     1                   0.,
     1                   event_txt(1),
     1                   energy(j)*1.e6
                 enddo
              endif
              
C*********************************************************************************
C*********************************************************************************

C Generate the 228Ra -> 228Ac sequence.
           elseif(rndm.gt.branch_th(1).and.rndm.le.branch_th(2))then   ! 228Ra -> 228Ac sequence
              hit(2)=hit(2)+1
C Generate one 228Ra beta decay. Three branches are implemented.

              call ra228_momentum

C Save ntuple data.
              if(nt_save)then
                 call hfill(200,phi,0.,1.)                          ! Last azimutal angle.
                 call hfill(201,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=2.                                    ! Identify this decay branch.
                 nt_data(34)=0.                                    ! Long lived no time correlation.
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                              ! Write ntuple data.
              endif
C Save 228Ra generator data in two dimensional array.

              nr_part_c(1)=nr_part
              do j=1,nr_part
                 pid_c(j,1)=pid(j)
                 momentum_c(3*j-2,1)=momentum(3*j-2)
                 momentum_c(3*j-1,1)=momentum(3*j-1)
                 momentum_c(3*j,1)=momentum(3*j)
                 mass_c(j,1)=mass(j)
                 time_c(1)=0.
                 event_txt_c(j,1)=event_txt(2)
                 energy_c(j,1)=energy(j)
              enddo

C Show 228Ra decay data

C              write(*,*)nr_part
C              do j=1,nr_part
C                 write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       0.,
C     1                       event_txt(2)
C              enddo
C              write(*,*)'*****************************************'


C
C
C******************************************************************************
C
C 228Ac beta decay! 
C 

C Generate one 228Ac beta decay. 13 branches are implemented.
              call funlux(tau_space3,time,1)
C              call funran(tau_space3,time,1)
C Reset ntuple data array.
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo

C Get one 228Ac decay.

              call ac228_momentum

C Save ntuple data
              if(nt_save)then
                 call hfill(300,phi,0.,1.)                          ! Last azimutal angle.
                 call hfill(301,cos_theta,0.,1.)                    ! Last cos(zenith).
                 call hfill(302,time,0.,1.)                        ! Short lived. Get correlation time.
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                     ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=3.                                    ! Identify this decay branch.
                 nt_data(34)=time                                  ! Correlated to previous decay.
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                              ! Write ntuple data.
              endif

C Save 228Ac generator data in two dimensional array.
              nr_part_c(2)=nr_part
              do j=1,nr_part
                 pid_c(j,2)=pid(j)
                 momentum_c(3*j-2,2)=momentum(3*j-2)
                 momentum_c(3*j-1,2)=momentum(3*j-1)
                 momentum_c(3*j,2)=momentum(3*j)
                 mass_c(j,2)=mass(j)
                 time_c(2)=time
                 event_txt_c(j,2)=event_txt(3)
                 energy_c(j,2)=energy(j)
              enddo

C Show 228Ac decay data.

C              write(*,*)nr_part
C              do j=1,nr_part
C                 write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(3)
C              enddo
C              write(*,*)'*****************************************'

C*********************************************************************************

C Save generator data for this correlated chain.
              if (i.gt.nskip) then

                 write(lunasc,*)nr_part_c(1)+nr_part_c(2)
C     Save correlated event data
                 do k=1,2
                    do j=1,nr_part_c(k)
C     Save the time correlation only once
                       if(j.eq.1)then
                          write(lunasc,100) 1, 
     1                         int(pid_c(j,k)),
     1                         version,
     1                         revision,
     1                         momentum_c(3*j-2,k),
     1                         momentum_c(3*j-1,k),
     1                         momentum_c(3*j,k),
     1                         mass_c(j,k),
     1                         time_c(k)*1.e9,
     1                         event_txt_c(j,k),
     1                         energy_c(j,k)*1.e6
                       else
                          write(lunasc,100) 1, 
     1                         int(pid_c(j,k)),
     1                         version,
     1                         revision,
     1                         momentum_c(3*j-2,k),
     1                         momentum_c(3*j-1,k),
     1                         momentum_c(3*j,k),
     1                         mass_c(j,k),
     1                         0.,
     1                         event_txt_c(j,k),
     1                         energy_c(j,k)*1.e6
                       endif
                    enddo
                 enddo
              endif
C              write(*,*)'*****************************************'
C              read(*,*)

C*********************************************************************************
C*********************************************************************************

C Generate one 228Th alpha decay. Two branches are implemented.

           elseif(rndm.gt.branch_th(2).and.rndm.le.branch_th(3))then  ! 228Th
              hit(3)=hit(3)+1
              call th228_momentum
              if(nt_save)then
                 call hfill(400,phi,0.,1.)                          ! Last azimutal angle.
                 call hfill(401,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=4.                                     ! Identify this decay branch.
                 nt_data(34)=0.
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif
C Save generator data
              if (i.gt.nskip) then
                 write(lunasc,*)nr_part
                 do j=1,nr_part
                    write(lunasc,100) 1,
     1                   int(pid(j)),
     1                   version,
     1                   revision,
     1                   momentum(3*j-2),
     1                   momentum(3*j-1),
     1                   momentum(3*j),
     1                   mass(j),
     1                   0.,
     1                   event_txt(4),
     1                   energy(j)*1.e6
                 enddo
              endif

C*********************************************************************************
C*********************************************************************************

C Generate the 224Ra -> 220Rn -> 216Po -> 212Pb -> 212Bi -> 212Po -> 208Pb
C                                                        -> 208Tl -> 208Pb decay sequence.
C All correlated decays are treated as one event.

           elseif(rndm.gt.branch_th(3))then                        ! 224Ra
C     Generate one 224Ra alpha decay. Two branches are implemented.
              hit(4)=hit(4)+1
              call ra224_momentum

C Save ntuple data.
              if(nt_save)then
                 call hfill(500,phi,0.,1.)                          ! Last azimutal angle.
                 call hfill(501,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=5.                                     ! Identify this decay branch.
                 nt_data(34)=0.
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif

C Save 224Ra generator data in two dimensional array.

              nr_part_c(1)=nr_part
              do j=1,nr_part
                 pid_c(j,1)=pid(j)
                 momentum_c(3*j-2,1)=momentum(3*j-2)
                 momentum_c(3*j-1,1)=momentum(3*j-1)
                 momentum_c(3*j,1)=momentum(3*j)
                 mass_c(j,1)=mass(j)
                 time_c(1)=0.
                 event_txt_c(j,1)=event_txt(5)
                 energy_c(j,1)=energy(j)
              enddo

C Show data

C              write(*,*)nr_part
C              do j=1,nr_part
C                 write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(7)
C                 write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C              enddo
C              write(*,*)'**************************************************************'

C*********************************************************************************

C Generate one 220Rn alpha decay. One branch is implemented.
             call funlux(tau_space6,time,1)
C              call funran(tau_space6,time,1)                     ! Generate correlation time to previous decay.
C Reset ntuple data array for correlated event.
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo
              call rn220_momentum

C Save ntuple data.
              if(nt_save)then
                 call hfill(600,phi,0.,1.)                          ! Last azimutal angle.
                 call hfill(601,cos_theta,0.,1.)                    ! Last cos(zenith).
                 call hfill(602,time,0.,1.)                         ! Short lived. Get correlation time.
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=6.                                     ! Identify this decay branch.
                 nt_data(34)=time
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif
C Save 220Rn generator data in two dimensional array.

              nr_part_c(2)=nr_part
              do j=1,nr_part
                 pid_c(j,2)=pid(j)
                 momentum_c(3*j-2,2)=momentum(3*j-2)
                 momentum_c(3*j-1,2)=momentum(3*j-1)
                 momentum_c(3*j,2)=momentum(3*j)
                 mass_c(j,2)=mass(j)
                 time_c(2)=time
                 event_txt_c(j,2)=event_txt(6)
                 energy_c(j,2)=energy(j)
              enddo
C Show data

C              write(*,*)nr_part
C              do j=1,nr_part
C                 write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(6)
C                 write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C              enddo
C              write(*,*)'**************************************************************'

C*********************************************************************************

C Generate one 216Po alpha decay. One branch is implemented.

             call funlux(tau_space7,time,1)
C              call funran(tau_space7,time,1)                     ! Generate correlation time to previous decay.
C Reset ntuple data array for correlated event.
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo
              call po216_momentum

C Save ntuple data
              if(nt_save)then
                 call hfill(700,phi,0.,1.)                          ! Last azimutal angle.
                 call hfill(701,cos_theta,0.,1.)                    ! Last cos(zenith).
                 call hfill(702,time,0.,1.)
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=7.                                     ! Identify this decay branch.
                 nt_data(34)=time
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif

C Save generator data

C Save 216Po generator data in two dimensional array.

              nr_part_c(3)=nr_part
              do j=1,nr_part
                 pid_c(j,3)=pid(j)
                 momentum_c(3*j-2,3)=momentum(3*j-2)
                 momentum_c(3*j-1,3)=momentum(3*j-1)
                 momentum_c(3*j,3)=momentum(3*j)
                 mass_c(j,3)=mass(j)
                 time_c(3)=time
                 event_txt_c(j,3)=event_txt(7)
                 energy_c(j,3)=energy(j)
              enddo

C Show data

C              write(*,*)nr_part
C              do j=1,nr_part
C                 write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(7)
C                 write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C              enddo
C              write(*,*)'**************************************************************'

C*********************************************************************************

C Generate one 212Pb beta decay. Three branches are implemented.
             call funlux(tau_space8,time,1)
C              call funran(tau_space8,time,1)                     ! Generate correlation time to previous decay.
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo
              call pb212_momentum

C Save ntuple data
              if(nt_save)then
                 call hfill(800,phi,0.,1.)                          ! Last azimutal angle.
                 call hfill(801,cos_theta,0.,1.)                    ! Last cos(zenith).
                 call hfill(802,time,0.,1.)
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=8.                                     ! Identify this decay branch.
                 nt_data(34)=time
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif
C Save 212Pb generator data in two dimensional array

              nr_part_c(4)=nr_part
              do j=1,nr_part
                 pid_c(j,4)=pid(j)
                 momentum_c(3*j-2,4)=momentum(3*j-2)
                 momentum_c(3*j-1,4)=momentum(3*j-1)
                 momentum_c(3*j,4)=momentum(3*j)
                 mass_c(j,4)=mass(j)
                 time_c(4)=time
                 event_txt_c(j,4)=event_txt(8)
                 energy_c(j,4)=energy(j)
              enddo

C Show 212Pb data 
C
C              write(*,*)nr_part
C              do j=1,nr_part
C                 write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(8)
C                 write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C              enddo
C              write(*,*)'**************************************************************'


C*********************************************************************************

C Generate one 212Bi beta decay and one 212Po alpha decay.
              call funlux(tau_space9,time,1)
C              call funran(tau_space9,time,1)
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo

C Decide whether beta or alphe branch is to be generated.
              call ranlux(rndm_bi,1)

              if(rndm_bi.le.branch_bi212_b_a(1))then  ! Beta decay
                 call bi212_beta_momentum

C Save ntuple data
                 if(nt_save)then
                    call hfill(900,phi,0.,1.)                          ! Last azimutal angle.
                    call hfill(901,cos_theta,0.,1.)                    ! Last cos(zenith).
                    call hfill(902,time,0.,1.)
                    do j=1,nr_part
                       nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                       nt_data(j+10)=float(pid(j))
                       nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                    enddo
                    nt_data(31)=float(nr_part)
                    nt_data(32)=float(i)
                    nt_data(33)=9.                                    ! Identify this decay branch.
                    nt_data(34)=time
                    call hcdir(chpath,' ')
                    call hfn(10,nt_data)                               ! Write ntuple data.
                 endif
C Save 212Bi beta generator data in two dimensional array

                 nr_part_c(5)=nr_part
                 do j=1,nr_part
                    pid_c(j,5)=pid(j)
                    momentum_c(3*j-2,5)=momentum(3*j-2)
                    momentum_c(3*j-1,5)=momentum(3*j-1)
                    momentum_c(3*j,5)=momentum(3*j)
                    mass_c(j,5)=mass(j)
                    time_c(5)=time
                    event_txt_c(j,5)=event_txt(9)
                    energy_c(j,5)=energy(j)
                 enddo

C Show data
C                 write(*,*)nr_part
C                 do j=1,nr_part
C                   write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(9)
C                    write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C                 enddo
C                 write(*,*)'**************************************************************'


C*********************************************************************************

C Generate one 212Po alpha decay. One branch is implemented.
                 call funlux(tau_space10,time,1)
C                 call funran(tau_space10,time,1)
C Reset ntuple data array.
                 do j=1,ntuple_entries
                    nt_data(j)=0.                                 
                 enddo

                 call po212_momentum

C Save ntuple data
                 if(nt_save)then
                    call hfill(1000,phi,0.,1.)                          ! Last azimutal angle.
                    call hfill(1001,cos_theta,0.,1.)                    ! Last cos(zenith).
                    call hfill(1002,time,0.,1.)
                    do j=1,nr_part
                       nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                       nt_data(j+10)=float(pid(j))
                       nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                    enddo
                    nt_data(31)=float(nr_part)
                    nt_data(32)=float(i)
                    nt_data(33)=10.                                    ! Identify this decay branch.
                    nt_data(34)=time
                    call hcdir(chpath,' ')
                    call hfn(10,nt_data)                               ! Write ntuple data.
                 endif
C Save 212Po generator data in two dimensional array

                 nr_part_c(6)=nr_part
                 do j=1,nr_part
                    pid_c(j,6)=pid(j)
                    momentum_c(3*j-2,6)=momentum(3*j-2)
                    momentum_c(3*j-1,6)=momentum(3*j-1)
                    momentum_c(3*j,6)=momentum(3*j)
                    mass_c(j,6)=mass(j)
                    time_c(6)=time
                    event_txt_c(j,6)=event_txt(10)
                    energy_c(j,6)=energy(j)
                 enddo

C Show data
C                 write(*,*)nr_part
C                 do j=1,nr_part
C                    write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(10)
C                    write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C                 enddo
C                 write(*,*)'**************************************************************'

C Save generator data for this correlated chain.
                 if (i.gt.nskip) then
                    write(lunasc,*)nr_part_c(1)+nr_part_c(2)+
     1                   nr_part_c(3)+nr_part_c(4)+
     1                   nr_part_c(5)+nr_part_c(6)
C     Save correlated event data
                    do k=1,nr_corr
                       do j=1,nr_part_c(k)
C     save time only once
                          if(j.eq.1)then
                             write(lunasc,100) 1, 
     1                            int(pid_c(j,k)),
     1                            version,
     1                            revision,
     1                            momentum_c(3*j-2,k),
     1                            momentum_c(3*j-1,k),
     1                            momentum_c(3*j,k),
     1                            mass_c(j,k),
     1                            time_c(k)*1.e9,
     1                            event_txt_c(j,k),
     1                            energy_c(j,k)*1.e6
                          else
                             write(lunasc,100) 1, 
     1                            int(pid_c(j,k)),
     1                            version,
     1                            revision,
     1                            momentum_c(3*j-2,k),
     1                            momentum_c(3*j-1,k),
     1                            momentum_c(3*j,k),
     1                            mass_c(j,k),
     1                            0.,
     1                            event_txt_c(j,k),
     1                            energy_c(j,k)*1.e6
                          endif
                       enddo
                    enddo
                 endif
C              write(*,*)'*****************************************'
C              read(*,*)

C*********************************************************************************

C 212Bi alpha decay sequence
               else                ! 212Bi alpha decay

C Generate one 212Bi alpha decay.Two branches are implemented.
                 call funlux(tau_space9,time,1)
C                 call funran(tau_space9,time,1)
C Reset ntuple data array
                 do j=1,ntuple_entries
                    nt_data(j)=0.                                 
                 enddo

                 call bi212_alpha_momentum

C Save ntuple data
                 if(nt_save)then
                    call hfill(900,phi,0.,1.)                          ! Last azimutal angle.
                    call hfill(901,cos_theta,0.,1.)                    ! Last cos(zenith).
                    call hfill(902,time,0.,1.)
                    do j=1,nr_part
                       nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                       nt_data(j+10)=float(pid(j))
                       nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                    enddo
                    nt_data(31)=float(nr_part)
                    nt_data(32)=float(i)
                    nt_data(33)=11.                                    ! Identify this decay branch.
                    nt_data(34)=time
                    call hcdir(chpath,' ')
                    call hfn(10,nt_data)                               ! Write ntuple data.
                 endif
C Save 212Bi generator data in two dimensional aray

                 nr_part_c(5)=nr_part
                 do j=1,nr_part
                    pid_c(j,5)=pid(j)
                    momentum_c(3*j-2,5)=momentum(3*j-2)
                    momentum_c(3*j-1,5)=momentum(3*j-1)
                    momentum_c(3*j,5)=momentum(3*j)
                    mass_c(j,5)=mass(j)
                    time_c(5)=time
                    event_txt_c(j,5)=event_txt(11)
                    energy_c(j,5)=energy(j)
                 enddo

C Show data
C                 write(*,*)nr_part
C                 do j=1,nr_part
C                    write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(11)
C                    write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C                 enddo
C                 write(*,*)'**************************************************************'


C*********************************************************************************

C Generate one 208Tl beta decay. Four branches are implemented.
                 call funlux(tau_space11,time,1)
C                 call funran(tau_space11,time,1)
C Reset ntuple data array
                 do j=1,ntuple_entries
                    nt_data(j)=0.                                 
                 enddo

                 call tl208_momentum

C Save ntuple data
                 if(nt_save)then
                    call hfill(1100,phi,0.,1.)                          ! Last azimutal angle.
                    call hfill(1101,cos_theta,0.,1.)                    ! Last cos(zenith).
                    call hfill(1102,time,0.,1.)
                    do j=1,nr_part
                       nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                       nt_data(j+10)=float(pid(j))
                       nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                    enddo
                    nt_data(31)=float(nr_part)
                    nt_data(32)=float(i)
                    nt_data(33)=12.                                    ! Identify this decay branch.
                    nt_data(34)=time
                    call hcdir(chpath,' ')
                    call hfn(10,nt_data)                               ! Write ntuple data.
                 endif
C Save 208Tl generator data in two dimensional aray

                 nr_part_c(6)=nr_part
                 do j=1,nr_part
                    pid_c(j,6)=pid(j)
                    momentum_c(3*j-2,6)=momentum(3*j-2)
                    momentum_c(3*j-1,6)=momentum(3*j-1)
                    momentum_c(3*j,6)=momentum(3*j)
                    mass_c(j,6)=mass(j)
                    time_c(6)=time
                    event_txt_c(j,6)=event_txt(12)
                    energy_c(j,6)=energy(j)
                 enddo

C Show data
C                 write(*,*)nr_part
C                 do j=1,nr_part
C                    write(*,100) 1,
C     1                       int(pid(j)),
C     1                       version,
C     1                       revision,
C     1                       momentum(3*j-2),
C     1                       momentum(3*j-1),
C     1                       momentum(3*j),
C     1                       mass(j),
C     1                       time*1.e9,
C     1                       event_txt(12)
C                    write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C                 enddo
C                 write(*,*)'**************************************************************'

C Save generator data for this correlated chain.
                 if (i.gt.nskip) then
                    write(lunasc,*)nr_part_c(1)+nr_part_c(2)+
     1                   nr_part_c(3)+nr_part_c(4)+
     1                   nr_part_c(5)+nr_part_c(6)
C     Save correlated event data
                    do k=1,nr_corr
                       do j=1,nr_part_c(k)
C     Save time only once
                          if(j.eq.1)then
                             write(lunasc,100) 1, 
     1                            int(pid_c(j,k)),
     1                            version,
     1                            revision,
     1                            momentum_c(3*j-2,k),
     1                            momentum_c(3*j-1,k),
     1                            momentum_c(3*j,k),
     1                            mass_c(j,k),
     1                            time_c(k)*1.e9,
     1                            event_txt_c(j,k),
     1                            energy_c(j,k)*1.e6
                          else
                             write(lunasc,100) 1, 
     1                            int(pid_c(j,k)),
     1                            version,
     1                            revision,
     1                            momentum_c(3*j-2,k),
     1                            momentum_c(3*j-1,k),
     1                            momentum_c(3*j,k),
     1                            mass_c(j,k),
     1                            0.,
     1                            event_txt_c(j,k),
     1                            energy_c(j,k)*1.e6
                          endif
                       enddo
                    enddo
                 endif
C                 write(*,*)'*****************************************'
C                 read(*,*)

C*********************************************************************************
C*********************************************************************************

C 212Bi done.

              endif

C*********************************************************************************

C Decision which member of chain done.
           endif

C End loop over all events

        enddo

C Close ntuple and save histograms.

        if(nt_save)then
           call hcdir(chpath,' ')
           call hrout(0,icycle,' ')
           call hrend('Th_decays')
           close(unit=1)
        endif

        if (lunasc.eq.20) then
           close(unit=20)
        endif

C Output the distribution

        do i=1,nr_series_brnch
           write(*,*)
           write(*,*)'! ',i,' probabilty: ',hit(i)/float(nr_events)
        enddo

        stop

        end



