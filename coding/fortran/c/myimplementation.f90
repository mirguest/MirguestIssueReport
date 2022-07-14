
module myimpl

  interface
     subroutine set_pod(x, y, z, t) bind(C)
       use, intrinsic :: iso_c_binding, only: c_float
       real(c_float), intent(in), value :: x
       real(c_float), intent(in), value :: y
       real(c_float), intent(in), value :: z
       real(c_float), intent(in), value :: t
     end subroutine set_pod
  end interface


  public :: finit
  public :: fexecute
  
contains
  
  
  subroutine finit() bind(C, name="finit")
    write(*,*) "INIT"
  end subroutine finit

  subroutine fexecute() bind(C, name="fexecute")
    use, intrinsic :: iso_c_binding, only: c_float
    implicit none


    write(*,*) "EXECUTE"

    call set_pod(1.,2.,3.,4.)

  end subroutine fexecute

end module myimpl
