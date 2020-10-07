
	subroutine correct_210bi

C Program to generate the shape of the 210Bi beta spectrum. A correction to the allowed
C shape is applied. The phenomenological correction function has been derived by comparing
C the calculated allowed shape to a measured 210Bi beta spectrum: 
C H. Daniel, Nucl. Phys. 31 (1962) 293.
C
C 12/19/1995 A. Piepke
C
C 8/27/2001 A.P.: Converted into a subroutine for use in KamLAND event generator.
C

	implicit none

	include 'fermi_bin.inc'
	include 'decay.inc'

	real*4 energy,c
	real*4 m_e/511./
	integer*4 i
	real*4 norm

C Calculate the corrected spectrum.

	norm=0.
	do i=1,int(1.e6*e_beta_bi210(1))
		energy=(sngl(efermi(i))+511.)/m_e
		c=1.+(0.578*energy)+(28.466/energy)-(0.658*energy**2.)
		probfermi_s(i)=probfermi_s(i)*c
		norm=norm+probfermi_s(i)
	enddo

	do i=1,int(1.e6*e_beta_bi210(1))
	   probfermi_s(i)=probfermi_s(i)/norm
	enddo

	return

	end

	


