subroutine docmdopt(seed)
    implicit none
    integer seed

    integer iargc
    integer icdeci
    character*20 cmdopt
    
    seed = 0
    if(iargc() .gt. 0) then
        call getarg(1, cmdopt)
        seed = icdeci(cmdopt, 1, 20)
    endif

end subroutine docmdopt

subroutine callonce
    implicit none
    logical*4 flag/.false./
    if (.not. flag) then
        write(*,*) 'First Call: ', flag
        flag = .true.
    endif
    write(*,*) flag
end subroutine callonce

subroutine anothercall
    implicit none
    logical*4 flag
    !data flag
    if (.not. flag) then
        write(*,*) "SPECIAL:", flag
        flag = .true.
    endif
    write(*,*) flag

end subroutine anothercall

subroutine accumulateall
    implicit none
    integer i/0/
    i = i + 1
    write(*,*) i
end subroutine accumulateall

subroutine initonce
    implicit none
    logical*4 flag

    write(*, *)flag
    if (flag) then
        flag = .false.
    else 
        flag = .true.
    endif

end subroutine initonce

program main
    implicit none
    integer seed
    call docmdopt(seed)
    write(*,*) seed
    call rluxgo(0, seed, 0, 0)

    call callonce
    call callonce

    call anothercall
    call anothercall

    write(*,*) "INIT ONCE?"
    call initonce
    call initonce
    call initonce
    call initonce

    write(*,*) "Accumulate All?"
    call accumulateall
    call accumulateall
    call accumulateall
    call accumulateall
    call accumulateall
    call accumulateall
end program main
