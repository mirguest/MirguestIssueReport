PROGRAM testing_namelist
  integer :: ios
  REAL ::  x = 0
  REAL :: y = 0
  NAMELIST /mynml/ x,y
  PRINT mynml

  ! stdin is 5
  read(5, nml=mynml, iostat=ios)
  write(*,*) ios
  PRINT mynml

END PROGRAM testing_namelist
