subroutine finit() bind(C, name="finit")
  write(*,*) "INIT"
end subroutine finit

subroutine fexecute() bind(C, name="fexecute")
  write(*,*) "EXECUTE"
end subroutine fexecute
