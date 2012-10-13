
      subroutine bi210_momentum

C Subroutine to generate the momenta and kinetic energies of all particles
C emitted in the 210Bi decay. This is a forbidden decay (Ra E). A special
C parameterization of the beta spectrum is used.
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
        real*4 beta(nr_beta_bins_bi210) ! Work array to create random beta energy. Need
                                ! because random number generator can only handle one
                                ! One dimensional arrays.

C Initializations to be done during the first call.

	if(.not.tfg)then

C Calculate beta distribution.
           call fermi_bin(1000.*e_beta_bi210(1),84,210,0)
C Correct allowed shape.
           call correct_210bi
           if(fpoint_nr.ne.int(1.e6*e_beta_bi210(1)))then
              write(*,*)'>>>Beta array too long or short in: ',
     1        'bi210_momentum'
              write(*,*)'Fermi_bin nr. of bins: ',fpoint_nr
              write(*,*)'Expected             : ',
     1        int(1.e6*e_beta_bi210(1))
              if(fpoint_nr.gt.int(1.e6*e_beta_bi210(1)))then
                 stop
              endif
           endif
           write(*,*)'! Fill beta array'
           do j=1,fpoint_nr
             beta(j)=probfermi_s(j)
           enddo
C Initialize random number generator by calculating the cumulative the distributions.
           call hispre(beta,fpoint_nr)
C          call rnhpre(beta,fpoint_nr)
C           write(*,*)'Beta branching state: ',i,' branch: ',
C     1     branch_bi210(i)
C           write(*,*)'*****************************'

C Set new seed value for the random number generator.
           is=is+1191960
	   call rluxgo(lux,is,0,0)! Set new seed values. 
	   write(*,*)'! Initialize random number generator BI210_MOMENTUM'

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

C Ground state decay.
        nr_part=1                       ! One particle is emitted
        pid(1)=11                       ! Electron
        mass(1)=m_e                     ! Save rest mass
        call hisran(beta,int(1.e6*e_beta_bi210(1))-1,0.,1.,energy(1))
C        call rnhran(beta,int(1.e6*e_beta_bi210(1))-1,0.,1.,energy(1))
        energy(1)=energy(1)*1.e-6
C Convert kinetic energy into total momentum.
        total_energy=sqrt(energy(1)*(energy(1)+2.*m_e))
C Get momentum vector with isotropic angular distribution.
        call ran_momentum(total_energy,momentum_in)
	momentum(1)=momentum_in(1)
	momentum(2)=momentum_in(2)
	momentum(3)=momentum_in(3)

c*************************************************************************************

        return

        end
