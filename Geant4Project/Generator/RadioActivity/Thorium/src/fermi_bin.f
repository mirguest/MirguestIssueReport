
        subroutine fermi_bin(Qbeta,np,mass,nforb)

C***************************************************************C
C       Berechnet die Wahrscheinlichkeit (d.h. auf 1 normiert)  C
C       das bei einem gegebenen Isotop und Q-Wert ein Elektron  C
C       im Energieintervall dE emittiert wird.                  C
C                                                               C
C       23.01.92 m.h.
C       07.02.00 BT  Modified to tranfer dist by memory        C
C**************************************************************C
        IMPLICIT REAL*8 (a-h,o-z)

        INCLUDE 'fermi_bin.inc'
C
C0.0    === Variablen ===
C
        INTEGER np                      ! Z
        INTEGER mass                    ! A
        INTEGER iemit                   ! -1 = Beta- Zerfall
                                        ! +1 = Beta+/EC Zerfall
        INTEGER nf_flamk
        INTEGER nforb                   ! = 0 erlaubte Uebergange
        REAL*4 Qbeta                    ! Q-Wert
        REAL*8 DE                       ! BIN_INTERVALL [keV]
        DIMENSION PEM(10000)            ! Normierte Wahrscheinlichkeit
        DIMENSION xr2(10000)            ! Ooops!
        CHARACTER*80 ergfil             ! Name des Ergebnisfiles

C
C0.1    === Voreinstellungen ===
C
        EMASS=0.51100D+00               ! Elektronenmasse in MeV
        x_norm=0.0
C
C1.0    === Einlesen ===
C
        iemit=-1        
        nf_flamk=nforb+1                ! siehe oben,aber in FLAMK-Notation
        De=1.                           ! Fixed to 1 keV.

C
C1.1    === Beta+? Dann QBeta = QEC - 2 Emass ===
C
        IF(iemit .EQ. 1) THEN
          Qbeta=Qbeta-2.0D+00*EMASS
        ENDIF

C
C1.2    === Umrechnen der Binbreite ===
C
        nanz=INT(1.0D+03*Qbeta/De)      ! Fuehrt auf Anzahl, schneidet
                                        ! aber wenn nicht-ganzzahlig
                                        ! die oberste Energie ab
c=for the common block, we have to have a limit
        if ( nanz.gt.NfCommon) then
            print *,"FERMI BIN ERROR: Number of bins requested is "
            print *,"         TOO BIG!, Bins=",nanz
            print *,"  Rearranging bins to =10000"
            Qbeta=NfCommon*De/1.0D+03        
            nanz=INT(1.0D+03*Qbeta/De)  ! new limit--bt
        endif

c
c   clear common
c
           do i=1,nfcommon
             ProbFERMI(i)=0.0D+00
             probfermi_s(i)=0.
             EFERMI(i)=0.0D+00
           enddo
          
C
C1.3    === Umrechnen auf Emass UND MEV===
C
        W0=Qbeta/Emass+1.0D+00
        WDE=De*1.0D-03
C
C2.0    === Berechnen der Fermifunktion ===
C
        DO i=1,nanz                     ! Achtung:
                                        ! das hier angewandte Verfahren
                                        ! liefert (wenn man das Ergebnis
                                        ! nachtraeglich integriert
                                        ! nicht exakt dasselbe wie die
                                        ! SUBROUTINE FBDAUF 
                                        ! da das numerische Verfahren
                                        ! zu ungenau ist!

          WW=WDe*DFLOAT(i)/EMASS+1.0D+00
          PP=DSQRT(WW*WW-1.0D+00)
          WM=(WW-W0)**2
          flm=FLAMK(np,mass,iemit,NF_FLAMK,ww)
          PEM(i)=WW*PP*WM*flm

c   added by bt to eliminate fermi correction and
c      screw up the distribution like yifang did in 
c      the us proposal
c         WW=WDe*DFLOAT(i)/EMASS
c         PP=DSQRT(WW*WW)
c         WM=(WW-W0)**2
c         flm=1
c         PEM(i)=WW*PP*WM*flm

          xr2(i)=sqrt(pem(i)/WW/PP/flm)
        ENDDO
C
C2.1    === Normiere ===
C
        y_n=0.0
        DO i=1,nanz
          y_n=y_n+xr2(i)
          x_norm=x_norm+PEM(i)
        ENDDO
        DO i=1,nanz
          PEM(i)=PEM(i)/x_norm
        ENDDO
C
C3.0    === Ergebnis schreiben ===
C
        yy=0.0
        DO i=1,nanz
          xx=dE*DFLOAT(i)               ! Achtung keV 
          EFERMI(i)=xx
          ProbFERMI(i)=PEM(i)
          probfermi_s(i)=sngl(pem(i))
        ENDDO
        fpoint_nr=nanz

310     FORMAT(1X,1PE12.5,1X,1PE12.5)
C
C9.0    === Schluss ===
C
900     return
        end subroutine


        REAL*8 FUNCTION
     2    FBDAUF(IZPAR,MASS,IEMIT,NFORB,EBETA)
C
C     THIS FUNCTION CALCULATES F-VALUE OF BETA DECAY
C     FOR ALLOWED AND UNIQUE FORBIDDEN TRANSITIONS
C
C     IZPAR = ATOMIC NUMBER OF PARENT NUCLEUS
C     MASS  = MASS NUMBER OF PARENT (DAUGHTER) NUCLEUS
C             WHEN MASS=0, A PROBABLE MASS NUMBER IS
C             CALCULATED FROM IZPAR.
C     IEMIT = -1 : ELECTRON EMISSION
C     IEMIT = +1 : POSITRON EMISSION
C     NFORB = 0   : ALLOWED TRANSITION
C     NFORB = N>0 : N-TH UNIQUE FORBIDDEN TRANSITION
C     EBETA = MAXIMUM KINETIC ENERGY OF BETA-PARTICLE
C             IN MEV
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/CFBD/ DF(30),GR(200),GW(200),NPOINT
      REAL*8  GGR(21)
     1/9.983215885747715D0,9.911671096990163D0,9.783386735610834D0,
     2 9.599068917303463D0,9.359769874978539D0,9.066859447581012D0,
     3 8.722015116924414D0,8.327212004013613D0,7.884711450474093D0,
     4 7.397048030699261D0,6.867015020349513D0,6.297648390721963D0,
     5 5.692209416102159D0,5.054165991994061D0,4.387172770514071D0,
     6 3.695050226404815D0,2.981762773418249D0,2.251396056334228D0,
     7 1.508133548639922D0,0.756232589891630D0,0.000000000000000D0/
      REAL*8  GGW(21)
     1/0.430614035816489D0,0.999993877390594D0,1.564493840781859D0,
     2 2.120106336877955D0,2.663589920711044D0,3.191821173169928D0,
     3 3.701771670350799D0,4.190519519590969D0,4.655264836901434D0,
     4 5.093345429461749D0,5.502251924257874D0,5.879642094987194D0,
     5 6.223354258096632D0,6.531419645352741D0,6.802073676087675D0,
     6 7.033766062081749D0,7.225169686102309D0,7.375188202722346D0,
     7 7.482962317622155D0,7.547874709271582D0,7.569553564729839D0/
      DATA  EMASS/0.511006D0/,IFBD/0/
C
C0 =====  POINTS AND WEIGHTS OF THE 41-POINT  =====
C  =====     GAUSS-LEGENDRE QUADURATURE       =====
C
      IF(IFBD.EQ.0)  THEN
         IFBD=1
         NPOINT=41
         DO 10  K=1,21
         I=NPOINT-K+1
         GR(K)=-GGR(K)*0.1D0
         GW(K)=+GGW(K)*0.01D0
         GR(I)=+GGR(K)*0.1D0
         GW(I)=+GGW(K)*0.01D0
   10    CONTINUE
         DF(1)=1.0D0
         DO 20  K=2,20
   20    DF(K)=DF(K-1)*DFLOAT(K+K-1)
      END IF
C
C1 ========  CHECKING THE SPECIFICATIONS  ========
C
      IF(ABS(IEMIT).NE.1.OR.
     2   IZPAR-IEMIT.LE.0.OR.
     3   NFORB.LT.0.OR.
     4   EBETA.LE.0.0D0)  GO TO 900
C
C2 ==========  NUMERICAL INTEGRATION  ==========
C
      WMIN=1.0D0
      WMAX=EBETA/EMASS+1.0D0
      W0=WMAX
      NDIV=5
      WINC=(WMAX-WMIN)/DFLOAT(NDIV)
      SSS=0.0D0
      DO 300  KDIV=1,NDIV
      WL=WMIN+DFLOAT(KDIV-1)*WINC
      WU=WL+WINC
      C=(WU-WL)*0.5D0
      D=(WU+WL)*0.5D0
      SS=0.0D0
      DO 200  N=1,NPOINT
      WW=D+C*GR(N)
      PP=SQRT(WW*WW-1.0D0)
      S=0.0D0
      DO 100  K=1,NFORB+1
      S=S+PP**(K-1)*(W0-WW)**(2*(NFORB-K+1))
     2   /DF(K)/DF(NFORB-K+2)
     3   *FLAMK(IZPAR,MASS,IEMIT,K,WW)
  100 CONTINUE
      SS=SS+GW(N)*S*PP*WW*(WW-W0)**2
  200 CONTINUE
      SS=SS*C*DF(NFORB+1)
      SSS=SSS+SS
  300 CONTINUE
C
      FBDAUF=SSS
      RETURN
C
  900 WRITE(6,600)  IZPAR,MASS,IEMIT,NFORB,EBETA
  600 FORMAT(1H ,10X,'FUNCTION "FBDAUF"',
     2      /1H ,20X,'SPECIFIED PARAMETER IS NOT CORRECT',
     3      /1H ,25X,'IZPAR =',I4,
     4      /1H ,25X,'MASS  =',I4,
     5      /1H ,25X,'IEMIT =',I4,
     6      /1H ,25X,'NFORB =',I4,
     7      /1H ,25X,'EBETA =',F10.5)
      FBDAUF=0.0D0
      RETURN
      END FUNCTION

      REAL*8 FUNCTION  FLAMK(NZPAR,NMASS,IEMIT,KK,WW)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/CFLAMK/ PI,ALPHA,Z,AZ,R,V0,VA,VB,FKK,
     2               G,GG,GD,HGFR(80),HGFI(80),DF(30)
      DATA  NZPARX,NMASSX,IEMITX,KKX/4*-1000/
C
C1 ==========  ENERGY INDEPENDENT FACTORS  ==========
C
      IF(NZPAR.EQ.NZPARX.AND.
     2   NMASS.EQ.NMASSX.AND.
     3   IEMIT.EQ.IEMITX.AND.
     4      KK.EQ.   KKX)  GO TO 100
C
      NZPARX=NZPAR
      NMASSX=NMASS
      IEMITX=IEMIT
      KKX   =KK 
C
C1.1 ----------  UNIVERSAL CONSTANTS  ---------- 
C
      PI=3.14159265358979D0
      ALPHA=1.0D0/137.036D0
C
C1.2 -----  NUCLEAR CHARGE, MASS AND RADIUS  -----
C
      Z=DFLOAT(NZPAR-IEMIT)
      AZ=ALPHA*Z
      IF(NMASS.GT.0)  THEN
         FMASS=DFLOAT(NMASS)
      ELSE
         IF(IEMIT.LT.0)  THEN
            FMASS=1.82D0+1.90D0*Z+0.01271D0*Z*Z
     2           -0.00006D0*Z*Z*Z
         ELSE
            FMASS=-1.9D0+1.96D0*Z+0.0079D0*Z*Z
     2           -0.00002D0*Z*Z*Z
         END IF
      END IF
      A3=FMASS**(1.0D0/3.0D0)
      R=0.002908D0*A3-0.002437D0/A3
C
C1.3 ----------  SCREENING POTENTIAL  ----------
C
      V0=1.3086665D0*ALPHA**2*Z**1.379061D0
      VA=-0.102D0+0.238D-2*Z+0.101D-4*Z*Z
     2   -0.111D-6*Z*Z*Z
      VB=0.0156D0-0.360D-4*Z-0.383D-5*Z*Z
     2   +0.242D-7*Z*Z*Z
C    
C1.4 -----             GAMMA    AND                -----
C    -----     COEFFICIENTS OF THE EXPANSION OF    -----
C    -----  THE CONFLUENT HYPERGEOMETRIC FUNCTION  -----
C
      FKK=DFLOAT(KK)
      G=SQRT(FKK*FKK-AZ*AZ)
      GG=G+G+1.0D0
      GD=GA2(GG,0.0D0)
C
      DO 10  N=1,70
      FN=DFLOAT(N)
      S=2.0D0/FN/(G+G+FN)
      HGFR(N)=-S
      HGFI(N)=+S*(G+FN)
   10 CONTINUE
C
C1.5 ----------  DOUBLE FACTORIALS  ----------
C
      DF(1)=1.0D0
      DO 20  K=2,20
   20 DF(K)=DF(K-1)*DFLOAT(K+K-1)
C
C
C2 ==========  ENERGY SHIFT BY THE SCREENING  ==========
C
  100 PP=SQRT(WW*WW-1.0D0)
      IF(IEMIT.LT.0)  THEN
         VSHIFT=V0
      ELSE
         VSEXP=VA/PP+VB/PP/PP
         IF(VSEXP.LT.50.0D0)  THEN
            VSHIFT=V0/EXP(VSEXP)
         ELSE
            VSHIFT=0.0D0
         END IF
      END IF
C
C3 =====  FERMI FUNCTION FOR A SMALL MOMENTUM  =====
C
      IF(WW.GT.1.0D0+VSHIFT)  GO TO 200
C
      FLAMK=4.0D0*PI/PP
     2     *AZ*((2.0D0*AZ*R)**(G+G-2.0D0))/GD
     3     *(FKK*(G+FKK)*(1.0D0-4.0D0*AZ*R/GG)
     3       -2.0D0*AZ*R*(G+FKK)/GG)
      IF(IEMIT.EQ.+1)  THEN
         FEXP=4.0D0*PI*AZ/PP
         IF(FEXP.LT.100.0D0)  THEN
            FLAMK=FLAMK/EXP(FEXP)
         ELSE
            FLAMK=0.0D0
         END IF
      END IF
      GO TO 300
C
C4 =====  FERMI FUNCTION WITH THE SCREENING  =====
C
  200 W=WW+DFLOAT(IEMIT)*VSHIFT
      P=SQRT(W*W-1.0D0)
      PR=P*R
      TPR=PR+PR
      Y=-DFLOAT(IEMIT)*AZ*W/P
C
      IF(ABS(Y).LE.100.0D0)  THEN
         F0=TPR**(GG-2.0D0)
     2     *EXP(PI*Y)/(R*W)*GA2(G,Y)/GD
      ELSE
        IF(Y.GE.0.0D0)  THEN
           F0=2.0D0*PI*ABS(TPR*Y)**(GG-2.0D0)/(R*W)
        ELSE
           F0=0.0D0
        END IF
      END IF
      F1R=+COS(PR)
      F1I=-SIN(PR)
      F2R=F1R*G-F1I*Y
      F2I=F1R*Y+F1I*G
C
      FRR=1.0D0
      FII=0.0D0
      FR=1.0D0
      FI=0.0D0
      FX=PR*Y
      FY=PR
      DO 210  K=1,70
      GR=HGFR(K)*FX
      GI=HGFI(K)*FY
      SS=FR*GR-FI*GI
      FI=FR*GI+FI*GR
      FR=SS
      IF(ABS(FR).LT.ABS(FRR)*1.0D-16.AND.
     2   ABS(FI).LT.ABS(FII)*1.0D-16)  GO TO 220
      FRR=FRR+FR
      FII=FII+FI
  210 CONTINUE
C
      WRITE(6,6999)
        PRINT *,NZPAR,NMASS,IEMIT,KK,WW
 6999 FORMAT(1H ,'FUNCTION "FLAMK"',5X,
     2           'NO CONVERGENCE')
C
  220 FR=FRR*F2R-FII*F2I
      FI=FRR*F2I+FII*F2R
      D=G*G+Y*Y
      DO 230  IFG=1,3,2
      FK=DFLOAT(2-IFG)
      ER=(-FK*FKK*G+Y*Y/W)/D
      EI=(+FK*FKK*Y+G*Y/W)/D
      ER=-FK*SQRT((1.0D0+ER)*0.5D0)
      IF(EI.GE.0.0D0)  THEN
         EI=-FK*SQRT(1.0D0-ER*ER)
      ELSE
         EI=+FK*SQRT(1.0D0-ER*ER)
      END IF
      IF(IFG.EQ.1)  THEN
         FLF=F0*(W-1.0D0)*(ER*FI+EI*FR)**2
      ELSE
         FLG=F0*(W+1.0D0)*(ER*FR-EI*FI)**2
      END IF
  230 CONTINUE
      FLAMK=W/(PP*WW)*(FLF+FLG)
C
  300 IF(KK.EQ.1)  GO TO 400
      FLAMK=FLAMK*DF(KK)**2/(PP*R)**(KK+KK-2)
      GO TO 900
C
C5 ========  NUCLEAR FINITE SIZE CORRECTION  ========
C
  400 DL=0.0D0
      IF(IEMIT.LT.0.AND.Z.GT.50.0D0)
     2   DL=(Z-50.0D0)
     3     *(-25.0D-4-4.0D-6*WW*(Z-50.0D0))
      IF(IEMIT.GE.0.AND.Z.GT.80.0D0)
     2   DL=(Z-80.0D0)
     3     *(-17.0D-5*WW+6.3D-4/WW-8.8D-3/(WW*WW))
      FLAMK=FLAMK*(1.0D0+DL)
C
  900 RETURN
      END
      REAL*8 FUNCTION  GA2(X,Y)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/CGA2/  P2,SA(7)
      DIMENSION  SX(7),SY(7)
      REAL*8  SND(2,7)
     1        /+1.0D0, 12.0D0,
     2         +1.0D0, 288.0D0,
     3         -139.0D0, 51840D0,
     4         -571.0D0, 2488320D0,
     5         +163879D0, 209018880D0,
     6         +5246819D0, 75246796800D0,
     7         -534703531D0, 902961561600D0/
      DATA  IGA2/0/
C
      IF(IGA2.EQ.0)  THEN
         IGA2=1
         P2=2.0D0*3.14159265358979D0
         DO 1  K=1,7
    1    SA(K)=SND(1,K)/SND(2,K)
      END IF
C
      GA2=1.0D0
      FX=X
      FYY=Y*Y
      DO 100  K=1,1000
      SS=FX*FX+FYY
      IF(SS.GT.1600.0D0)  GO TO 200
      GA2=GA2/SS
      FX=FX+1.0D0
  100 CONTINUE
  200 FY=Y
      SX(1)=FX
      SY(1)=FY
      DO 300  K=2,7
      KK=K-1
      SX(K)=SX(KK)*FX-SY(KK)*FY
  300 SY(K)=SX(KK)*FY+SY(KK)*FX
      FR=1.0D0
      FI=0.0D0
      DO 400  KK=1,7
      K=8-KK
      S=SX(K)*SX(K)+SY(K)*SY(K)
      FR=FR+SA(K)*SX(K)/S
  400 FI=FI-SA(K)*SY(K)/S
C
      GA2=GA2
     2   *P2
     3   *EXP(-FX-FX
     3        +(FX-0.5D0)*LOG(FX*FX+FY*FY)
     3        -2.0D0*FY*ATAN(FY/FX))
     4   *(FR*FR+FI*FI)
C
      RETURN
      END
      REAL*8 FUNCTION  FECA (NZPAR,EEC)
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*4  P1,P2,P3,P4,P5,P6,P7,
     2        E1,E2,E3,E4,E5,E6,E7
      COMMON/CFECA/ PI05,EMASS,P(8,105),E(4,105)
      DIMENSION  P1(8,15),P2(8,15),P3(8,15),P4(8,15),
     2           P5(8,15),P6(8,15),P7(8,15),
     3           E1(4,15),E2(4,15),E3(4,15),E4(4,15),
     4           E5(4,15),E6(4,15),E7(4,15)
      DATA  P1/
     1   1.,0.000,0.000,0.000,0.000000,0.0000,0.00000,0.000,
     2   2.,0.000,0.000,0.000,0.000000,0.0000,0.00000,0.000,
     3   3.,0.000,0.000,0.000,0.000000,0.0000,0.00000,0.000,
     4   4.,0.000,0.000,0.000,0.000000,0.0000,0.00000,0.000,
     5   5.,0.000,0.000,0.000,0.000177,0.0405,0.00008,0.000,
     6   6.,0.938,0.000,0.000,0.000311,0.0493,0.00018,0.000,
     7   7.,0.948,1.475,0.000,0.000501,0.0541,0.00024,0.000,
     8   8.,0.958,1.405,0.000,0.000757,0.0564,0.00032,0.000,
     9   9.,0.964,1.360,0.000,0.001091,0.0577,0.00041,0.000,
     *  10.,0.969,1.309,0.000,0.00151, 0.0584,0.00053,0.000,
     1  11.,0.973,1.283,0.000,0.00204, 0.0627,0.00069,0.018,
     2  12.,0.974,1.248,0.000,0.00268, 0.0666,0.00088,0.037,
     3  13.,0.975,1.212,0.000,0.00344, 0.0699,0.00108,0.048,
     4  14.,0.976,1.186,0.921,0.00435, 0.0729,0.00131,0.063,
     5  15.,0.977,1.169,0.929,0.00541, 0.0756,0.00155,0.079/
      DATA  P2/
     1  16.,0.978,1.154,0.935,0.00664,0.0781,0.00181,0.093,
     2  17.,0.979,1.143,0.940,0.00807,0.0804,0.00209,0.103,
     3  18.,0.980,1.132,0.944,0.00970,0.0824,0.00240,0.110,
     4  19.,0.981,1.120,0.946,0.01156,0.0844,0.00272,0.128,
     5  20.,0.982,1.113,0.948,0.01367,0.0862,0.00306,0.144,
     6  21.,0.982,1.101,0.947,0.01600,0.0879,0.00343,0.148,
     7  22.,0.982,1.096,0.950,0.0187, 0.0896,0.00382,0.150,
     8  23.,0.983,1.091,0.953,0.0217, 0.0910,0.00424,0.152,
     9  24.,0.984,1.088,0.956,0.0250, 0.0924,0.00467,0.147,
     *  25.,0.985,1.085,0.958,0.0287, 0.0938,0.00512,0.154,
     1  26.,0.985,1.080,0.960,0.0328, 0.0950,0.00560,0.155,
     2  27.,0.986,1.078,0.962,0.0373, 0.0962,0.00610,0.156,
     3  28.,0.986,1.076,0.964,0.0423, 0.0974,0.00663,0.156,
     4  29.,0.986,1.072,0.965,0.0477, 0.0985,0.00717,0.152,
     5  30.,0.987,1.070,0.967,0.0538, 0.0995,0.00774,0.158/
      DATA  P3/
     1  31.,0.987,1.069,0.968,0.0604,0.1006,0.00834,0.162,
     2  32.,0.988,1.067,0.969,0.0676,0.1015,0.00895,0.166,
     3  33.,0.988,1.064,0.970,0.0755,0.1026,0.00958,0.172,
     4  34.,0.988,1.062,0.971,0.0841,0.1035,0.0102, 0.177,
     5  35.,0.989,1.060,0.971,0.0935,0.1043,0.0109, 0.182,
     6  36.,0.989,1.059,0.972,0.1037,0.1053,0.0116, 0.187,
     7  37.,0.989,1.057,0.973,0.1149,0.1063,0.0124, 0.193,
     8  38.,0.990,1.053,0.973,0.1269,0.1071,0.0131, 0.199,
     9  39.,0.990,1.051,0.974,0.1402,0.1080,0.0139, 0.206,
     *  40.,0.990,1.050,0.974,0.154, 0.1089,0.0147, 0.210,
     1  41.,0.990,1.048,0.975,0.170, 0.1098,0.0156, 0.213,
     2  42.,0.990,1.046,0.975,0.186, 0.1107,0.0164, 0.216,
     3  43.,0.990,1.045,0.976,0.205, 0.1115,0.0173, 0.219,
     4  44.,0.990,1.043,0.976,0.224, 0.1124,0.0183, 0.222,
     5  45.,0.991,1.042,0.976,0.245, 0.1133,0.0192, 0.225/
      DATA  P4/
     1  46.,0.991,1.041,0.977,0.268,0.1142,0.0202,0.228,
     2  47.,0.991,1.040,0.977,0.293,0.1150,0.0212,0.233,
     3  48.,0.991,1.039,0.977,0.319,0.1159,0.0222,0.238,
     4  49.,0.991,1.038,0.978,0.348,0.1168,0.0233,0.241,
     5  50.,0.991,1.037,0.978,0.379,0.1178,0.0244,0.246,
     6  51.,0.991,1.036,0.978,0.413,0.1187,0.0255,0.249,
     7  52.,0.991,1.035,0.979,0.449,0.1196,0.0267,0.253,
     8  53.,0.991,1.034,0.979,0.488,0.1205,0.0278,0.257,
     9  54.,0.991,1.033,0.979,0.529,0.1215,0.0291,0.261,
     *  55.,0.992,1.032,0.979,0.574,0.1224,0.0303,0.266,
     1  56.,0.992,1.032,0.980,0.623,0.1234,0.0316,0.271,
     2  57.,0.992,1.031,0.980,0.675,0.1244,0.0329,0.274,
     3  58.,0.992,1.030,0.980,0.732,0.1254,0.0343,0.277,
     4  59.,0.992,1.030,0.980,0.793,0.1264,0.0357,0.279,
     5  60.,0.992,1.029,0.980,0.857,0.1275,0.0371,0.281/
      DATA  P5/
     1  61.,0.992,1.028,0.980,0.927,0.1285,0.0386,0.284,
     2  62.,0.992,1.028,0.980,1.002,0.1296,0.0401,0.286,
     3  63.,0.992,1.028,0.980,1.084,0.1306,0.0417,0.288, 
     4  64.,0.992,1.027,0.980,1.171,0.1317,0.0433,0.290, 
     5  65.,0.992,1.027,0.981,1.266,0.1328,0.0449,0.292, 
     6  66.,0.992,1.027,0.981,1.367,0.1340,0.0466,0.294,
     7  67.,0.992,1.026,0.981,1.474,0.1351,0.0483,0.296,
     8  68.,0.992,1.026,0.981,1.59, 0.1362,0.0501,0.298,
     9  69.,0.992,1.026,0.981,1.72, 0.1374,0.0519,0.300,
     *  70.,0.992,1.025,0.981,1.85, 0.1386,0.0538,0.303,
     1  71.,0.992,1.025,0.981,2.00, 0.1398,0.0557,0.305,
     2  72.,0.992,1.024,0.981,2.15, 0.1410,0.0577,0.308,
     3  73.,0.992,1.024,0.981,2.32, 0.1423,0.0597,0.310,
     4  74.,0.992,1.024,0.982,2.50, 0.1436,0.0618,0.313,
     5  75.,0.992,1.024,0.982,2.69, 0.1448,0.0639,0.315/
      DATA  P6/
     1  76.,0.992,1.024,0.982,2.90,0.1462,0.0661,0.318,
     2  77.,0.992,1.023,0.982,3.13,0.1475,0.0684,0.320,
     3  78.,0.992,1.023,0.982,3.37,0.1489,0.0707,0.323,
     4  79.,0.992,1.022,0.982,3.62,0.1502,0.0730,0.326,
     5  80.,0.992,1.022,0.982,3.90,0.1517,0.0755,0.329,
     6  81.,0.992,1.022,0.982,4.21,0.1531,0.0780,0.331,
     7  82.,0.992,1.022,0.982,4.53,0.1546,0.0806,0.334,
     8  83.,0.992,1.022,0.982,4.88,0.1561,0.0833,0.337,
     9  84.,0.992,1.022,0.982,5.25,0.1576,0.0860,0.341,
     *  85.,0.992,1.021,0.982,5.66,0.1591,0.0888,0.344,
     1  86.,0.992,1.021,0.982,6.09,0.1607,0.0917,0.347,
     2  87.,0.992,1.021,0.982,6.55,0.1623,0.0947,0.350,
     3  88.,0.992,1.021,0.982,7.06,0.1639,0.0978,0.353,
     4  89.,0.992,1.021,0.982,7.61,0.1656,0.1010,0.356,
     5  90.,0.992,1.021,0.982,8.19,0.1673,0.1042,0.359/
      DATA  P7/
     1  91.,0.992,1.021,0.982, 8.83,0.1690,0.1076,0.361,
     2  92.,0.992,1.021,0.982, 9.51,0.1708,0.1111,0.364,
     3  93.,0.992,1.021,0.982,10.25,0.1726,0.1147,0.367,
     4  94.,0.992,1.021,0.982,11.05,0.1744,0.1184,0.370,
     5  95.,0.992,1.021,0.982,11.92,0.1763,0.1222,0.374,
     6  96.,0.992,1.021,0.982,12.86,0.1782,0.1262,0.377,
     7  97.,0.992,1.021,0.982,13.88,0.1802,0.1303,0.380,
     8  98.,0.992,1.021,0.982,14.98,0.1829,0.1345,0.384,
     9  56*0.0/
      DATA  E1/  1.,  0.0136,  1.0E30,  1.0E30,
     2           2.,  0.0246,  1.0E30,  1.0E30,
     3           3.,  0.0548,  0.0053,  1.0E30,
     4           4.,  0.1121,  0.0080,  1.0E30,
     5           5.,  0.1880,  0.0126,  0.0047,
     6           6.,  0.2838,  0.0180,  0.0064,
     7           7.,  0.4016,  0.0244,  0.0092,
     8           8.,  0.5320,  0.0285,  0.0071,
     9           9.,  0.6854,  0.0340,  0.0086,
     *          10.,  0.8701,  0.0485,  0.0217,
     1          11.,  1.0721,  0.0633,  0.0311,
     2          12.,  1.3050,  0.0894,  0.0514,
     3          13.,  1.5596,  0.1177,  0.0732,
     4          14.,  1.8389,  0.1487,  0.0995,
     5          15.,  2.1455,  0.1893,  0.1362/
      DATA  E2/ 16.,  2.4720,  0.2292,  0.1654,
     2          17.,  2.8224,  0.2702,  0.2016,
     3          18.,  3.2060,  0.3263,  0.2507,
     4          19.,  3.6074,  0.3771,  0.2963,
     5          20.,  4.0381,  0.4378,  0.3500,
     6          21.,  4.4928,  0.5004,  0.4067,
     7          22.,  4.9664,  0.5637,  0.4615,
     8          23.,  5.4651,  0.6282,  0.5205,
     9          24.,  5.9892,  0.6946,  0.5837,
     *          25.,  6.5390,  0.7690,  0.6514,
     1          26.,  7.1120,  0.8461,  0.7211,
     2          27.,  7.7089,  0.9256,  0.7936,
     3          28.,  8.3328,  1.0081,  0.8719,
     4          29.,  8.9789,  1.0961,  0.9510,
     5          30.,  9.6586,  1.1936,  1.0428/
      DATA  E3/ 31., 10.3671,  1.2977,  1.1423,
     2          32., 11.1031,  1.4143,  1.2478,
     3          33., 11.8667,  1.5265,  1.3586,
     4          34., 12.6578,  1.6539,  1.4762,
     5          35., 13.4737,  1.7820,  1.5960,
     6          36., 14.3256,  1.9210,  1.7272,
     7          37., 15.1997,  2.0651,  1.8639,
     8          38., 16.1046,  2.2163,  2.0068,
     9          39., 17.0384,  2.3725,  2.1555,
     *          40., 17.9976,  2.5316,  2.3067,
     1          41., 18.9856,  2.6977,  2.4647,
     2          42., 19.9995,  2.8655,  2.6251,
     3          43., 21.0440,  3.0425,  2.7932,
     4          44., 22.1172,  3.2240,  2.9669,
     5          45., 23.2199,  3.4119,  3.1461/
      DATA  E4/ 46., 24.3503,  3.6043,  3.3303,
     2          47., 25.5140,  3.8058,  3.5237,
     3          48., 26.7112,  4.0180,  3.7270,
     4          49., 27.9399,  4.2375,  3.9380,
     5          50., 29.2001,  4.4647,  4.1561,
     6          51., 30.4912,  4.6983,  4.3804,
     7          52., 31.8138,  4.9392,  4.6120,
     8          53., 33.1694,  5.1881,  4.8521,
     9          54., 34.5644,  5.4528,  5.1037,
     *          55., 35.9846,  5.7143,  5.3594,
     1          56., 37.4406,  5.9888,  5.6236,
     2          57., 38.9246,  6.2663,  5.8906,
     3          58., 40.4430,  6.5488,  6.1642,
     4          59., 41.9906,  6.8348,  6.4404,
     5          60., 43.5689,  7.1260,  6.7215/
      DATA  E5/ 61., 45.1840,  7.4279,  7.0128,
     2          62., 46.8342,  7.7368,  7.3118,
     3          63., 48.5190,  8.0520,  7.6171,
     4          64., 50.2391,  8.3756,  7.9303,
     5          65., 51.9957,  8.7080,  8.2516,
     6          66., 53.7885,  9.0458,  8.5806,
     7          67., 55.6177,  9.3942,  8.9178,
     8          68., 57.4855,  9.7513,  9.2643,
     9          69., 59.3896, 10.1157,  9.6169,
     *          70., 61.3323, 10.4864,  9.9782,
     1          71., 63.3138, 10.8704, 10.3486,
     2          72., 65.3508, 11.2707, 10.7394,
     3          73., 67.4164, 11.6815, 11.1361,
     4          74., 69.5250, 12.0998, 11.5440,
     5          75., 71.6764, 12.5267, 11.9587/
      DATA  E6/ 76., 73.8708, 12.9680, 12.3850,
     2          77., 76.1110, 13.4185, 12.8241,
     3          78., 78.3948, 13.8805, 13.2726,
     4          79., 80.7249, 14.3528, 13.7336,
     5          80., 83.1023, 14.8393, 14.2087,
     6          81., 85.5304, 15.3467, 14.6979,
     7          82., 88.0045, 15.8608, 15.2000,
     8          83., 90.5259, 16.3875, 15.7111,
     9          84., 93.1000, 16.9280, 16.2370,
     *          85., 95.7240, 17.4820, 16.7760,
     1          86., 98.3970, 18.0480, 17.3280,
     2          87.,101.1300, 18.6340, 17.8990, 
     3          88.,103.9150, 19.2320, 18.4840,
     4          89.,106.7560, 19.8460, 19.0810,
     5          90.,109.6500, 20.4720, 19.6930/
      DATA  E7/ 91.,112.5960, 21.1050, 20.3140,
     2          92.,115.6020, 21.7580, 20.9480,
     3          93.,118.6690, 22.4270, 21.6000,
     4          94.,121.7910, 23.1040, 22.2660,
     5          95.,124.9820, 23.8080, 22.9520,
     6          96.,128.2410, 24.5260, 23.6510,
     7          97.,131.5560, 25.2560, 24.3710,
     8          98.,134.9390, 26.0100, 25.1080,
     9          99.,138.3960, 26.7820, 25.8650,
     *         100.,141.9260, 27.5740, 26.6410,
     1         101.,146.5260, 28.3870, 27.4380,
     2         102.,149.2080, 29.2210, 28.2550,
     3         103.,152.9700, 30.0830, 29.1030,
     4         104.,156.2880, 30.8810, 29.9860,
     5         105.,  0.0,     0.0,     0.0   /
      DATA  IFECA/0/
C
      IF(IFECA.EQ.0)  THEN
         IFECA=1
         PI05=0.5D0*3.14159265358979D0
         EMASS=0.511006D0
         DO 20  K=1,15
         DO 10  I=1,8
         P(I,K   )=P1(I,K)
         P(I,K+15)=P2(I,K)
         P(I,K+30)=P3(I,K)
         P(I,K+45)=P4(I,K)
         P(I,K+60)=P5(I,K)
         P(I,K+75)=P6(I,K)
         P(I,K+90)=P7(I,K)
   10    CONTINUE
   20    CONTINUE
         DO 40  K=1,15
         DO 30  I=1,4
         E(I,K   )=E1(I,K)*1.0D-3
         E(I,K+15)=E2(I,K)*1.0D-3
         E(I,K+30)=E3(I,K)*1.0D-3
         E(I,K+45)=E4(I,K)*1.0D-3
         E(I,K+60)=E5(I,K)*1.0D-3
         E(I,K+75)=E6(I,K)*1.0D-3
         E(I,K+90)=E7(I,K)*1.0D-3
   30    CONTINUE
   40    CONTINUE
         DO 50  K=1,105
         P(6,K)=P(6,K)*P(5,K)
         P(7,K)=P(7,K)*P(6,K)
   50    CONTINUE
C
      END IF
C
      I=NZPAR
      QK =(EEC-E(2,I-1))/EMASS
      IF(QK .GT.0.0D0)  THEN
         FK =QK**2 *P(5,I)*P(2,I)
      ELSE
         FK =0.0D0
      END IF
      QL1=(EEC-E(3,I-1))/EMASS
      IF(QL1.GT.0.0D0)  THEN
         FL1=QL1**2*P(6,I)*P(3,I)
      ELSE
         FL1=0.0D0
      END IF
      QL2=(EEC-E(4,I-1))/EMASS
      IF(QL2.GT.0.0D0)  THEN
         FL2=QL2**2*P(7,I)*P(4,I)
      ELSE
         FL2=0.0D0
      END IF
      FMN=P(8,I)*FL1
C
      FECA=PI05*(FK+FL1+FL2+FMN)
C
      RETURN
      END
