program main
  implicit none
  integer, parameter :: i4b = selected_int_kind(9)
  real times, timet, time
  integer(kind=i4b) :: strt, stp, x, z
  character(len=20) :: buffer
  call getarg(1,buffer)
  read(buffer,*) strt
  call getarg(2,buffer)
  read(buffer,*) stp

  do x = strt, stp, strt
    call cpu_time(times)
    Z = genprime(x)
    call cpu_time(timet)
    time = timet - times
    print '(a6, i8, a11, f10.5, a19, i10, a)', 'Found ',x,' primes in ',time,' seconds (last was ',z,')'
  end do

contains

  function genprime(mx) result (res)
    integer(kind=i4b), intent(in) :: mx
    integer(kind=i4b) :: res, cnt, cur
    cur = 0
    cnt = 0
    do while(cnt.lt.mx)
      if(isprime(cur)) then
        cnt = cnt + 1
      end if
      cur = cur + 1
    end do
    res = cur - 1
  end function genprime

  function isprime(x) result (res)
    integer(kind=i4b), intent(in) :: x
    integer(kind=i4b) :: lim, y
    logical :: res

    if(x.lt.2) then
      res = .false.
      return
    end if
    if(x.lt.4) then
      res = .true.
      return
    end if
    if(x.eq.5) then
      res = .true.
      return
    end if
    if(modulo(x,2).eq.0) then
      res = .false.
      return
    end if
    if(modulo(x,5).eq.0) then
      res = .false.
      return
    end if
    if(modulo(x + 1, 6) .ne. 0) then
      if(modulo(x - 1, 6) .ne. 0) then
        res = .false.
        return
      end if
    end if
    lim = int(sqrt(real(x)) + 1.0)
    do y = 3, lim, 2
      if(modulo(x,y).eq.0) then
        res = .false.
        return
      end if
    end do
    res = .true.
    return
  end function isprime

end program main
