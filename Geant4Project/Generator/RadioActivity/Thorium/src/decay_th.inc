
C Branching ratios of the 232Th decay series.
        
        integer nr_series_brnch
        parameter(nr_series_brnch=4)
        real*4 branch_th(nr_series_brnch) ! Branching ratio of all members of the Th-decay
                                  ! series.
                                  ! Identifies which decay is to be generated.
        data branch_th(1)/0.25/   ! 1: 232Th alpha decay
        data branch_th(2)/0.25/   ! 2: 228Ra beta decay -> is correlated to 228Ac beta decay
        data branch_th(3)/0.25/   ! 3: 228Th beta decay
        data branch_th(4)/0.25/   ! 4: 224Ra -> 220Rn -> 216Po -> 212Pb -> 212Bi -> 212Po -> 208Pb
                                  !                                        212Bi -> 208Tl -> 208Pb
C Simulate 228Th decays.
C        data branch_th(1)/0.00/  ! 1: 232Th alpha decay
C        data branch_th(2)/0.00/  ! 2: 228Ra beta decay -> is correlated to 228Ac beta decay
C        data branch_th(3)/0.50/  ! 3: 228Th beta decay
C       data branch_th(4)/0.50/   ! 4: 224Ra -> 220Rn -> 216Po -> 212Pb -> 212Bi -> 212Po -> 208Pb
                                  !                                        212Bi -> 208Tl -> 208Pb

C Decay times [s] of the short lived members of the 232Th decay series. 

        real*4 tau(11)          ! Live times [s] of the series members. Only important
                                ! if short enough that correlations might be used.
        data tau(1)/0./         ! 232Th
        data tau(2)/0./         ! 228Ra
        data tau(3)/3.1941e4/   ! 228Ac
        data tau(4)/0./         ! 228Th 
        data tau(5)/0./         ! 224Ra
        data tau(6)/80.21/      ! 220Rn
        data tau(7)/0.2092/     ! 216Po
        data tau(8)/5.526e4/    ! 212Pb
        data tau(9)/5241.3/     ! 212Bi
        data tau(10)/4.3137e-7/ ! 212Po 
        data tau(11)/264.27/    ! 208Tl 

C Branching ratios and energies [GeV] of the 232Th alpha decay.

        integer*4 nr_branch_th232
        parameter(nr_branch_th232=2)
        real*4 branch_th232(nr_branch_th232)    ! Branching ratios
        data branch_th232(1)/0.782/             ! Ground state
        data branch_th232(2)/0.218/             ! E=63.8 keV excited state

        real*4 e_alpha_th232(nr_branch_th232)   ! Alpha kinetic energies [GeV]
        data e_alpha_th232(1)/4.0828e-3/        ! Ground state
        data e_alpha_th232(2)/4.019e-3/         ! E=63.8 keV excited state

        real*4 e_gam_th232(nr_branch_th232)     ! Gamma energies [GeV]
        data e_gam_th232(1)/0./                 ! Ground state
        data e_gam_th232(2)/6.38e-5/            ! E=63.8 keV excited state

C Branching ratios and energies [GeV] of the 228Ra beta decay.

        integer*4 nr_branch_ra228
        parameter(nr_branch_ra228=3)
        real*4 branch_ra228(nr_branch_ra228)    ! Branching ratios
        data branch_ra228(1)/0.50/              ! E=6.7 keV excited state
        data branch_ra228(2)/0.268/             ! E=20.2 keV excited state
        data branch_ra228(3)/0.029/             ! E=33.1 keV excited state

        real*4 e_beta_ra228(nr_branch_ra228)    ! Beta Q-values [GeV]
        data e_beta_ra228(1)/3.92e-5/           ! E=6.7 keV excited state
        data e_beta_ra228(2)/2.57e-5/           ! E=20.2 keV excited state
        data e_beta_ra228(3)/1.28e-5/           ! E=33.1 keV excited state
        integer*4 nr_beta_bins_ra228
        parameter(nr_beta_bins_ra228=46)

        real*4 e_gam_ra228(nr_branch_ra228,2)   ! Gamma energies [GeV]
        data e_gam_ra228(1,1)/6.7e-6/           ! E=6.7 keV excited state
        data e_gam_ra228(1,2)/0./
        data e_gam_ra228(2,1)/1.35e-5/          ! E=20.2 keV excited state
        data e_gam_ra228(2,2)/6.7e-6/
        data e_gam_ra228(3,1)/2.64e-5/          ! E=33.1 keV excited state
        data e_gam_ra228(3,2)/6.7e-6/

C Branching ratios and energies [GeV] of the 228Ac beta decay.

        integer*4 nr_branch_ac228
        parameter(nr_branch_ac228=13)
        real*4 branch_ac228(nr_branch_ac228)    ! Branching ratios
        data branch_ac228(1)/0.093/             ! E=57.8 keV excited state
        data branch_ac228(2)/0.137/             ! E=396.1 keV excited state
        data branch_ac228(3)/0.349/             ! E=969.0 keV excited state
        data branch_ac228(4)/0.036/             ! E=1022.5 keV excited state
        data branch_ac228(5)/0.069/             ! E=1123.0 keV excited state
        data branch_ac228(6)/0.060/             ! E=1153.5 keV excited state
        data branch_ac228(7)/0.036/             ! E=1168.4 keV excited state
        data branch_ac228(8)/0.093/             ! E=1531.5 keV excited state
        data branch_ac228(9)/0.014/             ! E=1638.3 keV excited state
        data branch_ac228(10)/0.049/            ! E=1646.0 keV excited state
        data branch_ac228(11)/0.013/            ! E=1682.8 keV excited state
        data branch_ac228(12)/0.029/            ! E=1688.4 keV excited state
        data branch_ac228(13)/0.022/            ! E=1724.3 keV excited state

        real*4 e_beta_ac228(nr_branch_ac228)    ! Beta Q-values [GeV]
        data e_beta_ac228(1)/2.0694e-3/         ! E=57.8 keV excited state
        data e_beta_ac228(2)/1.7309e-3/         ! E=396.1 keV excited state
        data e_beta_ac228(3)/1.1581e-3/         ! E=969.0 keV excited state
        data e_beta_ac228(4)/1.1045e-3/         ! E=1022.5 keV excited state
        data e_beta_ac228(5)/1.0040e-3/         ! E=1123.0 keV excited state
        data e_beta_ac228(6)/9.735e-4/          ! E=1153.5 keV excited state
        data e_beta_ac228(7)/9.586e-4/          ! E=1168.4 keV excited state
        data e_beta_ac228(8)/5.955e-4/          ! E=1531.5 keV excited state
        data e_beta_ac228(9)/4.887e-4/          ! E=1638.3 keV excited state
        data e_beta_ac228(10)/4.800e-4/         ! E=1646.0 keV excited state
        data e_beta_ac228(11)/4.442e-4/         ! E=1682.8 keV excited state
        data e_beta_ac228(12)/4.386e-4/         ! E=1688.4 keV excited state
        data e_beta_ac228(13)/4.027e-4/         ! E=1724.3 keV excited state
        integer*4 nr_beta_bins_ac228
        parameter(nr_beta_bins_ac228=2070)

        integer*4 nr_branch_gam_ac228
        parameter(nr_branch_gam_ac228=28)
        real*4 e_gam_ac228(nr_branch_ac228,nr_branch_gam_ac228) ! Gamma energies [GeV]
        data e_gam_ac228(1,1)/5.78e-5/          ! E=57.8 keV excited state
        data e_gam_ac228(2,1)/3.383e-4/         ! E=396.1 keV excited state
        data e_gam_ac228(2,2)/5.78e-5/
        data e_gam_ac228(2,3)/2.093e-4/
        data e_gam_ac228(2,4)/1.291e-4/
        data e_gam_ac228(2,5)/5.78e-5/
        data e_gam_ac228(3,1)/9.690e-4/         ! E=969.0 keV excited state
        data e_gam_ac228(3,2)/9.112e-4/
        data e_gam_ac228(3,3)/5.78e-5/
        data e_gam_ac228(4,1)/9.648e-4/         ! E=1022.5 keV excited state
        data e_gam_ac228(4,2)/5.78e-5/
        data e_gam_ac228(4,3)/8.357e-4/
        data e_gam_ac228(4,4)/1.291e-4/
        data e_gam_ac228(4,5)/5.78e-5/
        data e_gam_ac228(5,1)/1.0652e-3/        ! E=1123.0 keV excited state
        data e_gam_ac228(5,2)/3.280e-4/ 
        data e_gam_ac228(5,3)/1.0652e-3/ 
        data e_gam_ac228(5,4)/2.702e-4/ 
        data e_gam_ac228(5,5)/5.78e-5/ 
        data e_gam_ac228(5,6)/7.950e-4/ 
        data e_gam_ac228(5,7)/3.383e-4/ 
        data e_gam_ac228(5,8)/5.78e-5/ 
        data e_gam_ac228(5,9)/7.950e-4/ 
        data e_gam_ac228(5,10)/2.093e-4/ 
        data e_gam_ac228(5,11)/1.291e-4/ 
        data e_gam_ac228(5,12)/5.78e-5/ 
        data e_gam_ac228(5,13)/1.540e-4/ 
        data e_gam_ac228(5,14)/9.690e-4/ 
        data e_gam_ac228(5,15)/1.540e-4/ 
        data e_gam_ac228(5,16)/9.112e-4/ 
        data e_gam_ac228(5,17)/5.78e-5/ 
        data e_gam_ac228(6,1)/1.1535e-3/        ! E=1153.5 keV excited state
        data e_gam_ac228(6,2)/1.0957e-3/
        data e_gam_ac228(6,3)/5.78e-5/
        data e_gam_ac228(6,4)/3.216e-4/
        data e_gam_ac228(6,5)/8.310e-4/
        data e_gam_ac228(6,6)/2.787e-4/
        data e_gam_ac228(6,7)/6.881e-4/
        data e_gam_ac228(6,8)/1.291e-4/
        data e_gam_ac228(6,9)/5.78e-5/
        data e_gam_ac228(6,10)/2.787e-4/
        data e_gam_ac228(6,11)/5.465e-4/
        data e_gam_ac228(6,12)/3.280e-4/
        data e_gam_ac228(6,13)/2.787e-4/
        data e_gam_ac228(6,14)/5.465e-4/
        data e_gam_ac228(6,15)/2.702e-4/
        data e_gam_ac228(6,16)/5.78e-5/
        data e_gam_ac228(6,17)/2.787e-4/
        data e_gam_ac228(6,18)/4.784e-4/
        data e_gam_ac228(6,19)/3.383e-4/
        data e_gam_ac228(6,20)/5.78e-5/
        data e_gam_ac228(6,21)/2.787e-4/
        data e_gam_ac228(6,22)/4.784e-4/
        data e_gam_ac228(6,23)/2.093e-4/
        data e_gam_ac228(6,24)/1.291e-4/
        data e_gam_ac228(6,25)/5.78e-5/
        data e_gam_ac228(7,1)/1.1106e-3/        ! E=1168.4 keV excited state
        data e_gam_ac228(7,2)/5.78e-5/
        data e_gam_ac228(7,3)/8.404e-4/
        data e_gam_ac228(7,4)/3.280e-4/
        data e_gam_ac228(7,5)/8.404e-4/
        data e_gam_ac228(7,6)/2.702e-4/
        data e_gam_ac228(7,7)/5.78e-5/
        data e_gam_ac228(7,8)/7.723e-4/
        data e_gam_ac228(7,9)/3.383e-4/
        data e_gam_ac228(7,10)/5.78e-5/
        data e_gam_ac228(7,11)/7.723e-4/
        data e_gam_ac228(7,12)/2.093e-4/
        data e_gam_ac228(7,13)/1.291e-4/
        data e_gam_ac228(7,14)/5.78e-5/
        data e_gam_ac228(7,15)/1.994e-4/
        data e_gam_ac228(7,16)/9.690e-4/
        data e_gam_ac228(7,17)/1.994e-4/
        data e_gam_ac228(7,18)/9.112e-4/
        data e_gam_ac228(7,19)/5.78e-5/
        data e_gam_ac228(8,1)/5.625e-4/         ! E=1531.5 keV excited state
        data e_gam_ac228(8,2)/9.690e-4/
        data e_gam_ac228(8,3)/5.625e-4/
        data e_gam_ac228(8,4)/9.112e-4/
        data e_gam_ac228(8,5)/5.78e-5/
        data e_gam_ac228(8,6)/5.090e-4/
        data e_gam_ac228(8,7)/9.648e-4/
        data e_gam_ac228(8,8)/5.78e-5/
        data e_gam_ac228(8,9)/5.090e-4/
        data e_gam_ac228(8,10)/8.357e-4/
        data e_gam_ac228(8,11)/1.291e-4/
        data e_gam_ac228(8,12)/5.78e-5/
        data e_gam_ac228(8,13)/9.95e-5/
        data e_gam_ac228(8,14)/4.630e-4/
        data e_gam_ac228(8,15)/9.690e-4/
        data e_gam_ac228(8,16)/9.95e-5/
        data e_gam_ac228(8,17)/4.630e-4/
        data e_gam_ac228(8,18)/9.112e-4/
        data e_gam_ac228(8,19)/5.78e-5/
        data e_gam_ac228(8,20)/9.95e-5/
        data e_gam_ac228(8,21)/4.095e-4/
        data e_gam_ac228(8,22)/9.648e-4/
        data e_gam_ac228(8,23)/5.78e-5/
        data e_gam_ac228(8,24)/9.95e-5/
        data e_gam_ac228(8,25)/4.095e-4/
        data e_gam_ac228(8,26)/8.357e-4/
        data e_gam_ac228(8,27)/1.291e-4/
        data e_gam_ac228(8,28)/5.78e-5/
        data e_gam_ac228(9,1)/1.6383e-3/        ! E=1638.3 keV excited state
        data e_gam_ac228(9,2)/1.5805e-3/
        data e_gam_ac228(9,3)/5.78e-5/
        data e_gam_ac228(10,1)/1.5882e-3/       ! E=1646.0 keV excited state
        data e_gam_ac228(10,2)/5.78e-5/
        data e_gam_ac228(10,3)/1.4591e-3/
        data e_gam_ac228(10,4)/1.291e-4/
        data e_gam_ac228(10,5)/5.78e-5/
        data e_gam_ac228(11,1)/1.6251e-3/       ! E=1682.8 keV excited state
        data e_gam_ac228(11,2)/5.78e-5/
        data e_gam_ac228(11,3)/1.4959e-3/
        data e_gam_ac228(11,4)/1.291e-4/
        data e_gam_ac228(11,5)/5.78e-5/
        data e_gam_ac228(12,1)/1.6306e-3/       ! E=1688.4 keV excited state
        data e_gam_ac228(12,2)/5.78e-5/
        data e_gam_ac228(12,3)/1.5016e-3/
        data e_gam_ac228(12,4)/1.291e-4/
        data e_gam_ac228(12,5)/5.78e-5/
        data e_gam_ac228(13,1)/1.6665e-3/       ! E=1724.3 keV excited state
        data e_gam_ac228(13,2)/5.78e-5/
        data e_gam_ac228(13,3)/7.553e-4/
        data e_gam_ac228(13,4)/9.690e-4/
        data e_gam_ac228(13,5)/7.553e-4/
        data e_gam_ac228(13,6)/9.112e-4/
        data e_gam_ac228(13,7)/5.78e-5/
        data e_gam_ac228(13,8)/7.017e-4/
        data e_gam_ac228(13,9)/9.648e-4/
        data e_gam_ac228(13,10)/5.78e-5/
        data e_gam_ac228(13,11)/7.017e-4/
        data e_gam_ac228(13,12)/8.357e-4/
        data e_gam_ac228(13,13)/1.291e-4/
        data e_gam_ac228(13,14)/5.78e-5/

        integer*4 nr_branch_gam_ac228_level
        parameter(nr_branch_gam_ac228_level=6)  ! Numbers to which sub-level this gamma
                                                ! branching ratio belongs.
        integer*4 nr_branch_gam1_ac228
        parameter(nr_branch_gam1_ac228=4)       ! Maximal number of gamma transitions at
                                                ! a given sub-level.
        real*4 branch_gam_ac228(nr_branch_ac228,
     -    nr_branch_gam_ac228_level,nr_branch_gam1_ac228)         
                                                ! Branching ratios
        data branch_gam_ac228(1,1,1)/1.0/       ! E=57.8 keV excited state
        data branch_gam_ac228(2,1,1)/0.743/     ! E=396.1 keV excited state
        data branch_gam_ac228(2,1,2)/0.257/
        data branch_gam_ac228(3,1,1)/0.376/     ! E=969.0 keV excited state
        data branch_gam_ac228(3,1,2)/0.624/
        data branch_gam_ac228(4,1,1)/0.755/     ! E=1022.5 keV excited state
        data branch_gam_ac228(4,1,2)/0.245/
        data branch_gam_ac228(5,1,1)/0.745/     ! E=1123.0 keV excited state
        data branch_gam_ac228(5,1,2)/0.109/
        data branch_gam_ac228(5,1,3)/0.146/
        data branch_gam_ac228(5,2,1)/0.460/
        data branch_gam_ac228(5,2,2)/0.540/
        data branch_gam_ac228(5,3,1)/0.733/
        data branch_gam_ac228(5,3,2)/0.267/
        data branch_gam_ac228(5,4,1)/0.376/
        data branch_gam_ac228(5,4,2)/0.624/
        data branch_gam_ac228(6,1,1)/0.167/     ! E=1153.5 keV excited state
        data branch_gam_ac228(6,1,2)/0.155/
        data branch_gam_ac228(6,1,3)/0.272/
        data branch_gam_ac228(6,1,4)/0.406/
        data branch_gam_ac228(6,2,1)/0.140/
        data branch_gam_ac228(6,2,2)/0.421/
        data branch_gam_ac228(6,2,3)/0.439/
        data branch_gam_ac228(6,3,1)/0.460/
        data branch_gam_ac228(6,3,2)/0.540/
        data branch_gam_ac228(6,4,1)/0.733/
        data branch_gam_ac228(6,4,2)/0.267/
        data branch_gam_ac228(7,1,1)/0.093/     ! E=1168.4 keV excited state
        data branch_gam_ac228(7,1,2)/0.301/
        data branch_gam_ac228(7,1,3)/0.493/
        data branch_gam_ac228(7,1,4)/0.113/
        data branch_gam_ac228(7,2,1)/0.460/
        data branch_gam_ac228(7,2,2)/0.540/
        data branch_gam_ac228(7,3,1)/0.733/
        data branch_gam_ac228(7,3,2)/0.267/
        data branch_gam_ac228(7,4,1)/0.376/
        data branch_gam_ac228(7,4,2)/0.624/
        data branch_gam_ac228(8,1,1)/0.119/     ! E=1531.5 keV excited state
        data branch_gam_ac228(8,1,2)/0.062/
        data branch_gam_ac228(8,1,3)/0.819/
        data branch_gam_ac228(8,2,1)/0.376/
        data branch_gam_ac228(8,2,2)/0.624/
        data branch_gam_ac228(8,3,1)/0.755/
        data branch_gam_ac228(8,3,2)/0.245/
        data branch_gam_ac228(8,4,1)/0.651/
        data branch_gam_ac228(8,4,2)/0.349/
        data branch_gam_ac228(8,5,1)/0.376/
        data branch_gam_ac228(8,5,2)/0.624/
        data branch_gam_ac228(8,6,1)/0.755/
        data branch_gam_ac228(8,6,2)/0.245/
        data branch_gam_ac228(9,1,1)/0.439/     ! E=1638.3 keV excited state
        data branch_gam_ac228(9,1,2)/0.561/
        data branch_gam_ac228(10,1,1)/0.795/    ! E=1646.0 keV excited state
        data branch_gam_ac228(10,1,2)/0.205/
        data branch_gam_ac228(11,1,1)/0.229/    ! E=1682.8 keV excited state
        data branch_gam_ac228(11,1,2)/0.771/
        data branch_gam_ac228(12,1,1)/0.766/    ! E=1688.4 keV excited state
        data branch_gam_ac228(12,1,2)/0.234/
        data branch_gam_ac228(13,1,1)/0.132/    ! E=1724.3 keV excited state
        data branch_gam_ac228(13,1,2)/0.740/
        data branch_gam_ac228(13,1,3)/0.128/
        data branch_gam_ac228(13,2,1)/0.376/
        data branch_gam_ac228(13,2,2)/0.624/
        data branch_gam_ac228(13,3,1)/0.755/
        data branch_gam_ac228(13,3,2)/0.245/

        real*4 branch_gam_conv_ac228(4)         ! Gamma emission probabilities for the 129.1 & 154.0 & 278.7 & 99.5 keV transitions.
        data branch_gam_conv_ac228(1)/0.211/    ! E=129.1 keV transition from 186.8 keV nuclear state.
        data branch_gam_conv_ac228(2)/0.851/    ! E=154.0 keV transition from 1123.0 keV nuclear state.
        data branch_gam_conv_ac228(3)/0.476/    ! E=278.7 keV transition from 1153.5 keV nuclear state.
        data branch_gam_conv_ac228(4)/0.204/    ! E=99.5 keV transition from 1531.5 keV nuclear state.  
        real*4 x_ray_k_ac228/9.51e-5/           ! Average x-ray energy emitted after K-capture in Th.
        real*4 x_ray_l_ac228/1.50e-5/           ! Average x-ray energy emitted after L-capture in Th.

C Branching ratios and energies [GeV] of the 228Th alpha decay.

        integer*4 nr_branch_th228
        parameter(nr_branch_th228=2)
        real*4 branch_th228(nr_branch_th228)    ! Branching ratios
        data branch_th228(1)/0.722/             ! Ground state
        data branch_th228(2)/0.278/             ! E=84.4 keV excited state

        real*4 e_alpha_th228(nr_branch_th228)   ! Alpha kinetic energies [GeV]
        data e_alpha_th228(1)/5.5201e-3/        ! Ground state
        data e_alpha_th228(2)/5.4357e-3/        ! E=84.4 keV excited state

        real*4 e_gam_th228(nr_branch_th228)     ! Gamma energies [GeV]
        data e_gam_th228(1)/0./                 ! Ground state
        data e_gam_th228(2)/8.44e-5/            ! E=84.4 keV excited state

C Branching ratios and energies [GeV] of the 224Ra alpha decay.

        integer*4 nr_branch_ra224
        parameter(nr_branch_ra224=2)
        real*4 branch_ra224(nr_branch_ra224)    ! Branching ratios
        data branch_ra224(1)/0.949/             ! Ground state
        data branch_ra224(2)/0.051/             ! E=241.0 keV excited state

        real*4 e_alpha_ra224(nr_branch_ra224)   ! Alpha kinetic energies [GeV]
        data e_alpha_ra224(1)/5.7889e-3/        ! Ground state
        data e_alpha_ra224(2)/5.5479e-3/        ! E=241.0 keV excited state

        real*4 e_gam_ra224(nr_branch_ra224)     ! Gamma energies [GeV]
        data e_gam_ra224(1)/0./                 ! Ground state
        data e_gam_ra224(2)/2.41e-4/            ! E=241.0 keV excited state

C Branching ratios and energies [GeV] of the 220Rn alpha decay.

        integer*4 nr_branch_rn220
        parameter(nr_branch_rn220=1)
        real*4 branch_rn220(nr_branch_rn220)    ! Branching ratios
        data branch_rn220(1)/1./                ! Ground state

        real*4 e_alpha_rn220(nr_branch_rn220)   ! Alpha kinetic energies [GeV]
        data e_alpha_rn220(1)/6.4047e-3/        ! Ground state

C Branching ratios and energies [GeV] of the 216Po alpha decay.

        integer*4 nr_branch_po216
        parameter(nr_branch_po216=1)
        real*4 branch_po216(nr_branch_po216)    ! Branching ratios
        data branch_po216(1)/1./                ! Ground state

        real*4 e_alpha_po216(nr_branch_po216)   ! Alpha kinetic energies [GeV]
        data e_alpha_po216(1)/6.9065e-3/        ! Ground state

C Branching ratios and energies [GeV] of the 212Pb beta decay.

        integer*4 nr_branch_pb212
        parameter(nr_branch_pb212=3)
        real*4 branch_pb212(nr_branch_pb212)    ! Branching ratios
        data branch_pb212(1)/0.123/             ! Ground state.
        data branch_pb212(2)/0.825/             ! E=238.6 keV excited state
        data branch_pb212(3)/0.052/             ! E=415.3 keV excited state

        real*4 e_beta_pb212(nr_branch_pb212)    ! Beta Q-values [GeV]
        data e_beta_pb212(1)/5.738e-4/          ! Ground state.
        data e_beta_pb212(2)/3.352e-4/          ! E=238.6 keV excited state
        data e_beta_pb212(3)/1.585e-4/          ! E=415.3 keV excited state
        integer*4 nr_beta_bins_pb212
        parameter(nr_beta_bins_pb212=574)

        integer nr_branch_gam_pb212
        parameter(nr_branch_gam_pb212=3)
        real*4 e_gam_pb212(nr_branch_pb212,nr_branch_gam_pb212) ! Gamma energies [GeV]
        data e_gam_pb212(1,1)/0./               ! Ground state.
        data e_gam_pb212(1,2)/0./
        data e_gam_pb212(1,3)/0./
        data e_gam_pb212(2,1)/2.386e-4/         ! E=238.6 keV excited state
        data e_gam_pb212(2,2)/0./
        data e_gam_pb212(2,3)/0./
        data e_gam_pb212(3,1)/4.153e-4/         ! E=415.3 keV excited state
        data e_gam_pb212(3,2)/3.001e-4/
        data e_gam_pb212(3,3)/1.152e-4/         ! Fully converted (c=7.0)

        real*4 branch_gam_pb212(nr_branch_pb212,nr_branch_gam_pb212)            
                                                ! Branching ratio. Sometimes estimated because some multiploarities unknown.
        data branch_gam_pb212(1,1)/1./          ! Ground state.
        data branch_gam_pb212(1,2)/0./
        data branch_gam_pb212(1,3)/0./
        data branch_gam_pb212(2,1)/1.0/         ! E=238.6 keV excited state
        data branch_gam_pb212(2,2)/0./  
        data branch_gam_pb212(2,3)/0./
        data branch_gam_pb212(3,1)/0.03/        ! E=415.3 keV excited state
        data branch_gam_pb212(3,2)/0.97/
        data branch_gam_pb212(3,3)/0./

        real*4 branch_gam_conv_pb212(2)         ! Gamma emission probabilities for the 277.4 & 510.8 & 252.6 keV transitions.
        data branch_gam_conv_pb212(1)/0.526/    ! E=238.6 keV transition from 238.6 keV nuclear state.
        data branch_gam_conv_pb212(2)/0.680/    ! E=300.1 keV transition from 415.3 keV nuclear state.
        real*4 x_ray_pb212/7.87e-5/             ! Average x-ray energy emitted after k-capture in Pb.

C Beta-alpha branching ratio of 212Bi

        real*4 branch_bi212_b_a(2)
        data branch_bi212_b_a(1)/0.641/         ! Beta branching ratio.
        data branch_bi212_b_a(2)/0.359/         ! Alpha branching ratio.

C Branching ratios and energies [GeV] of the 212Bi beta decay.

        integer*4 nr_branch_bi212_b
        parameter(nr_branch_bi212_b=5)
        real*4 branch_bi212_b(nr_branch_bi212_b)! Branching ratios. have been normalized to 1.
        data branch_bi212_b(1)/0.866/           ! Ground state.
        data branch_bi212_b(2)/0.069/           ! E=727.3 keV excited state
        data branch_bi212_b(3)/0.022/           ! E=1512.7 keV excited state
        data branch_bi212_b(4)/0.030/           ! E=1620.7 keV excited state
        data branch_bi212_b(5)/0.013/           ! E=1806.0 keV excited state

        real*4 e_beta_bi212_b(nr_branch_bi212_b)! Beta Q-values [GeV]
        data e_beta_bi212_b(1)/2.2539e-3/       ! Ground state.
        data e_beta_bi212_b(2)/1.5267e-3/       ! E=727.3 keV excited state
        data e_beta_bi212_b(3)/7.413e-4/        ! E=1512.7 keV excited state
        data e_beta_bi212_b(4)/6.333e-4/        ! E=1620.7 keV excited state
        data e_beta_bi212_b(5)/4.480e-4/        ! E=1806.0 keV excited state
        integer*4 nr_beta_bins_bi212_b
        parameter(nr_beta_bins_bi212_b=2253)

        integer nr_branch_gam_bi212_b
        parameter(nr_branch_gam_bi212_b=3)
        real*4 e_gam_bi212_b(nr_branch_bi212_b,nr_branch_gam_bi212_b)   ! Gamma energies [GeV]
        data e_gam_bi212_b(1,1)/0./             ! Ground state.
        data e_gam_bi212_b(1,2)/0./
        data e_gam_bi212_b(1,3)/0./
        data e_gam_bi212_b(2,1)/7.273e-4/       ! E=727.3 keV excited state
        data e_gam_bi212_b(2,2)/0./
        data e_gam_bi212_b(2,3)/0./
        data e_gam_bi212_b(3,1)/1.5127e-3/      ! E=1512.7 keV excited state
        data e_gam_bi212_b(3,2)/7.854e-4/
        data e_gam_bi212_b(3,3)/7.273e-4/
        data e_gam_bi212_b(4,1)/1.6207e-3/      ! E=1620.7 keV excited state
        data e_gam_bi212_b(4,2)/8.934e-4/
        data e_gam_bi212_b(4,3)/7.273e-4/
        data e_gam_bi212_b(5,1)/1.8059e-3/      ! E=1806.0 keV excited state
        data e_gam_bi212_b(5,2)/1.0786e-3/
        data e_gam_bi212_b(5,3)/7.273e-4/

        real*4 branch_gam_bi212_b(nr_branch_bi212_b,
     -    nr_branch_gam_bi212_b)              
                                                ! Branching ratio. Sometimes estimated because some multiploarities unknown.
        data branch_gam_bi212_b(1,1)/1./        ! Ground state.
        data branch_gam_bi212_b(1,2)/0./
        data branch_gam_bi212_b(1,3)/0./
        data branch_gam_bi212_b(2,1)/1./        ! E=727.3 keV excited state
        data branch_gam_bi212_b(2,2)/0./        
        data branch_gam_bi212_b(2,3)/0./
        data branch_gam_bi212_b(3,1)/0.20/      ! E=1512.7 keV excited state
        data branch_gam_bi212_b(3,2)/0.80/
        data branch_gam_bi212_b(3,3)/0./
        data branch_gam_bi212_b(4,1)/0.793/     ! E=1620.7 keV excited state 
        data branch_gam_bi212_b(4,2)/0.207/
        data branch_gam_bi212_b(4,3)/0./
        data branch_gam_bi212_b(5,1)/0.158/     ! E=1806.0 keV excited state
        data branch_gam_bi212_b(5,2)/0.842/
        data branch_gam_bi212_b(5,3)/0./

C Branching ratios and energies [GeV] of the 212Po alpha decay.

        real*4 branch_po212(1)                  ! Branching ratios
        data branch_po212(1)/1./                ! Ground state
        integer*4 nr_branch_po212/1/

        real*4 e_alpha_po212(1)                 ! Alpha kinetic energies [GeV]
        data e_alpha_po212(1)/8.9541e-3/        ! Ground state

        real*4 e_gam_po212(1)                   ! Gamma energies [GeV]
        data e_gam_po212(1)/0./                 ! Ground state

C Branching ratios and energies [GeV] of the 212Bi alpha decay.

        integer*4 nr_branch_bi212_a
        parameter(nr_branch_bi212_a=2)
        real*4 branch_bi212_a(nr_branch_bi212_a)! Branching ratios
        data branch_bi212_a(1)/0.280/           ! Ground state
        data branch_bi212_a(2)/0.720/           ! E=39.9 keV excited state

        real*4 e_alpha_bi212_a(nr_branch_bi212_a)! Alpha kinetic energies [GeV]
        data e_alpha_bi212_a(1)/6.2071e-3/      ! Ground state
        data e_alpha_bi212_a(2)/6.1672e-3/      ! E=39.9 keV excited state

        real*4 e_gam_bi212_a(nr_branch_bi212_a) ! Gamma energies [GeV]
        data e_gam_bi212_a(1)/0./               ! Ground state
        data e_gam_bi212_a(2)/3.99e-5/          ! E=39.9 keV excited state

C Branching ratios and energies [GeV] of the 208Tl beta decay.

        integer*4 nr_branch_tl208
        parameter(nr_branch_tl208=4)
        real*4 branch_tl208(nr_branch_tl208)! Branching ratios. have been normalized to 1.
        data branch_tl208(1)/0.496/             ! E=3197.8 keV excited state
        data branch_tl208(2)/0.222/             ! E=3475.1 keV excited state
        data branch_tl208(3)/0.250/             ! E=3708.4 keV excited state
        data branch_tl208(4)/0.032/             ! E=3961.0 keV excited state

        real*4 e_beta_tl208(nr_branch_tl208)! Beta Q-values [GeV]
        data e_beta_tl208(1)/1.8032e-3/ ! E=3197.8 keV excited state
        data e_beta_tl208(2)/1.5258e-3/ ! E=3475.1 keV excited state
        data e_beta_tl208(3)/1.2924e-3/ ! E=3708.4 keV excited state
        data e_beta_tl208(4)/1.0398e-3/ ! E=3961.0 keV excited state
        integer*4 nr_beta_bins_tl208
        parameter(nr_beta_bins_tl208=1803)

        integer nr_branch_gam_tl208
        parameter(nr_branch_gam_tl208=7)
        real*4 e_gam_tl208(nr_branch_tl208,nr_branch_gam_tl208) ! Gamma energies [GeV]
        data e_gam_tl208(1,1)/5.832e-4/         ! E=3197.8 keV excited state
        data e_gam_tl208(1,2)/2.6146e-3/
        data e_gam_tl208(1,3)/0./
        data e_gam_tl208(1,4)/0./
        data e_gam_tl208(1,5)/0./
        data e_gam_tl208(1,6)/0./
        data e_gam_tl208(1,7)/0./
        data e_gam_tl208(2,1)/8.606e-4/         ! E=3475.1 keV excited state
        data e_gam_tl208(2,2)/2.6146e-3/
        data e_gam_tl208(2,3)/2.774e-4/
        data e_gam_tl208(2,4)/5.832e-4/
        data e_gam_tl208(2,5)/2.6146e-3/
        data e_gam_tl208(2,6)/0./
        data e_gam_tl208(2,7)/0./
        data e_gam_tl208(3,1)/5.108e-4/         ! E=3708.4 keV excited state
        data e_gam_tl208(3,2)/5.832e-4/
        data e_gam_tl208(3,3)/2.6146e-3/
        data e_gam_tl208(3,4)/0./
        data e_gam_tl208(3,5)/0./
        data e_gam_tl208(3,6)/0./
        data e_gam_tl208(3,7)/0./
        data e_gam_tl208(4,1)/7.634e-4/         ! E=3961.0 keV excited state
        data e_gam_tl208(4,2)/5.832e-4/
        data e_gam_tl208(4,3)/2.6146e-3/
        data e_gam_tl208(4,4)/2.525e-4/
        data e_gam_tl208(4,5)/5.108e-4/
        data e_gam_tl208(4,6)/5.832e-4/
        data e_gam_tl208(4,7)/2.6146e-3/

        real*4 branch_gam_tl208(nr_branch_tl208,nr_branch_gam_tl208)            
                                                ! Branching ratio. Sometimes estimated because some multiploarities unknown.
        data branch_gam_tl208(1,1)/1./          ! E=3197.8 keV excited state
        data branch_gam_tl208(1,2)/0./
        data branch_gam_tl208(1,3)/0./
        data branch_gam_tl208(1,4)/0./
        data branch_gam_tl208(1,5)/0./
        data branch_gam_tl208(1,6)/0./
        data branch_gam_tl208(1,7)/0./
        data branch_gam_tl208(2,1)/0.568/       ! E=3475.1 keV excited state
        data branch_gam_tl208(2,2)/0.432/       
        data branch_gam_tl208(2,3)/0./
        data branch_gam_tl208(2,4)/0./
        data branch_gam_tl208(2,5)/0./
        data branch_gam_tl208(2,6)/0./
        data branch_gam_tl208(2,7)/0./
        data branch_gam_tl208(3,1)/1.0/         ! E=3708.4 keV excited state
        data branch_gam_tl208(3,2)/0./
        data branch_gam_tl208(3,3)/0./
        data branch_gam_tl208(3,4)/0./
        data branch_gam_tl208(3,5)/0./
        data branch_gam_tl208(3,6)/0./
        data branch_gam_tl208(3,7)/0./
        data branch_gam_tl208(4,1)/0.616/       ! E=3961.0 keV excited state
        data branch_gam_tl208(4,2)/0.384/
        data branch_gam_tl208(4,3)/0./
        data branch_gam_tl208(4,4)/0./
        data branch_gam_tl208(4,5)/0./
        data branch_gam_tl208(4,6)/0./
        data branch_gam_tl208(4,7)/0./

        real*4 branch_gam_conv_tl208(3)         ! Gamma emission probabilities for the 277.4 & 510.8 & 252.6 keV transitions.
        data branch_gam_conv_tl208(1)/0.649/    ! E=277.4 keV transition from 3475.1 keV nuclear state.
        data branch_gam_conv_tl208(2)/0.909/    ! E=510.8 keV transition from 3708.4 keV nuclear state.
        data branch_gam_conv_tl208(3)/0.588/    ! E=252.6 keV transition from 3961.0 keV nuclear state.
        real*4 x_ray_tl208/7.66e-5/             ! Average x-ray energy emitted after k-capture in Pb.
