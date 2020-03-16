module clfortran_hl
  !! Summary: Create a high-level interface for Fortran+OpenCL.
  !! Author: Sam Miller
  use iso_c_binding
  use iso_fortran_env, only: int32, std_out => output_unit, std_err => error_unit
  use clfortran
  implicit none


  private
  public :: opencl_platform

  integer(c_int32_t) :: err


  type opencl_platform
    character(:), allocatable :: profile
    character(:), allocatable :: version
    character(:), allocatable :: name
    character(:), allocatable :: vendor
    character(:), allocatable :: extensions
  contains
    procedure, public :: initialize => init_platform
    procedure, pass :: write => write_platform
    generic, public :: write(formatted) => write
  end type opencl_platform

  type opencl_device
  contains
    procedure, public :: initialize => init_device
  end type opencl_device

  type opencl_context
    !< An OpenCL context is created with one or more devices.
    !< Contexts are used by the OpenCL runtime for managing objects such as
    !< command-queues, memory, program and kernel objects and for executing
    !< kernels on one or more devices specified in the context.
    integer(c_int) :: num_platforms
    integer(c_int) :: num_devices
    integer(c_intptr_t), pointer :: platform_ids(:)
    integer(c_intptr_t), pointer :: device_ids(:)

    integer(c_intptr_t), dimension(:), pointer :: ctx_props
    integer(c_intptr_t), pointer :: context
    integer(c_int64_t) :: cmd_queue_props
    integer(c_intptr_t), pointer :: cmd_queue
  contains
    procedure, public :: initialize => init_context
    ! final :: finalize
  end type opencl_context

contains

  subroutine init_platform(self, platform_id)
    !< Initialize the OpenCL platform
    class(opencl_platform), intent(inout) :: self
    integer(c_intptr_t), intent(in) :: platform_id

    integer(c_size_t) :: zero_size = 0
    integer(c_size_t) :: temp_size

    character, allocatable, target :: str_buffer(:)

    ! Profile
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_PROFILE, zero_size, C_NULL_PTR, temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    allocate(str_buffer(temp_size))
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_PROFILE, temp_size, C_LOC(str_buffer), temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    call copy_string(str_buffer, self%profile)
    deallocate(str_buffer)

    ! Version
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_VERSION, zero_size, C_NULL_PTR, temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    allocate(str_buffer(temp_size))
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_VERSION, temp_size, C_LOC(str_buffer), temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    call copy_string(str_buffer, self%version)
    deallocate(str_buffer)

    ! Name
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_NAME, zero_size, C_NULL_PTR, temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    allocate(str_buffer(temp_size))
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_NAME, temp_size, C_LOC(str_buffer), temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    call copy_string(str_buffer, self%name)
    deallocate(str_buffer)

    ! Vendor
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_VENDOR, zero_size, C_NULL_PTR, temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    allocate(str_buffer(temp_size))
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_VENDOR, temp_size, C_LOC(str_buffer), temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    call copy_string(str_buffer, self%vendor)
    deallocate(str_buffer)

    ! Extensions
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_EXTENSIONS, zero_size, C_NULL_PTR, temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    allocate(str_buffer(temp_size))
    err = clGetPlatformInfo(platform_id, CL_PLATFORM_EXTENSIONS, temp_size, C_LOC(str_buffer), temp_size)
    if(err /= CL_SUCCESS) call getErrorMessage(err)
    call copy_string(str_buffer, self%extensions)
    deallocate(str_buffer)

  end subroutine init_platform

  subroutine write_platform(self, unit, iotype, v_list, iostat, iomsg)
    !< Implementation of `write(*,*) opencl_platform`

    class(opencl_platform), intent(in) :: self
    integer, intent(in) :: unit           !< input/output unit
    character(*), intent(in) :: iotype    !< LISTDIRECTED or DTxxx
    integer, intent(in) :: v_list(:)      !< parameters from fmt spec.
    integer, intent(out) :: iostat        !< non zero on error, etc.
    character(*), intent(inout) :: iomsg  !< define if iostat non zero.

    write(unit, '(a)', iostat=iostat, iomsg=iomsg) new_line('a')
    write(unit, '(a)', iostat=iostat, iomsg=iomsg) "Platform: " // self%profile // ""//new_line('a')
    write(unit, '(a)', iostat=iostat, iomsg=iomsg) "Version: " // self%version // new_line('a')
    write(unit, '(a)', iostat=iostat, iomsg=iomsg) "Name: " // self%name // new_line('a')
    write(unit, '(a)', iostat=iostat, iomsg=iomsg) "Vendor: " // self%vendor // new_line('a')
    write(unit, '(a)', iostat=iostat, iomsg=iomsg) "Extensions: " // self%extensions // new_line('a')

  end subroutine write_platform

  subroutine init_device(self)
    class(opencl_device), intent(inout) :: self
  end subroutine init_device

  subroutine init_context(self)
    class(opencl_context), intent(inout) :: self
  end subroutine init_context

  subroutine copy_string(old_str, new_str)
    !< Copy from one string to another
    character, allocatable, target, intent(in) :: old_str(:)
    character(len=:), allocatable, intent(out) :: new_str
    integer(int32) :: i, str_length
    character(len=1024) :: buff
    str_length = 0
    buff = ''
    str_length = size(len_trim(old_str))
    do i = 1, str_length - 1
      buff(i:i)=old_str(i)
    end do
    new_str = trim(buff)
  end subroutine copy_string

  ! subroutine initialize(self)
  !   !! Initialize the device context
  !   class(device_context), intent(inout) :: self

  !   ! Get the number of platforms, prior to allocating an array.
  !   err = clGetPlatformIDs(num_entries=0, & 
  !                          platforms=C_NULL_PTR, &
  !                          num_platforms=self%num_platforms)
  !   if(err /= CL_SUCCESS) call getErrorMessage(err)
  !   if(self%num_platforms == 0) error stop "No platforms found"

  !   ! Allocate an array to hold platform handles.
  !   allocate(self%platform_ids(self%num_platforms))

  !   print*, 'num_platforms: ', self%num_platforms

  !   ! Get platforms IDs.
  !   err = clGetPlatformIDs(num_entries=self%num_platforms, &
  !                          platforms=C_LOC(self%platform_ids), & 
  !                          num_platforms=self%num_platforms)
  !   if(err /= CL_SUCCESS) call getErrorMessage(err)

  !   ! Check number of devices for first platform.
  !   err = clGetDeviceIDs(platform=self%platform_ids(1), &
  !                        device_type=CL_DEVICE_TYPE_ALL, &
  !                        num_entries=0, &
  !                        devices=C_NULL_PTR, &
  !                        num_devices=self%num_devices)

  !   if(err /= CL_SUCCESS) call getErrorMessage(err)
  !   if(self%num_devices == 0) error stop "No GPU devices found"

  !   ! Allocate an array to hold device handles.
  !   allocate(self%device_ids(self%num_devices))

  !   ! Get device IDs.
  !   err = clGetDeviceIDs(platform=self%platform_ids(1), &
  !                        device_type=CL_DEVICE_TYPE_GPU, &
  !                        num_entries=self%num_devices, &
  !                        devices=C_LOC(self%device_ids), &
  !                        num_devices=self%num_devices)
  !   if(err /= CL_SUCCESS) call getErrorMessage(err)

  !   ! Create a context
  !   self%num_devices = 1
  !   allocate(self%ctx_props(3))
  !   self%ctx_props(1) = CL_CONTEXT_PLATFORM
  !   self%ctx_props(2) = self%platform_ids(1)
  !   self%ctx_props(3) = 0

  !   self%context = clCreateContext(properties=C_LOC(self%ctx_props), &
  !                                  num_devices=self%num_devices, &
  !                                  devices=C_LOC(self%device_ids), &
  !                                  pfn_notify=C_NULL_FUNPTR, &
  !                                  user_data=C_NULL_PTR, &
  !                                  errcode_ret=err)
  !   if(err /= CL_SUCCESS) call getErrorMessage(err)

  !   ! ! Command queue.
  !   ! cmd_queue_props = 0
  !   ! cmd_queue = clCreateCommandQueue(context, device_ids(1), cmd_queue_props, err)
  !   ! if (err /= CL_SUCCESS) error stop "Error creating command queue"

  ! end subroutine initialize

  ! subroutine finalize(self)
  !   type(device_context), intent(inout) :: self

  !   deallocate(self%platform_ids)
  !   deallocate(self%device_ids)
  !   deallocate(self%ctx_props)
  !   ! err = clReleaseCommandQueue(self%cmd_queue)
  !   ! if (err /= CL_SUCCESS) error stop "Error releasing command queue"

  !   ! err = clReleaseContext(self%context)
  !   ! if (err /= CL_SUCCESS) error stop "Error releasing context"
  ! end subroutine finalize

end module clfortran_hl
