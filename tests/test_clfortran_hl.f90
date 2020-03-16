program test_highlevel
  use iso_c_binding
  use clfortran
  use clfortran_hl
  implicit none

      ! Variable definitions for OpenCL API and in general.
  integer(c_int32_t) :: err
  integer(c_size_t) :: zero_size = 0
  integer(c_size_t) :: temp_size
  integer(c_int) :: num_platforms
  integer(c_int) :: i
  integer(c_intptr_t), allocatable, target :: platform_ids(:)
  type(opencl_platform) :: platform

  ! Get the number of platforms, prior to allocating an array.
  err = clGetPlatformIDs(0, C_NULL_PTR, num_platforms)
  if (err /= CL_SUCCESS) then
      print *, 'Error quering platforms: ', err
      call exit(1)
  end if

  print '(A, I2)', 'Num Platforms: ', num_platforms

  ! Allocate an array to hold platform handles.
  allocate(platform_ids(num_platforms))

  ! Get platforms IDs.
  err = clGetPlatformIDs(num_platforms, C_LOC(platform_ids), num_platforms)
  if (err /= CL_SUCCESS) then
      print *, 'Error quering platforms: ', err
      call exit(1)
  end if


  call platform%initialize(platform_ids(1))
  write(*,*) platform
  ! deallocate(ctx)
end program test_highlevel