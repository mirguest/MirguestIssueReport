
        integer*4 lux           ! Luxury level of random number generator
	data lux/2/		! Default luxury level. 
	integer*4 is		! Seed values for the random number generator
	data is/6463/
        integer*4 array_p	! Lenght of array holding momentum.
        parameter(array_p=30)	! Long enough for 10 particles.
	integer*4 array_e	! Length of array holding kinetic energies
	parameter(array_e=array_p/3)
	real*4 momentum(array_p)! Array holding the momentum [GeV]
	real*4 momentum_in(3)
	real*4 energy(array_e)  ! Array holding the kinetic energies [GeV]
	integer*4 pid(array_e)	! Array holding the particle id's
	real*4 mass(array_e)	! Particle rest mass in [GeV]
	integer*4 nr_part	! Total number of particles generated in this decay.

	real*4 phi		! Azimut angle (angle with the x-axis). Is
				! randomly distributed from 0 to 360.
	real*4 cos_theta,sin_theta ! cos of the polar angle theta (angle with 
				! z-axis). Is randomly distributed from 1 to -1.
	real*4 two_pi/6.283185308/
        real*4 m_alpha		! Alpha mass in [GeV]
        data m_alpha/3.727417/
	real*4 m_e		! Electron mass in [GeV]
	data m_e/0.000510999/
	real*4 m_g		! Gamma mass
	data m_g/0.0/

	common/p_data/momentum,energy,mass,nr_part,pid,phi,cos_theta

