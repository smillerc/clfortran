! gfortran -fcheck=all -ffixed-form -fbacktrace -L/usr/lib64/nvidia -lOpenCL -o sum sum.f
! srun --gres=gpu ./sum
!
! uses module clfortran.mod
!
      program sum
            use clfortran
            use ISO_C_BINDING
            implicit none
    
            integer irec, i, iallocerr, iplatform, idevice
            integer, parameter :: iunit = 10
    
            integer(c_int32_t) :: ierr, num_devices, num_platforms
            integer(c_size_t) :: iret, size_in_bytes, zero_size = 0
            character, dimension(1) :: char
            character(len=1024) :: options, kernel_name
    
    ! C_LOC determines the C address of an object
    ! The variable type must be either a pointer or a target
            integer, target :: isize
            integer(c_size_t), target :: globalsize, localsize
            integer(c_int32_t), target :: device_cu, build_log
            integer(c_intptr_t), allocatable, target :: platform_ids(:), device_ids(:)
            integer(c_intptr_t), target :: ctx_props(3), context, cmd_queue, prog, kernel, cl_vec1, cl_vec2
            character(len=1, kind=c_char), allocatable, target ::     source(:), device_name(:)
            character(len=1, kind=c_char), target ::source2(1:1024), retinfo(1:1024), c_options(1:1024), c_kernel_name(1:1024)
            real, allocatable, target :: vec1(:), vec2(:)
            type(c_ptr), target :: psource
    
            print '(///)'
    
            ierr = clGetPlatformIDs(0, C_NULL_PTR, num_platforms)
            if((ierr /= CL_SUCCESS) .or. (num_platforms < 1)) print *, 'clGetPlatformIDs', ierr
            print '(a,i2)', 'Num Platforms: ', num_platforms
            allocate(platform_ids(num_platforms), stat=iallocerr)
            if(iallocerr /= 0) error stop 'memory allocation error'
    ! whenever "&" appears in C subroutine (address-off) call,
    ! then C_LOC has to be used in Fortran
            ierr = clGetPlatformIDs(num_platforms, C_LOC(platform_ids), num_platforms)
            if(ierr /= CL_SUCCESS) error stop 'clGetPlatformIDs'
    
    ! Get device IDs only for platform 1
            iplatform = 1
    
            ierr = clGetDeviceIDs(platform_ids(iplatform), CL_DEVICE_TYPE_ALL, 0, C_NULL_PTR, num_devices)
            if((ierr /= CL_SUCCESS) .or. (num_devices < 1)) error stop 'clGetDeviceIDs'
            print '(a,i2)', 'Num Devices: ', num_devices
            allocate(device_ids(num_devices), stat=iallocerr)
            if(iallocerr /= 0) error stop 'memory allocation error'
    ! whenever "&" appears in C subroutine (address-off) call,
    ! then C_LOC has to be used in Fortran
            ierr = clGetDeviceIDs(platform_ids(iplatform), CL_DEVICE_TYPE_ALL, num_devices, C_LOC(device_ids), num_devices)
            if(ierr /= CL_SUCCESS) error stop 'clGetDeviceIDs'
    
    ! Get device info only for device 1
            idevice = 1
    
            ierr = clGetDeviceInfo(device_ids(idevice), CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(device_cu), C_LOC(device_cu), iret)
            if(ierr /= CL_SUCCESS) error stop 'clGetDeviceInfo'
            ierr = clGetDeviceInfo(device_ids(idevice), CL_DEVICE_NAME, zero_size, C_NULL_PTR, iret)
            if(ierr /= CL_SUCCESS) error stop 'clGetDeviceInfo'
            allocate(device_name(iret), stat=iallocerr)
            if(iallocerr /= 0) error stop 'allocate'
            ierr = clGetDeviceInfo(device_ids(idevice), CL_DEVICE_NAME, sizeof(device_name), C_LOC(device_name), iret)
            if(ierr /= CL_SUCCESS) error stop 'clGetDeviceInfo'
            write(*, '(a,i2,a,i3,a)', advance='no') ' Device (#', idevice, ', Compute Units: ', device_cu, ') - '
            print *, device_name(1:iret)
            deallocate(device_name)
    
            print '(a,i2,a)', 'Creating context for: ', num_devices, ' devices'
            print '(a,i2)', 'for platform: ', iplatform
            ctx_props(1) = CL_CONTEXT_PLATFORM
            ctx_props(2) = platform_ids(iplatform)
            ctx_props(3) = 0
            context = clCreateContext(C_LOC(ctx_props), num_devices, C_LOC(device_ids), C_NULL_FUNPTR, C_NULL_PTR, ierr)
            if(ierr /= CL_SUCCESS) error stop 'clCreateContext'
    
            cmd_queue = clCreateCommandQueue(context, device_ids(idevice), CL_QUEUE_PROFILING_ENABLE, ierr)
            if(ierr /= CL_SUCCESS) error stop 'clCreateCommandQueue'
    
    ! read kernel from disk
            open(iunit, file='sum.cl', access='direct', status='old', action='read', iostat=ierr, recl=1)
            if(ierr /= 0) error stop 'Cannot open file sum.cl'
            irec = 1
    10      continue
            read(iunit, rec=irec, iostat=ierr) char
            if(ierr /= 0) goto 11
            irec = irec + 1
            goto 10
    11      continue
            if(irec == 0) error stop 'nothing read'
            allocate(source(irec + 1), stat=iallocerr)
            if(iallocerr /= 0) error stop 'allocate'
            do i = 1, irec
              read(iunit, rec=i, iostat=ierr) source(i:i)
            enddo
            close(iunit)
    !      print '(a)','**** CL SOURCE CODE START ****'
    !      print '(1024a)',source(1:irec)
    !      print '(a)','**** CL SOURCE CODE END ****'
            print '(a,i4)', 'size of source code in bytes: ', irec
    ! in C, strings end with c_null_char
            source(irec + 1) = C_NULL_CHAR
    
            psource = C_LOC(source) ! pointer to source code
            prog = clCreateProgramWithSource(context, 1, C_LOC(psource), C_NULL_PTR, ierr)
            if(ierr /= CL_SUCCESS) error stop 'clCreateProgramWithSource'
    
            print '(///)'
    
    ! check if program has uploaded successfully to CL device
            ierr = clGetProgramInfo(prog, CL_PROGRAM_SOURCE, sizeof(source2), C_LOC(source2), iret)
            if(ierr /= CL_SUCCESS) error stop 'clGetProgramInfo'
            print '(a)', '**** code retrieved from device start ****'
            print '(1024a)', source2(1:min(iret, 1024))
            print '(a)', '**** code retrieved from device end ****'
    
            print '(///)'
    
            options = '-cl-opt-disable' ! compiler options
            irec = len(trim(options))
            do i = 1, irec
              c_options(i) = options(i:i)
            enddo
            c_options(irec + 1) = C_NULL_CHAR
            ierr = clBuildProgram(prog, 0, C_NULL_PTR, C_LOC(c_options), C_NULL_FUNPTR, C_NULL_PTR)
            if(ierr /= CL_SUCCESS) then
              print *, 'clBuildProgram', ierr
              ierr = clGetProgramBuildInfo(prog, device_ids(idevice), CL_PROGRAM_BUILD_LOG, sizeof(retinfo), C_LOC(retinfo), iret)
              if(ierr /= 0) error stop 'clGetProgramBuildInfo'
              print '(a)', 'build log start'
              print '(1024a)', retinfo(1:min(iret, 1024))
              print '(a)', 'build log end'
              stop
            endif
    
            kernel_name = 'sum'
            irec = len(trim(kernel_name))
            do i = 1, irec
              c_kernel_name(i) = kernel_name(i:i)
            enddo
            c_kernel_name(irec + 1) = C_NULL_CHAR
            kernel = clCreateKernel(prog, C_LOC(c_kernel_name), ierr)
            if(ierr /= 0) error stop 'clCreateKernel'
    
            ierr = clReleaseProgram(prog)
            if(ierr /= 0) error stop 'clReleaseProgram'
    
            isize = 1000
            size_in_bytes = int(isize, 8) * 4_8
    ! Size of an element, typically:
    ! 4_8 for integer or real
    ! 8_8 for double precision or complex
    ! 16_8 for double complex
    ! second 8 indicates kind=8 (same is true for 8 in int() argument list)
            allocate(vec1(1:isize))
            allocate(vec2(1:isize))
    
            do i = 1, isize
              vec1(i) = real(i)
              vec2(i) = real(isize - i)
            enddo
    
    ! allocate device memory
            cl_vec1 = clCreateBuffer(context, CL_MEM_READ_ONLY, size_in_bytes, C_NULL_PTR, ierr)
            if(ierr /= 0) error stop 'clCreateBuffer'
            cl_vec2 = clCreateBuffer(context, CL_MEM_READ_WRITE, size_in_bytes, C_NULL_PTR, ierr)
            if(ierr /= 0) error stop 'clCreateBuffer'
    
    ! copy data to device memory
            ierr = clEnqueueWriteBuffer(cmd_queue, cl_vec1, CL_TRUE, 0_8, size_in_bytes, C_LOC(vec1), 0, C_NULL_PTR, C_NULL_PTR)
    ! 0_8 is a zero of kind=8
            if(ierr /= 0) error stop 'clEnqueueWriteBuffer'
            ierr = clEnqueueWriteBuffer(cmd_queue, cl_vec2, CL_TRUE, 0_8, size_in_bytes, C_LOC(vec2), 0, C_NULL_PTR, C_NULL_PTR)
            if(ierr /= 0) error stop 'clEnqueueWriteBuffer'
    
    ! set the kernel arguments
            ierr = clSetKernelArg(kernel, 0, sizeof(isize), C_LOC(isize))
            if(ierr /= 0) error stop 'clSetKernelArg'
            ierr = clSetKernelArg(kernel, 1, sizeof(cl_vec1), C_LOC(cl_vec1))
            if(ierr /= 0) error stop 'clSetKernelArg'
            ierr = clSetKernelArg(kernel, 2, sizeof(cl_vec2), C_LOC(cl_vec2))
            if(ierr /= 0) error stop 'clSetKernelArg'
    
    ! get the local size for the kernel
            ierr = clGetKernelWorkGroupInfo(kernel, device_ids(idevice), &
                                            CL_KERNEL_WORK_GROUP_SIZE, sizeof(localsize), C_LOC(localsize), iret)
            if(ierr /= 0) error stop 'clGetKernelWorkGroupInfo'
            globalsize = int(isize, 8)
            if(mod(globalsize, localsize) /= 0) globalsize = globalsize + localsize - mod(globalsize, localsize)
    
    ! execute the kernel
            ierr = clEnqueueNDRangeKernel(cmd_queue, kernel, 1, C_NULL_PTR, &
                                          C_LOC(globalsize), C_LOC(localsize), 0, C_NULL_PTR, C_NULL_PTR)
            if(ierr /= 0) error stop 'clEnqueueNDRangeKernel'
            ierr = clFinish(cmd_queue)
            if(ierr /= 0) error stop 'clFinish'
    
            print '(a)', 'sent to device:'
            do i = 1, 10
              print '(2e12.5)', vec1(i), vec2(i)
            enddo
    
    ! read the resulting vector from device memory
            ierr = clEnqueueReadBuffer(cmd_queue, cl_vec2, CL_TRUE, 0_8, size_in_bytes, C_LOC(vec2), 0, C_NULL_PTR, C_NULL_PTR)
            if(ierr /= 0) error stop 'clEnqueueReadBuffer'
    
            print '(a)', 'retrieved from device:'
            do i = 1, 10
              print '(12x,e12.5)', vec2(i)
            enddo
    
            ierr = clReleaseKernel(kernel)
            if(ierr /= 0) error stop 'clReleaseKernel'
            ierr = clReleaseCommandQueue(cmd_queue)
            if(ierr /= 0) error stop 'clReleaseCommandQueue'
            ierr = clReleaseContext(context)
            if(ierr /= 0) error stop 'clReleaseContext'
    
          end
    
    ! Argument lists need to be handled with care. Neither the C nor the Fortran compiler checks for mismatched argument types, or even a mismatch in the number of arguments. Some bizarre run-time errors therefore arise. Keep in mind that Fortran passes arguments by reference whereas C passes arguments by value. When you put a variable name into a function call from Fortran, the corresponding C function receives a pointer to that variable. Similarly, when calling a Fortran subroutine from C, you must explicitly pass addresses rather than values in the argument list.
    
    ! When passing arrays, remember that C arrays start with subscript zero. Fortran stores multidimensional arrays in column-major order (first index varies fastest) whereas C stores them in row-major order (last index varies fastest).
    
    ! Passing character strings is a special problem. C knows it has come to the end of string when it hits a null character, but Fortran uses the declared length of a string. The C-Fortran interface provides an extra argument for each character string in a C argument list to receive the declared length of a string when called from Fortran. Consider the following Fortran fragment:
    
    