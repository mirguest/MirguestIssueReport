c
c   KamLAND MC common for Fermi distribution of beta particles
c
c          BT 6-2-00
c

       real*8 efermi(10000),probfermi(10000)
       real*4 probfermi_s(10000)
       integer*4 fpoint_nr
       integer nfcommon
       parameter(nfcommon=10000)
c      common /fermibin/ fpoint_nr,efermi,probfermi_s
       common /fermibin/ efermi,probfermi_s,fpoint_nr
