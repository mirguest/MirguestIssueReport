
C Branching ratios of the 238U decay series.

        real*4 branch(9)          ! Branching ratio of all members of the U-decay
                                  ! series.
                                  ! Identifies which decay is to be generated.
                                  !  1: 238U alpha decay
        data branch(1)/0.1111/
                                  !  2: 234Th beta decay -> is correlated to 234mPa
                                  !  3: 234mPa beta decay
        data branch(2)/0.1111/
                                  !  4: 234U alpha decay
        data branch(3)/0.1111/
                                !  5: 230Th alpha decay
        data branch(4)/0.1111/
                                  !  6: 226Ra alpha decay
        data branch(5)/0.1111/
                                  !  7: 222Rn alpha decay -> is correlated to 218Po
                                  !  8: 218Po alpha decay -> is correlated to 214Pb
                                  !  9: 214Pb beta decay -> is correlated to 214Bi
                                  ! 10: 214Bi beta decay -> is correlated to 214Po
                                  ! 11: 214Po alpha decay
        data branch(6)/0.1111/
                                  ! 12: 210Pb beta decay
        data branch(7)/0.1111/
                                  ! 13: 210Bi beta decay
        data branch(8)/0.1111/
                                ! 14: 210Po alpha decay
        data branch(9)/0.1111/

C Decay times [s] of the short lived members of the 238U decay series. 

        real*4 tau(14)          ! Live times [s] of the series members. Only important
                                ! if short enough that correlations might be used.
        data tau(1)/0./		! 238U
	data tau(2)/0./		! 234Th
	data tau(3)/101.28/	! 234mPa
        data tau(4)/0./		! 234U 
	data tau(5)/0./		! 230Th
	data tau(6)/0./		! 226Ra
        data tau(7)/0./		! 222Rn
	data tau(8)/268.34/	! 218Po
	data tau(9)/2319.9/ 	! 214Pb
        data tau(10)/1722.6/	! 214Bi 
	data tau(11)/237.3e-6/	! 214Po
	data tau(12)/0./	! 210Pb 
        data tau(13)/0./	! 210Bi 
	data tau(14)/0./	! 210Po 

C Branching ratios and energies [GeV] of the 238U alpha decay.

	real*4 branch_u238(3)			! Branching ratios
	data branch_u238(1)/0.79/		! Ground state
	data branch_u238(2)/0.209/		! E=49.6 keV excited state
	data branch_u238(3)/0.001/		! E=163 keV excited state
	integer*4 nr_branch_u238/3/

	real*4 e_alpha_u238(3)			! Alpha kinetic energies [GeV]
	data e_alpha_u238(1)/4.27e-3/		! Ground state
	data e_alpha_u238(2)/4.22e-3/		! E=49.6 keV excited state
	data e_alpha_u238(3)/4.107e-3/		! E=163 keV excited state 

	real*4 e_gam_u238(3)			! Gamma energies [GeV]
	data e_gam_u238(1)/0./			! Ground state
	data e_gam_u238(2)/5.e-5/		! E=49.6 keV excited state
	data e_gam_u238(3)/1.63e-4/ 		! E=163 keV excited state

C Branching ratios and energies [GeV] of the 234Th beta decay.

	real*4 branch_th234(3)			! Branching ratios
	data branch_th234(1)/0.703/		! E=73.9 keV meta stable state (1.17 minutes)
	data branch_th234(2)/0.268/		! E=166.3 keV excited state
	data branch_th234(3)/0.029/		! E=186.7 keV excited state
	integer*4 nr_branch_th234
	parameter(nr_branch_th234=3)

	real*4 e_beta_th234(3)			! Beta Q-values [GeV]
	data e_beta_th234(1)/1.9908e-4/		! E=73.9 keV meta stable state (1.17 minutes)
	data e_beta_th234(2)/1.067e-4/		! E=166.3 keV excited state
	data e_beta_th234(3)/8.627e-5/		! E=186.7 keV excited state
	integer*4 nr_beta_bins_th234
	parameter(nr_beta_bins_th234=200)

	real*4 e_gam_th234(3,3)			! Gamma energies [GeV]
	data e_gam_th234(1,1)/7.39e-5/ 		! E=73.9 keV meta stable state (1.17 minutes)
	data e_gam_th234(1,2)/0./
	data e_gam_th234(1,3)/0./
	data e_gam_th234(2,1)/9.238e-5/		! E=166.3 keV excited state
	data e_gam_th234(2,2)/6.29e-5/
	data e_gam_th234(2,3)/2.95e-5/
	data e_gam_th234(3,1)/1.128e-4/         ! E=186.7 keV excited state
	data e_gam_th234(3,2)/8.33e-5/
	data e_gam_th234(3,3)/2.95e-5/

	real*4 branch_gam_th234(3,2)		! Branching ratio. Sometimes estimated because some multiploarities unknown.
	data branch_gam_th234(1,1)/1./		! First excited state 73.9 keV
	data branch_gam_th234(1,2)/0./
	data branch_gam_th234(2,1)/0.728/	! Second excited state 166.3 keV
	data branch_gam_th234(2,2)/0.272/
	data branch_gam_th234(3,1)/0.765/	! Third excited state 186.7 keV
	data branch_gam_th234(3,2)/0.235/
	integer nr_branch_gam_th234/2/

C Branching ratios and energies [GeV] of the 234mPa beta decay.

	real*4 branch_pa234(2)			! Branching ratios
	data branch_pa234(1)/0.99/		! Ground state.
	data branch_pa234(2)/0.01/		! E=1044.5 keV excited state.
	integer nr_branch_pa234
	parameter(nr_branch_pa234=2)

C 11/4/2001 A.P.: Beta decay endpoint for 234mPa corrected. 

	real*4 e_beta_pa234(2)			! Beta Q-values [GeV]
	data e_beta_pa234(1)/2.1121e-3/		! Ground state.
	data e_beta_pa234(2)/1.0766e-3/		! E=1044.5 keV excited state
	integer*4 nr_beta_bins_pa234
	parameter(nr_beta_bins_pa234=2112)

	real*4 e_gam_pa234(2,2)			! Gamma energies [GeV]
	data e_gam_pa234(1,1)/1.0445e-3/	! E=1044.5 keV excited state
	data e_gam_pa234(1,2)/0./
	data e_gam_pa234(2,1)/2.58e-4/
	data e_gam_pa234(2,2)/7.865e-4/		! E=1044.5 keV excited state

	real*4 branch_gam_pa234(2)		! Branching ratio for gamma emission.
	data branch_gam_pa234(1)/0.916/ 	
	data branch_gam_pa234(2)/0.084/
	integer nr_branch_gam_pa234/2/

C Branching ratios and energies [GeV] of the 234U alpha decay.

	real*4 branch_u234(2)			! Branching ratios
	data branch_u234(1)/0.714/		! Ground state
	data branch_u234(2)/0.286/		! E=53.2 keV excited state
	integer*4 nr_branch_u234/2/

	real*4 e_alpha_u234(2)			! Alpha kinetic energies [GeV]
	data e_alpha_u234(1)/4.8585e-3/		! Ground state
	data e_alpha_u234(2)/4.8053e-3/		! E=53.2 keV excited state

	real*4 e_gam_u234(2)			! Gamma energies [GeV]
	data e_gam_u234(1)/0./			! Ground state
	data e_gam_u234(2)/5.32e-5/		! E=53.2 keV excited state

C Branching ratios and energies [GeV] of the 230Th alpha decay.

	real*4 branch_th230(2)			! Branching ratios
	data branch_th230(1)/0.763/		! Ground state
	data branch_th230(2)/0.237/		! E=67.7 keV excited state
	integer*4 nr_branch_th230/2/

	real*4 e_alpha_th230(2)			! Alpha kinetic energies [GeV]
	data e_alpha_th230(1)/4.770e-3/		! Ground state
	data e_alpha_th230(2)/4.7023e-3/	! E=67.7 keV excited state

	real*4 e_gam_th230(2)			! Gamma energies [GeV]
	data e_gam_th230(1)/0./			! Ground state
	data e_gam_th230(2)/6.77e-5/		! E=67.7 keV excited state

C Branching ratios and energies [GeV] of the 226Ra alpha decay.

	real*4 branch_ra226(2)			! Branching ratios
	data branch_ra226(1)/0.9445/		! Ground state
	data branch_ra226(2)/0.0555/		! E=186.2 keV excited state
	integer*4 nr_branch_ra226/2/

	real*4 e_alpha_ra226(2)			! Alpha kinetic energies [GeV]
	data e_alpha_ra226(1)/4.8706e-3/	! Ground state
	data e_alpha_ra226(2)/4.6844e-3/	! E=186.2 keV excited state

	real*4 e_gam_ra226(2)			! Gamma energies [GeV]
	data e_gam_ra226(1)/0./			! Ground state
	data e_gam_ra226(2)/1.862e-4/		! E=186.2 keV excited state

C Branching ratios and energies [GeV] of the 222Rn alpha decay.

	real*4 branch_rn222(2)			! Branching ratios
	data branch_rn222(1)/0.999/		! Ground state
	data branch_rn222(2)/0.001/		! E=511 keV excited state
	integer*4 nr_branch_rn222/2/

	real*4 e_alpha_rn222(2)			! Alpha kinetic energies [GeV]
	data e_alpha_rn222(1)/5.5903e-3/	! Ground state
	data e_alpha_rn222(2)/5.0793e-3/	! E=511 keV excited state

	real*4 e_gam_rn222(2)			! Gamma energies [GeV]
	data e_gam_rn222(1)/0./			! Ground state
	data e_gam_rn222(2)/5.11e-4/		! E=511 keV excited state

C Branching ratios and energies [GeV] of the 218Po alpha decay.

	real*4 branch_po218(1)			! Branching ratios
	data branch_po218(1)/1./		! Ground state
	integer*4 nr_branch_po218/1/

	real*4 e_alpha_po218(1)			! Alpha kinetic energies [GeV]
	data e_alpha_po218(1)/6.1147e-3/	! Ground state

	real*4 e_gam_po218(1)			! Gamma energies [GeV]
	data e_gam_po218(1)/0./			! Ground state

C Branching ratios and energies [GeV] of the 214Pb beta decay.

	integer*4 nr_branch_pb214
	parameter(nr_branch_pb214=5)
	real*4 branch_pb214(nr_branch_pb214)	! Branching ratios
	data branch_pb214(1)/0.063/		! Ground state.
	data branch_pb214(2)/0.422/		! E=295.2 keV excited state
	data branch_pb214(3)/0.489/		! E=351.9 keV excited state
	data branch_pb214(4)/0.012/		! E=533.7 keV excited state
	data branch_pb214(5)/0.014/		! E=839 keV excited state

	real*4 e_beta_pb214(nr_branch_pb214)	! Beta Q-values [GeV]
	data e_beta_pb214(1)/1.02401e-3/	! Ground state.
	data e_beta_pb214(2)/7.288e-4/		! E=295.2 keV excited state
	data e_beta_pb214(3)/6.721e-4/		! E=351.9 keV excited state
	data e_beta_pb214(4)/4.903e-4/		! E=533.7 keV excited state
        data e_beta_pb214(5)/1.8501e-4/		! E=839 keV excited state
	integer*4 nr_beta_bins_pb214
	parameter(nr_beta_bins_pb214=1024)

	integer nr_branch_gam_pb214
	parameter(nr_branch_gam_pb214=7)
	real*4 e_gam_pb214(nr_branch_pb214,nr_branch_gam_pb214)	! Gamma energies [GeV]
	data e_gam_pb214(1,1)/0./ 		! Ground state.
	data e_gam_pb214(1,2)/0./
	data e_gam_pb214(1,3)/0./
	data e_gam_pb214(1,4)/0./
	data e_gam_pb214(1,5)/0./
	data e_gam_pb214(1,6)/0./
	data e_gam_pb214(1,7)/0./
	data e_gam_pb214(2,1)/2.952e-4/		! E=295.2 keV excited state
	data e_gam_pb214(2,2)/2.42e-4/
	data e_gam_pb214(2,3)/5.32e-5/
	data e_gam_pb214(2,4)/0./
	data e_gam_pb214(2,5)/0./
	data e_gam_pb214(2,6)/0./
	data e_gam_pb214(2,7)/0./
	data e_gam_pb214(3,1)/3.519e-4/ 	! E=351.9 keV excited state
	data e_gam_pb214(3,2)/0./
	data e_gam_pb214(3,3)/0./
	data e_gam_pb214(3,4)/0./
	data e_gam_pb214(3,5)/0./
	data e_gam_pb214(3,6)/0./
	data e_gam_pb214(3,7)/0./
	data e_gam_pb214(4,1)/5.336e-4/ 	! E=533.7 keV excited state
	data e_gam_pb214(4,2)/4.804e-4/
	data e_gam_pb214(4,3)/5.32e-5/
	data e_gam_pb214(4,4)/2.748e-4/
	data e_gam_pb214(4,5)/2.589e-4/
	data e_gam_pb214(4,6)/0./
	data e_gam_pb214(4,7)/0./
	data e_gam_pb214(5,1)/8.39e-4/ 		! E=839 keV excited state
	data e_gam_pb214(5,2)/7.86e-4/
	data e_gam_pb214(5,3)/5.32e-5/
	data e_gam_pb214(5,4)/5.801e-4/
	data e_gam_pb214(5,5)/2.589e-4/
	data e_gam_pb214(5,6)/4.871e-4/
	data e_gam_pb214(5,7)/3.519e-4/

	real*4 branch_gam_pb214(nr_branch_pb214,nr_branch_gam_pb214)		
						! Branching ratio. Sometimes estimated because some multiploarities unknown.
	data branch_gam_pb214(1,1)/1./		! Ground state.
	data branch_gam_pb214(1,2)/0./
	data branch_gam_pb214(1,3)/0./
	data branch_gam_pb214(1,4)/0./
	data branch_gam_pb214(1,5)/0./
	data branch_gam_pb214(1,6)/0./
	data branch_gam_pb214(1,7)/0./
	data branch_gam_pb214(2,1)/0.674/	! E=295.2 keV excited state
	data branch_gam_pb214(2,2)/0.326/
	data branch_gam_pb214(2,3)/0./
	data branch_gam_pb214(2,4)/0./
	data branch_gam_pb214(2,5)/0./
	data branch_gam_pb214(2,6)/0./
	data branch_gam_pb214(2,7)/0./
	data branch_gam_pb214(3,1)/1.0/		! E=351.9 keV excited state
	data branch_gam_pb214(3,2)/0./
	data branch_gam_pb214(3,3)/0./
	data branch_gam_pb214(3,4)/0./
	data branch_gam_pb214(3,5)/0./
	data branch_gam_pb214(3,6)/0./
	data branch_gam_pb214(3,7)/0./
	data branch_gam_pb214(4,1)/0.19/	! E=533.7 keV excited state
	data branch_gam_pb214(4,2)/0.327/
	data branch_gam_pb214(4,3)/0.483/
	data branch_gam_pb214(4,4)/0./
	data branch_gam_pb214(4,5)/0./
	data branch_gam_pb214(4,6)/0./
	data branch_gam_pb214(4,7)/0./
	data branch_gam_pb214(5,1)/0.242/	! E=839 keV excited state
	data branch_gam_pb214(5,2)/0.44/
	data branch_gam_pb214(5,3)/0.145/
	data branch_gam_pb214(5,4)/0.173/
	data branch_gam_pb214(5,5)/0./
	data branch_gam_pb214(5,6)/0./
	data branch_gam_pb214(5,7)/0./

C Branching ratios and energies [GeV] of the 214Bi beta decay.

	integer*4 nr_branch_bi214
	parameter(nr_branch_bi214=17)
	real*4 branch_bi214(nr_branch_bi214)	! Branching ratios
	data branch_bi214(1)/0.191/		! Ground state.
	data branch_bi214(2)/0.018/		! E=609.3 keV excited state
	data branch_bi214(3)/0.078/		! E=1377.7 keV excited state
	data branch_bi214(4)/0.008/		! E=1415.5 keV excited state
	data branch_bi214(5)/0.032/		! E=1543.4 keV excited state
	data branch_bi214(6)/0.006/		! E=1661.3 keV excited state
	data branch_bi214(7)/0.187/		! E=1729.6 keV excited state
	data branch_bi214(8)/0.178/		! E=1764.5 keV excited state
	data branch_bi214(9)/0.086/		! E=1847.4 keV excited state
	data branch_bi214(10)/0.017/		! E=1890.3 keV excited state
	data branch_bi214(11)/0.013/		! E=1994.6 keV excited state
	data branch_bi214(12)/0.015/		! E=2010.8 keV excited state
	data branch_bi214(13)/0.023/		! E=2017.3 keV excited state
	data branch_bi214(14)/0.045/		! E=2118.6 keV excited state
	data branch_bi214(15)/0.06/		! E=2204.1 keV excited state
	data branch_bi214(16)/0.029/		! E=2447.7 keV excited state
	data branch_bi214(17)/0.013/		! E=2482.5 keV excited state

	real*4 e_beta_bi214(nr_branch_bi214)	! Beta Q-values [GeV]
	data e_beta_bi214(1)/3.272e-3/		! Ground state.
	data e_beta_bi214(2)/2.6627e-3/		! E=609.3 keV excited state
	data e_beta_bi214(3)/1.8943e-3/		! E=1377.7 keV excited state
	data e_beta_bi214(4)/1.8565e-3/		! E=1415.5 keV excited state
	data e_beta_bi214(5)/1.7286e-3/		! E=1543.4 keV excited state
	data e_beta_bi214(6)/1.6107e-3/		! E=1661.3 keV excited state
	data e_beta_bi214(7)/1.5424e-3/		! E=1729.6 keV excited state
	data e_beta_bi214(8)/1.5075e-3/		! E=1764.5 keV excited state
	data e_beta_bi214(9)/1.4248e-3/		! E=1847.4 keV excited state
	data e_beta_bi214(10)/1.3817e-3/	! E=1890.3 keV excited state
	data e_beta_bi214(11)/1.2774e-3/	! E=1994.6 keV excited state
	data e_beta_bi214(12)/1.2612e-3/	! E=2010.8 keV excited state
	data e_beta_bi214(13)/1.2547e-3/	! E=2017.3 keV excited state
	data e_beta_bi214(14)/1.1534e-3/	! E=2118.6 keV excited state
	data e_beta_bi214(15)/1.0679e-3/	! E=2204.1 keV excited state
	data e_beta_bi214(16)/8.243e-4/		! E=2447.7 keV excited state
	data e_beta_bi214(17)/7.895e-4/		! E=2482.5 keV excited state
	integer*4 nr_beta_bins_bi214
	parameter(nr_beta_bins_bi214=3272)

C Data for gamma ray energies.

	integer nr_e_gam_bi214
	parameter(nr_e_gam_bi214=13)
	real*4 e_gam_bi214(nr_branch_bi214,nr_e_gam_bi214)	! Gamma energies [GeV]
	data e_gam_bi214(1,1)/0./		! Ground state
	data e_gam_bi214(1,2)/0./
	data e_gam_bi214(1,3)/0./
	data e_gam_bi214(1,4)/0./
	data e_gam_bi214(1,5)/0./
	data e_gam_bi214(1,6)/0./
	data e_gam_bi214(1,7)/0./
	data e_gam_bi214(1,8)/0./
	data e_gam_bi214(1,9)/0./
	data e_gam_bi214(1,10)/0./
	data e_gam_bi214(1,11)/0./
	data e_gam_bi214(1,12)/0./
	data e_gam_bi214(1,13)/0./
	data e_gam_bi214(2,1)/6.093e-4/		! E=609.3 keV state
	data e_gam_bi214(2,2)/0./
	data e_gam_bi214(2,3)/0./
	data e_gam_bi214(2,4)/0./
	data e_gam_bi214(2,5)/0./
	data e_gam_bi214(2,6)/0./
	data e_gam_bi214(2,7)/0./
	data e_gam_bi214(2,8)/0./
	data e_gam_bi214(2,9)/0./
	data e_gam_bi214(2,10)/0./
	data e_gam_bi214(2,11)/0./
	data e_gam_bi214(2,12)/0./
	data e_gam_bi214(2,13)/0./
	data e_gam_bi214(3,1)/1.3777e-3/	! E=1377.7 keV state
	data e_gam_bi214(3,2)/7.684e-4/
	data e_gam_bi214(3,3)/6.093e-4/
	data e_gam_bi214(3,4)/0./
	data e_gam_bi214(3,5)/0./
	data e_gam_bi214(3,6)/0./
	data e_gam_bi214(3,7)/0./
	data e_gam_bi214(3,8)/0./
	data e_gam_bi214(3,9)/0./
	data e_gam_bi214(3,10)/0./
	data e_gam_bi214(3,11)/0./
	data e_gam_bi214(3,12)/0./
	data e_gam_bi214(3,13)/0./
	data e_gam_bi214(4,1)/1.4155e-3/	! E=1415.5 keV state
	data e_gam_bi214(4,2)/8.062e-4/
	data e_gam_bi214(4,3)/6.093e-4/
	data e_gam_bi214(4,4)/0./
	data e_gam_bi214(4,5)/0./
	data e_gam_bi214(4,6)/0./
	data e_gam_bi214(4,7)/0./
	data e_gam_bi214(4,8)/0./
	data e_gam_bi214(4,9)/0./
	data e_gam_bi214(4,10)/0./
	data e_gam_bi214(4,11)/0./
	data e_gam_bi214(4,12)/0./
	data e_gam_bi214(4,13)/0./
	data e_gam_bi214(5,1)/1.5434e-3/	! E=1543.4 keV state
	data e_gam_bi214(5,2)/9.341e-4/
	data e_gam_bi214(5,3)/6.093e-4/
	data e_gam_bi214(5,4)/0./
	data e_gam_bi214(5,5)/0./
	data e_gam_bi214(5,6)/0./
	data e_gam_bi214(5,7)/0./
	data e_gam_bi214(5,8)/0./
	data e_gam_bi214(5,9)/0./
	data e_gam_bi214(5,10)/0./
	data e_gam_bi214(5,11)/0./
	data e_gam_bi214(5,12)/0./
	data e_gam_bi214(5,13)/0./
	data e_gam_bi214(6,1)/1.6613e-3/	! E=1661.3 keV state
	data e_gam_bi214(6,2)/1.052e-3/
	data e_gam_bi214(6,3)/6.093e-4/
	data e_gam_bi214(6,4)/0./
	data e_gam_bi214(6,5)/0./
	data e_gam_bi214(6,6)/0./
	data e_gam_bi214(6,7)/0./
	data e_gam_bi214(6,8)/0./
	data e_gam_bi214(6,9)/0./
	data e_gam_bi214(6,10)/0./
	data e_gam_bi214(6,11)/0./
	data e_gam_bi214(6,12)/0./
	data e_gam_bi214(6,13)/0./
	data e_gam_bi214(7,1)/1.7296e-3/	! E=1729.6 keV state
	data e_gam_bi214(7,2)/1.1203e-3/
	data e_gam_bi214(7,3)/6.093e-4/
	data e_gam_bi214(7,4)/0./
	data e_gam_bi214(7,5)/0./
	data e_gam_bi214(7,6)/0./
	data e_gam_bi214(7,7)/0./
	data e_gam_bi214(7,8)/0./
	data e_gam_bi214(7,9)/0./
	data e_gam_bi214(7,10)/0./
	data e_gam_bi214(7,11)/0./
	data e_gam_bi214(7,12)/0./
	data e_gam_bi214(7,13)/0./
	data e_gam_bi214(8,1)/1.7645e-3/	! E=1764.5 keV state
	data e_gam_bi214(8,2)/1.1552e-3/
	data e_gam_bi214(8,3)/6.093e-4/
	data e_gam_bi214(8,4)/0./
	data e_gam_bi214(8,5)/0./
	data e_gam_bi214(8,6)/0./
	data e_gam_bi214(8,7)/0./
	data e_gam_bi214(8,8)/0./
	data e_gam_bi214(8,9)/0./
	data e_gam_bi214(8,10)/0./
	data e_gam_bi214(8,11)/0./
	data e_gam_bi214(8,12)/0./
	data e_gam_bi214(8,13)/0./
	data e_gam_bi214(9,1)/1.8474e-3/	! E=1847.4 keV state
	data e_gam_bi214(9,2)/1.2381e-3/
	data e_gam_bi214(9,3)/6.093e-4/
	data e_gam_bi214(9,4)/0./
	data e_gam_bi214(9,5)/0./
	data e_gam_bi214(9,6)/0./
	data e_gam_bi214(9,7)/0./
	data e_gam_bi214(9,8)/0./
	data e_gam_bi214(9,9)/0./
	data e_gam_bi214(9,10)/0./
	data e_gam_bi214(9,11)/0./
	data e_gam_bi214(9,12)/0./
	data e_gam_bi214(9,13)/0./
	data e_gam_bi214(10,1)/1.281e-3/	! E=1890.3 keV state
	data e_gam_bi214(10,2)/6.093e-4/
	data e_gam_bi214(10,3)/0./
	data e_gam_bi214(10,4)/0./
	data e_gam_bi214(10,5)/0./
	data e_gam_bi214(10,6)/0./
	data e_gam_bi214(10,7)/0./
	data e_gam_bi214(10,8)/0./
	data e_gam_bi214(10,9)/0./
	data e_gam_bi214(10,10)/0./
	data e_gam_bi214(10,11)/0./
	data e_gam_bi214(10,12)/0./
	data e_gam_bi214(10,13)/0./
	data e_gam_bi214(11,1)/1.3853e-3/	! E=1994.6 keV state
	data e_gam_bi214(11,2)/6.093e-4/
	data e_gam_bi214(11,3)/7.199e-4/
	data e_gam_bi214(11,4)/6.655e-4/
	data e_gam_bi214(11,5)/6.093e-4/
	data e_gam_bi214(11,6)/0./
	data e_gam_bi214(11,7)/0./
	data e_gam_bi214(11,8)/0./
	data e_gam_bi214(11,9)/0./
	data e_gam_bi214(11,10)/0./
	data e_gam_bi214(11,11)/0./
	data e_gam_bi214(11,12)/0./
	data e_gam_bi214(11,13)/0./
	data e_gam_bi214(12,1)/2.0108e-3/	! E=2010.8 keV state
	data e_gam_bi214(12,2)/1.4015e-3/
	data e_gam_bi214(12,3)/6.093e-4/
	data e_gam_bi214(12,4)/0./
	data e_gam_bi214(12,5)/0./
	data e_gam_bi214(12,6)/0./
	data e_gam_bi214(12,7)/0./
	data e_gam_bi214(12,8)/0./
	data e_gam_bi214(12,9)/0./
	data e_gam_bi214(12,10)/0./
	data e_gam_bi214(12,11)/0./
	data e_gam_bi214(12,12)/0./
	data e_gam_bi214(12,13)/0./
	data e_gam_bi214(13,1)/1.408e-3/	! E=2017.3 keV state
	data e_gam_bi214(13,2)/6.093e-4/
	data e_gam_bi214(13,3)/0./
	data e_gam_bi214(13,4)/0./
	data e_gam_bi214(13,5)/0./
	data e_gam_bi214(13,6)/0./
	data e_gam_bi214(13,7)/0./
	data e_gam_bi214(13,8)/0./
	data e_gam_bi214(13,9)/0./
	data e_gam_bi214(13,10)/0./
	data e_gam_bi214(13,11)/0./
	data e_gam_bi214(13,12)/0./
	data e_gam_bi214(13,13)/0./
	data e_gam_bi214(14,1)/2.1186e-3/	! E=2118.6 keV state
	data e_gam_bi214(14,2)/1.5093e-3/
	data e_gam_bi214(14,3)/6.093e-4/
	data e_gam_bi214(14,4)/0./
	data e_gam_bi214(14,5)/0./
	data e_gam_bi214(14,6)/0./
	data e_gam_bi214(14,7)/0./
	data e_gam_bi214(14,8)/0./
	data e_gam_bi214(14,9)/0./
	data e_gam_bi214(14,10)/0./
	data e_gam_bi214(14,11)/0./
	data e_gam_bi214(14,12)/0./
	data e_gam_bi214(14,13)/0./
	data e_gam_bi214(15,1)/2.2041e-3/	! E=2204.1 keV state
	data e_gam_bi214(15,2)/1.5948e-3/
	data e_gam_bi214(15,3)/6.093e-4/
	data e_gam_bi214(15,4)/0./
	data e_gam_bi214(15,5)/0./
	data e_gam_bi214(15,6)/0./
	data e_gam_bi214(15,7)/0./
	data e_gam_bi214(15,8)/0./
	data e_gam_bi214(15,9)/0./
	data e_gam_bi214(15,10)/0./
	data e_gam_bi214(15,11)/0./
	data e_gam_bi214(15,12)/0./
	data e_gam_bi214(15,13)/0./
	data e_gam_bi214(16,1)/2.4477e-3/	! E=2447.7 keV state
	data e_gam_bi214(16,2)/1.8384e-3/
	data e_gam_bi214(16,3)/6.093e-4/
	data e_gam_bi214(16,4)/1.070e-3/
	data e_gam_bi214(16,5)/6.655e-4/
	data e_gam_bi214(16,6)/6.093e-4/
	data e_gam_bi214(16,7)/7.861e-4/
	data e_gam_bi214(16,8)/1.6613e-3/
	data e_gam_bi214(16,9)/0./
	data e_gam_bi214(16,10)/0./
	data e_gam_bi214(16,11)/0./
	data e_gam_bi214(16,12)/0./
	data e_gam_bi214(16,13)/0./
	data e_gam_bi214(17,1)/1.8732e-3/	! E=2482.5 keV state
	data e_gam_bi214(17,2)/6.093e-4/
	data e_gam_bi214(17,3)/1.2077e-3/
	data e_gam_bi214(17,4)/6.655e-4/
	data e_gam_bi214(17,5)/6.093e-4/
	data e_gam_bi214(17,6)/8.212e-4/
	data e_gam_bi214(17,7)/1.6613e-3/
	data e_gam_bi214(17,8)/7.529e-4/
	data e_gam_bi214(17,9)/1.1203e-3/
	data e_gam_bi214(17,10)/6.093e-4/
	data e_gam_bi214(17,11)/2.739e-4/
	data e_gam_bi214(17,12)/1.5993e-3/
	data e_gam_bi214(17,13)/6.093e-4/

C Data for gamma branching ratios.
	
	integer nr_branch_gam_bi214
	parameter(nr_branch_gam_bi214=5)
	real*4 branch_gam_bi214(nr_branch_bi214,nr_branch_gam_bi214)		
	data branch_gam_bi214(1,1)/1./		! Ground state.
	data branch_gam_bi214(1,2)/0./
	data branch_gam_bi214(1,3)/0./
	data branch_gam_bi214(1,4)/0./
	data branch_gam_bi214(1,5)/0./
	data branch_gam_bi214(2,1)/1./		! E=609.3 keV state
	data branch_gam_bi214(2,2)/0./
	data branch_gam_bi214(2,3)/0./
	data branch_gam_bi214(2,4)/0./
	data branch_gam_bi214(2,5)/0./
	data branch_gam_bi214(3,1)/0.433/	! E=1377.7 keV state
	data branch_gam_bi214(3,2)/0.567/
	data branch_gam_bi214(3,3)/0./
	data branch_gam_bi214(3,4)/0./
	data branch_gam_bi214(3,5)/0./
	data branch_gam_bi214(4,1)/0.28/	! E=1415.5 keV state
	data branch_gam_bi214(4,2)/0.72/
	data branch_gam_bi214(4,3)/0./
	data branch_gam_bi214(4,4)/0./
	data branch_gam_bi214(4,5)/0./
	data branch_gam_bi214(5,1)/0.061/	! E=1543.4 keV state
	data branch_gam_bi214(5,2)/0.939/
	data branch_gam_bi214(5,3)/0./
	data branch_gam_bi214(5,4)/0./
	data branch_gam_bi214(5,5)/0./
	data branch_gam_bi214(6,1)/0.785/	! E=1661.3 keV state
	data branch_gam_bi214(6,2)/0.215/
	data branch_gam_bi214(6,3)/0./
	data branch_gam_bi214(6,4)/0./
	data branch_gam_bi214(6,5)/0./
	data branch_gam_bi214(7,1)/0.162/	! E=1729.6 keV state
	data branch_gam_bi214(7,2)/0.838/
	data branch_gam_bi214(7,3)/0./
	data branch_gam_bi214(7,4)/0./
	data branch_gam_bi214(7,5)/0./
	data branch_gam_bi214(8,1)/0.904/	! E=1764.5 keV state
	data branch_gam_bi214(8,2)/0.096/
	data branch_gam_bi214(8,3)/0./
	data branch_gam_bi214(8,4)/0./
	data branch_gam_bi214(8,5)/0./
	data branch_gam_bi214(9,1)/0.267/	! E=1847.4 keV state
	data branch_gam_bi214(9,2)/0.733/
	data branch_gam_bi214(9,3)/0./
	data branch_gam_bi214(9,4)/0./
	data branch_gam_bi214(9,5)/0./
	data branch_gam_bi214(10,1)/1./		! E=1890.3 keV state
	data branch_gam_bi214(10,2)/0./
	data branch_gam_bi214(10,3)/0./
	data branch_gam_bi214(10,4)/0./
	data branch_gam_bi214(10,5)/0./
	data branch_gam_bi214(11,1)/0.663/	! E=1994.6 keV state
	data branch_gam_bi214(11,2)/0.337/
	data branch_gam_bi214(11,3)/0./
	data branch_gam_bi214(11,4)/0./
	data branch_gam_bi214(11,5)/0./
	data branch_gam_bi214(12,1)/0.036/	! E=2010.8 keV state
	data branch_gam_bi214(12,2)/0.964/
	data branch_gam_bi214(12,3)/0./
	data branch_gam_bi214(12,4)/0./
	data branch_gam_bi214(12,5)/0./
	data branch_gam_bi214(13,1)/1./		! E=2017.3 keV state
	data branch_gam_bi214(13,2)/0./
	data branch_gam_bi214(13,3)/0./
	data branch_gam_bi214(13,4)/0./
	data branch_gam_bi214(13,5)/0./
	data branch_gam_bi214(14,1)/0.351/	! E=2118.6 keV state
	data branch_gam_bi214(14,2)/0.649/
	data branch_gam_bi214(14,3)/0./
	data branch_gam_bi214(14,4)/0./
	data branch_gam_bi214(14,5)/0./
	data branch_gam_bi214(15,1)/0.953/	! E=2204.1 keV state
	data branch_gam_bi214(15,2)/0.047/
	data branch_gam_bi214(15,3)/0./
	data branch_gam_bi214(15,4)/0./
	data branch_gam_bi214(15,5)/0./
	data branch_gam_bi214(16,1)/0.624/	! E=2447.7 keV state
	data branch_gam_bi214(16,2)/0.143/
	data branch_gam_bi214(16,3)/0.109/
	data branch_gam_bi214(16,4)/0.124/
	data branch_gam_bi214(16,5)/0./
	data branch_gam_bi214(17,1)/0.198/	! E=2482.7 keV state
	data branch_gam_bi214(17,2)/0.407/
	data branch_gam_bi214(17,3)/0.143/
	data branch_gam_bi214(17,4)/0.117/
	data branch_gam_bi214(17,5)/0.135/

C Branching ratios and energies [GeV] of the 214Po alpha decay.

	real*4 branch_po214(1)			! Branching ratios
	data branch_po214(1)/1./		! Ground state
	integer*4 nr_branch_po214/1/

	real*4 e_alpha_po214(1)			! Alpha kinetic energies [GeV]
	data e_alpha_po214(1)/7.8335e-3/	! Ground state

	real*4 e_gam_po214(1)			! Gamma energies [GeV]
	data e_gam_po214(1)/0./			! Ground state

C Branching ratios and energies [GeV] of the 210Pb beta decay.

	real*4 branch_pb210(2)			! Branching ratios
	data branch_pb210(1)/0.16/		! Ground state.
	data branch_pb210(2)/0.84/		! E=46.5 keV excited state.
	integer nr_branch_pb210
	parameter(nr_branch_pb210=2)

	real*4 e_beta_pb210(2)			! Beta Q-values [GeV]
	data e_beta_pb210(1)/6.35e-5/		! Ground state.
	data e_beta_pb210(2)/1.7e-5/		! E=46.5 keV excited state
	integer*4 nr_beta_bins_pb210
	parameter(nr_beta_bins_pb210=64)

	real*4 e_gam_pb210(1)			! Gamma energies [GeV]
	data e_gam_pb210(1)/4.65e-5/		! E=46.5 keV excited state

C Branching ratios and energies [GeV] of the 210Bi beta decay.

	real*4 branch_bi210(1)			! Branching ratios
	data branch_bi210(1)/1./		! Ground state
	integer*4 nr_branch_bi210/1/

	real*4 e_beta_bi210(1)			! Beta Q-value [GeV]
	data e_beta_bi210(1)/1.16101e-3/	! Ground state
	integer*4 nr_beta_bins_bi210
	parameter(nr_beta_bins_bi210=1161)

C Branching ratios and energies [GeV] of the 210Po alpha decay.

	real*4 branch_po210(1)			! Branching ratios
	data branch_po210(1)/1./		! Ground state
	integer*4 nr_branch_po210/1/

	real*4 e_alpha_po210(1)			! Alpha kinetic energies [GeV]
	data e_alpha_po210(1)/5.4075e-3/	! Ground state

	real*4 e_gam_po210(1)			! Gamma energies [GeV]
	data e_gam_po210(1)/0./			! Ground state

