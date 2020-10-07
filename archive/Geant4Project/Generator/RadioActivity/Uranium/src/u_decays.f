
      program u_decays

C Program to simulate 238U decays. It is assumed that the decay series is in
C secular equilibrium. This means that all members decay with the same rate
C determined by the concentration of 238U feeding the series. Members of the 
C series with short life time are created together with a correlation
C time. The others are only statistically the same.
C
C 9/3/2001 A. Piepke
C
C All correlated events are stored as a single event. Introduce multi dimensional
C arrays to hold the info. Save particle mass with every particle generated.
C All subroutines generating the momentum distributions have been changed accordingly.
C HBOOK objects can be suppressed by setting of a variable.
C
C 9/30/2001 A.P.
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
C one used previously (funran) created a pathological time distribution at large time
C differences. Code compiles now on LINUX machines. Booking range of cos(Q) histograms
C corrected from 0. to 1. to now -1. to 1.
C
C A. Piepke 9/23/2002
C
C
C Revised 5/13/2005 by D. Ray to conform to new KLG4sim MC event generator
C  output scheme. The behavior of u_decays is governed by the number of
C  arguments passed to it:
C
C  zero args:  100k decays written in KLHEPEVT format to 'u_decays.asc'
C  one arg:    <arg1> decays written in KLHEPEVT format to standard output
C  two args:   skips <arg1> decays, then writes <arg2> decays in KLHEPEVT
C               format to standard output
C  >2 args:    same as for two args, plus HBOOKs also written.
C
C Also added a few helpful (hopefully) print statements & comments.
C
C
C Modified 17aug07 djaffe to make input arguments more compatible with
C                  Daya Bay standards
C                  
C Treatment of arguments is the same as above except that in the
C case of two or more arguments, the second argument is interpreted
C as the random seed.

        implicit none

        include 'decay.inc'
        include 'momentum.inc'

C Arrays to hold data for correlated decays.

        integer nr_corr                     ! Maximal number of correlated decays.
        parameter(nr_corr=5)
	real*4 momentum_c(array_p,nr_corr)! Array holding the momentum [GeV] for correlated decyas.
	real*4 energy_c(array_e,nr_corr)  ! Array holding the kinetic energies [GeV] for correlated decyas.
	integer*4 pid_c(array_e,nr_corr)  ! Array holding the particle id's for correlated decyas.
        real*4 time_c(nr_corr)            ! Event time for correlated events.
        real*4 mass_c(array_e,nr_corr)    ! Particle rest masses in [GeV] for correlated decays.
	integer*4 nr_part_c(nr_corr)	  ! Total number of particles generated in this correlated decay.
        character*20 event_txt_c(array_e,nr_corr)! Text identifying the event in correlated chain.

        integer version
        data version/0/
        integer revision
        data revision/0/

C Hbook variables
        logical*4 nt_save
        integer*4 npawc
        parameter(npawc=1000000)
	real H
        common/pawc/H(npawc)
        integer*4 id            ! Histogram id.
        integer*4 istat,icycle
        character*20 file_ntuple
        data file_ntuple/'u_decays.hist'/
C Ntuple definitions
	character*20 chtitle,chpath
        integer*4 ntuple_entries
        parameter(ntuple_entries=34)
	character*8 chtags(ntuple_entries)	! Names of the variables to be saved in ntuple.
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

	real*4 nt_data(ntuple_entries)	        ! Data stored in ntuple.

C Othe program variables

        integer i,j,k                       ! Counters
        integer id_nr                       ! Histogram ID number
        integer nr_events                   ! Number of events to generate
                                            !  (including skipped)
        integer nskip                       ! # of events to skip before output
        integer lunasc                      ! Logical unit for output

        real*4 hit(9)           ! Number of decays to each branch

        real*4 decay_func3      ! Decay time function of 234mPa
        real*4 decay_func8      ! Decay time function of 218Po
        real*4 decay_func9      ! Decay time function of 214Pb
        real*4 decay_func10     ! Decay time function of 214Bi
        real*4 decay_func11     ! Decay time function of 214Po
	real*4 rndm		! Random number
	logical*4 tfg/.false./	! Marks the first decay for which the random
				! number generator has to be initialized.
        real*4 tau_space3(200)  ! Array to create rndom decay time [s]. 234mPa
        real*4 tau_space8(200)  ! Array to create rndom decay time [s]. 218Po
        real*4 tau_space9(200)  ! Array to create rndom decay time [s]. 214Pb
        real*4 tau_space10(200) ! Array to create rndom decay time [s]. 2214Bi
        real*4 tau_space11(200) ! Array to create rndom decay time [s]. 214Po
        real*4 time             ! random correlation time [s].
        character*20 event_txt(14) ! Text identifying the event
        data event_txt(1)/'# 238U alpha decay'/
        data event_txt(2)/'# 234Th beta decay'/
        data event_txt(3)/'# 234Pa beta decay'/
        data event_txt(4)/'# 234U alpha decay'/
        data event_txt(5)/'# 230Th alpha decay'/
        data event_txt(6)/'# 226Ra alpha decay'/
        data event_txt(7)/'# 222Rn alpha decay'/
        data event_txt(8)/'# 218Po alpha decay'/
        data event_txt(9)/'# 214Pb beta decay'/
        data event_txt(10)/'# 214Bi beta decay'/
        data event_txt(11)/'# 214Po alpha decay'/
        data event_txt(12)/'# 210Pb beta decay'/
        data event_txt(13)/'# 210Bi beta decay'/
        data event_txt(14)/'# 210Po alpha decay'/
        
        external decay_func3
        external decay_func8
        external decay_func9
        external decay_func10
        external decay_func11

C This is the KLHEPEVT format:
C ISTHEP IDHEP JDA1 JDA2 PX PY PZ PMASS DT0, plus comment (inc. gamma energy)
C See KLG4sim generator documentation by Glenn for more info.

 100    format(i2,2x,i7,2x,i1,2x,i1,2x,e10.4,2x,e10.4,
     1         2x,e10.4,2x,e10.4,2x,e11.5,2x,a20,2x,f8.3)

C--------------------------------------------------
C Initializations to be done during the first call.
C--------------------------------------------------

	if(.not.tfg)then

C Set defaults for no cmdline args, including # of events

           nr_events=100000
C           nt_save=.true.          ! Create ntuple and histograms.
           nt_save=.false.         ! No HBOOK objects.
           nskip=0
           is = 549               ! Default random seed
           lunasc=20              ! Default unit for output

C Parse cmdline args, if any.


           CALL DOCMDOPT(nr_events, is, nt_save, lunasc)

C Initialize "hit" array

           do i=1,9
              hit(i)=0.
           enddo

C HBOOK-specific initializations.

           if(nt_save)then

              write(*,*)
              write(*,*) '! Initialize HBOOK data structures'

C   Book memory for HBOOK.

              call hlimit(npawc)

	      call hropen(1,'U_decays',file_ntuple,'N',1024,istat)
	      if(istat.ne.0)then
	         write(*,*)char(7),'>>>Error during booking of ntuple'
	         stop
	      endif

C   Book row wise ntuple.

              chtitle='238U decay generator'
	      call hbookn(10,chtitle,ntuple_entries,
     1		'//U_decays',3500,chtags)

              call hcdir(chpath,'R')
              write(*,*)'! Current directory: ',chpath
	      call hldir('//PAWC','N')

           endif

C Open the ASCII file.

           if (lunasc.eq.20) then
              open(unit=20,file='u_decays.asc',status='unknown')
              write (*,*) 'Writing ascii data to u_decays.asc'
           endif

C Set new seed value for the random number generator.

	   call rluxgo(lux,is,0,0)! Set new seed values. 
C	   write(*,*)'! Initialize random number generator U_DECAYS. Seed=',is
	   write(*,*)'! Initialize RNG U_DECAYS. Seed=',is

C 238U angular distribution.

           if(nt_save)then
	      call hbook1(100,'^238!U [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(101,'^238!U cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif

C 234Th angular distribution.
           if(nt_save)then
	      call hbook1(200,'^234!Th [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(201,'^234!Th cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif

C 234Pa angular distribution.
           if(nt_save)then
	      call hbook1(300,'^234m!Pa [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(301,'^234m!Pa cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif
C 234mPa: initialize decay time generation. Use external functions.
           call funlxp(decay_func3,tau_space3,0.,10.*tau(3)) ! 234mPa
C           call funpre(decay_func3,tau_space3,0.,10.*tau(3)) ! 234mPa
           if(nt_save)then
	      call hbook1(302,'^234m!Pa time distribution',
     1          100,0.,10.*tau(3),0.)
           endif

C 234U angular distribution.
           if(nt_save)then
	      call hbook1(400,'^234!U [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(401,'^234!U cos[Q] distribution',
     1          100,-1.,1.,0.)

C 230Th angular distribution.
	      call hbook1(500,'^230!Th [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(501,'^230!Th cos[Q] distribution',
     1          100,-1.,1.,0.)

C 226Ra angular distribution.
	      call hbook1(600,'^226!Ra [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(601,'^226!Ra cos[Q] distribution',
     1          100,-1.,1.,0.)

C 222Rn angular distribution.
	      call hbook1(700,'^222!Rn [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(701,'^222!Rn cos[Q] distribution',
     1          100,-1.,1.,0.)

C 218Po angular distribution.
	      call hbook1(800,'^218!Po [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(801,'^218!Po cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif

C 218Po: initialize decay time generation. Use external functions.
           call funlxp(decay_func8,tau_space8,0.,10.*tau(8))      ! 218Po
C           call funpre(decay_func8,tau_space8,0.,10.*tau(8))      ! 218Po
           if(nt_save)then
	      call hbook1(802,'^218!Po time distribution',
     1          100,0.,10.*tau(8),0.)

C 214Pb angular distribution.
	      call hbook1(900,'^214!Pb [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(901,'^214!Pb cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif

C 214Pb: initialize decay time generation. Use external functions.
           call funlxp(decay_func9,tau_space9,0.,10.*tau(9))      ! 214Pb
C           call funpre(decay_func9,tau_space9,0.,10.*tau(9))      ! 214Pb
           if(nt_save)then
	      call hbook1(902,'^214!Pb time distribution',
     1          100,0.,10.*tau(9),0.)

C 214Bi angular distribution.
	      call hbook1(1000,'^214!Bi [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(1001,'^214!Bi cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif
C 214Bi: initialize decay time generation. Use external functions.
           call funlxp(decay_func10,tau_space10,0.,10.*tau(10))   ! 214Bi
C           call funpre(decay_func10,tau_space10,0.,10.*tau(10))   ! 214Bi
           if(nt_save)then
	      call hbook1(1002,'^214!Bi time distribution',
     1          100,0.,10.*tau(10),0.)

C 214Po angular distribution.
	      call hbook1(1100,'^214!Po [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(1101,'^214!Po cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif
C 214Po: initialize decay time generation. Use external functions.
           call funlxp(decay_func11,tau_space11,0.,10.*tau(11))   ! 214Po
C           call funpre(decay_func11,tau_space11,0.,10.*tau(11))   ! 214Po
           if(nt_save)then
	      call hbook1(1102,'^214!Po time distribution',
     1          100,0.,10.*tau(11),0.)

C 210Pb angular distribution.
	      call hbook1(1200,'^210!Pb [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(1201,'^210!Pb cos[Q] distribution',
     1          100,-1.,1.,0.)

C 210Bi angular distribution.
	      call hbook1(1300,'^210!Bi [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(1301,'^210!Bi cos[Q] distribution',
     1          100,-1.,1.,0.)

C 210Po angular distribution.
	      call hbook1(1400,'^210!Po [F] distribution',
     1          100,0.,two_pi,0.)
	      call hbook1(1401,'^210!Po cos[Q] distribution',
     1          100,-1.,1.,0.)
           endif

C Convert branching ratios into probability distribution.
           do i=2,9
              branch(i)=branch(i)+branch(i-1)
           enddo
C Don't go in here again.
	   tfg=.true.
	endif

C---------------------
C Loop over all decays
C---------------------

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
                 nr_part_c(k)=0.
                 event_txt_c(j,k)='                    '
              enddo
           enddo
           do j=1,ntuple_entries
              nt_data(j)=0.
           enddo

C Generate a randum namber and decide what part of the U-series to generate.

           call ranlux(rndm,1)

           if(rndm.le.branch(1))then                             ! 238U
              hit(1)=hit(1)+1
C Generate one 238U alpha decay. Three branches are implemented.
              call u238_momentum
              if(nt_save)then
	         call hfill(100,phi,0.,1.)                          ! Last azimutal angle.
	         call hfill(101,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=1.                                     ! Identify this decay branch.
                 nt_data(34)=0
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif
C Save generator data in KLHEPEvt format
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

           elseif(rndm.gt.branch(1).and.rndm.le.branch(2))then   ! 234Th -> 234mPa sequence
              hit(2)=hit(2)+1
C Generate one 234Th beta decay. Three branches are implemented.
              call th234_momentum

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
C Save 234Th generator data in two dimensional array.

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

C Show 234Th decay data

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
C     1                       event_txt(2)
C              enddo
C              write(*,*)'*****************************************'

C Generate one 234Pa beta decay. Two branches are implemented.
              call funlux(tau_space3,time,1)
C              call funran(tau_space3,time,1)
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo

              call pa234_momentum

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

C Save 234mPa generator data in two dimensional array.
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

C Show 234mPa decay data.

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

C Output generator data for this correlated chain in KLHEPEvt format.
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
C     write(*,*)'*****************************************'
C     read(*,*)
              endif

C Generate one 234U alpha decay. Two branches are implemented.
           elseif(rndm.gt.branch(2).and.rndm.le.branch(3))then  ! 234U
              hit(3)=hit(3)+1
              call u234_momentum
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

           elseif(rndm.gt.branch(3).and.rndm.le.branch(4))then   ! 230Th
              hit(4)=hit(4)+1
C Generate one 230Th alpha decay. Two branches are implemented.
              call th230_momentum
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
     1                   event_txt(5),
     1                   energy(j)*1.e6
                 enddo
              endif

           elseif(rndm.gt.branch(4).and.rndm.le.branch(5))then   ! 226Ra
              hit(5)=hit(5)+1
C Generate one 226Ra alpha decay. Two branches are implemented.
              call ra226_momentum
              if(nt_save)then
	         call hfill(600,phi,0.,1.)                          ! Last azimutal angle.
	         call hfill(601,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=6.                                     ! Identify this decay branch.
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
     1                   event_txt(6),
     1                   energy(j)*1.e6
                 enddo
              endif

C Create 222Rn -> 218Po -> 214Pb -> 214Bi -> 214Po sequence 
           elseif(rndm.gt.branch(5).and.rndm.le.branch(6))then   ! 222Rn -> 218Po -> 214Pb ->
                                                                 ! 214Bi -> 214Po sequence
              hit(6)=hit(6)+1
C Generate one 222Rn alpha decay. Two branches are implemented.

              call rn222_momentum

C Save ntuple data
              if(nt_save)then
	         call hfill(700,phi,0.,1.)                          ! Last azimutal angle.
	         call hfill(701,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=7.                                     ! Identify this decay branch.
                 nt_data(34)=0.
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif

C (Save generator data) -- suppressed until end of decay chain

C Save 222Rn generator data in two dimensional array.

              nr_part_c(1)=nr_part
              do j=1,nr_part
                 pid_c(j,1)=pid(j)
                 momentum_c(3*j-2,1)=momentum(3*j-2)
                 momentum_c(3*j-1,1)=momentum(3*j-1)
                 momentum_c(3*j,1)=momentum(3*j)
                 mass_c(j,1)=mass(j)
                 time_c(1)=0.
                 event_txt_c(j,1)=event_txt(7)
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

C Generate one 218Po alpha decay. One branch is implemented.
             call funlux(tau_space8,time,1)
C              call funran(tau_space8,time,1)                     ! Generate correlation time to previous decay.
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo
              call po218_momentum

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
C Save 218Po generator data in two dimensional array

              nr_part_c(2)=nr_part
              do j=1,nr_part
                 pid_c(j,2)=pid(j)
                 momentum_c(3*j-2,2)=momentum(3*j-2)
                 momentum_c(3*j-1,2)=momentum(3*j-1)
                 momentum_c(3*j,2)=momentum(3*j)
                 mass_c(j,2)=mass(j)
                 time_c(2)=time
                 event_txt_c(j,2)=event_txt(8)
                 energy_c(j,2)=energy(j)
              enddo

C Show data
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

C Generate one 214Pb beta decay. 5 decay branches implemented.
              call funlux(tau_space9,time,1)
C              call funran(tau_space9,time,1)
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo
              call pb214_momentum

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
C Save 214Pb generator data in two dimensional array

              nr_part_c(3)=nr_part
              do j=1,nr_part
                 pid_c(j,3)=pid(j)
                 momentum_c(3*j-2,3)=momentum(3*j-2)
                 momentum_c(3*j-1,3)=momentum(3*j-1)
                 momentum_c(3*j,3)=momentum(3*j)
                 mass_c(j,3)=mass(j)
                 time_c(3)=time
                 event_txt_c(j,3)=event_txt(9)
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
C     1                       event_txt(9)
C                 write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C              enddo
C              write(*,*)'**************************************************************'

C Generate one 214Bi beta decay. 16 branches implemented.
              call funlux(tau_space10,time,1)
C              call funran(tau_space10,time,1)
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo
              call bi214_momentum

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
C Save 214Bi generator data in two dimensional array

              nr_part_c(4)=nr_part
              do j=1,nr_part
                 pid_c(j,4)=pid(j)
                 momentum_c(3*j-2,4)=momentum(3*j-2)
                 momentum_c(3*j-1,4)=momentum(3*j-1)
                 momentum_c(3*j,4)=momentum(3*j)
                 mass_c(j,4)=mass(j)
                 time_c(4)=time
                 event_txt_c(j,4)=event_txt(10)
                 energy_c(j,4)=energy(j)
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
C     1                       event_txt(10)
C                 write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C              enddo
C              write(*,*)'**************************************************************'

C Generate one 214Po alpha decay. One branch is implemented.
              call funlux(tau_space11,time,1)
C              call funran(tau_space11,time,1)
              do j=1,ntuple_entries
                 nt_data(j)=0.                                 
              enddo
              call po214_momentum

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
                 nt_data(33)=11.                                    ! Identify this decay branch.
                 nt_data(34)=time
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif
C Save 214Po generator data in two dimensional aray

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
C     1                       event_txt(11)
C                 write(*,*)energy(j),sqrt(momentum(3*j-2)**2+
C     1                     momentum(3*j-1)**2+momentum(3*j)**2 +
C     1                     mass(j)**2)-mass(j)
C              enddo
C              write(*,*)'**************************************************************'

C Finally output generator data for this correlated chain,
C  in KLHEPEvt format.

              if (i.gt.nskip) then
                 write(lunasc,*)nr_part_c(1)+nr_part_c(2)+
     1                nr_part_c(3)+nr_part_c(4)+
     1                nr_part_c(5)
C     Save correlated event data
                 do k=1,nr_corr
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
C     write(*,*)'*****************************************'
C     read(*,*)
              endif


C Generate one 210Pb beta decay. Two branches are implemented.
           elseif(rndm.gt.branch(6).and.rndm.le.branch(7))then   ! 210Pb
              hit(7)=hit(7)+1
              call pb210_momentum

C Save ntuple data
              if(nt_save)then
	         call hfill(1200,phi,0.,1.)                          ! Last azimutal angle.
	         call hfill(1201,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=12.                                    ! Identify this decay branch.
                 nt_data(34)=0.
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif
C Output 210Pb generator data in KLHEPEvt format
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
     1                   event_txt(12),
     1                   energy(j)*1.e6
                 enddo
              endif

C Generate one 210Bi beta decay. One branch is implemented. -> Forbiden decay with special beta spectrum.
           elseif(rndm.gt.branch(7).and.rndm.le.branch(8))then   ! 210Bi
              hit(8)=hit(8)+1
              call bi210_momentum

C Save ntuple data
              if(nt_save)then
	         call hfill(1300,phi,0.,1.)                          ! Last azimutal angle.
	         call hfill(1301,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=13.                                    ! Identify this decay branch.
                 nt_data(34)=0.
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif

C Output 210Bi generator data in KLHEPEvt format
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
     1                   event_txt(13),
     1                   energy(j)*1.e6
                 enddo
              endif

C Generate one 210Po alpha decay. One branch is implemented.
           elseif(rndm.gt.branch(8))then                         ! 210Po
              hit(9)=hit(9)+1
              call po210_momentum

C Save ntuple data
              if(nt_save)then
	         call hfill(1400,phi,0.,1.)                          ! Last azimutal angle.
	         call hfill(1401,cos_theta,0.,1.)                    ! Last cos(zenith).
                 do j=1,nr_part
                    nt_data(j)=energy(j)*1.e6                       ! Energies in [keV]
                    nt_data(j+10)=float(pid(j))
                    nt_data(j+20)=mass(j)*1.e6                       ! Energies in [keV]
                 enddo
                 nt_data(31)=float(nr_part)
                 nt_data(32)=float(i)
                 nt_data(33)=14.                                    ! Identify this decay branch.
                 nt_data(34)=0.
                 call hcdir(chpath,' ')
                 call hfn(10,nt_data)                               ! Write ntuple data.
              endif

C Output 210Po generator data in KLHEPEvt format
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
     1                   event_txt(14),
     1                   energy(j)*1.e6
                 enddo
              endif

C End of if-elseif-elseif-... for choice of branch

           endif

C End loop over all events

        enddo

C Close ntuple and save histograms.

        if(nt_save)then
           call hcdir(chpath,' ')
           call hrout(0,icycle,' ')
	   call hrend('U_decays')
	   close(unit=1)
        endif

C Close ascii file (if necessary)
        if (lunasc.eq.20) then
           close(unit=20)
        endif

C Output the distribution

        write(*,*) '! '
        do i=1,9
           write(*,*) '! ',i,' probabilty: ',hit(i)/float(nr_events)
        enddo

        stop

        end



