      SUBROUTINE DOCMDOPT(nr_events, seed, nt_save, lunasc)
      IMPLICIT NONE
      INTEGER nr_events, seed, lunasc
      LOGICAL*4 nt_save
C modified 17aug07 djaffe. Remove nskip, replace with random seed.
      
C     Process command-line arguments
C     If no arguments, default is write to external file (LUN=20)
C     If one argument, write ARG(1) events to stdout (LUN=6)
C     If two arguments, ARG(2) is random seed.
C     If three arguments, same as above, but also do HBOOK objects

      INTEGER IARGC,ICDECI
      CHARACTER*20 CMDOPT
      
         if (IARGC().gt.0) then
            lunasc=6
            IF (IARGC().ge.2) then
               CALL GETARG(2, CMDOPT)
               seed = ICDECI(CMDOPT,1,20)
               CALL GETARG(1, CMDOPT)
               nr_events = ICDECI(CMDOPT,1,20)
               nt_save= (IARGC().ge.3)
            ELSE
               CALL GETARG(1, CMDOPT)
               nr_events= ICDECI(CMDOPT,1,20)
            ENDIF
         ENDIF

         RETURN
         END
      
