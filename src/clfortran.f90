! -----------------------------------------------------------------------------
! CLFORTRAN - OpenCL bindings module for Fortran.
!
! This is the main module file and contains all OpenCL API definitions to be
! invoked from Fortran programs.
!
! -----------------------------------------------------------------------------
!
! Copyright (C) 2013 Company for Advanced Supercomputing Solutions LTD
! Bosmat 2a St.
! Shoham
! Israel 60850
! http://www.cass-hpc.com
!
! Author: Mordechai Butrashvily <support@cass-hpc.com>
!
! -----------------------------------------------------------------------------
!
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU Lesser General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.
!
! -----------------------------------------------------------------------------

module clfortran_types
  use iso_c_binding
  implicit none

  ! ------------
  ! Types
  ! ------------

  type, bind(C) :: cl_image_format
    integer(c_int32_t) :: image_channel_order
    integer(c_int32_t) :: image_channel_data_type
  end type

  type, bind(C) :: cl_image_desc
    integer(c_int32_t)  :: image_type
    integer(c_size_t)   :: image_width
    integer(c_size_t)   :: image_height
    integer(c_size_t)   :: image_depth
    integer(c_size_t)   :: image_array_size
    integer(c_size_t)   :: image_row_pitch
    integer(c_size_t)   :: image_slice_pitch
    integer(c_int32_t)  :: num_mip_levels
    integer(c_int32_t)  :: num_samples
    integer(c_intptr_t) :: buffer
  end type

end module clfortran_types

module clfortran
  use iso_c_binding
  implicit none

  ! Error Codes
  integer(c_int32_t), parameter :: CL_SUCCESS = 0
  integer(c_int32_t), parameter :: CL_DEVICE_NOT_FOUND = -1
  integer(c_int32_t), parameter :: CL_DEVICE_NOT_AVAILABLE = -2
  integer(c_int32_t), parameter :: CL_COMPILER_NOT_AVAILABLE = -3
  integer(c_int32_t), parameter :: CL_MEM_OBJECT_ALLOCATION_FAILURE = -4
  integer(c_int32_t), parameter :: CL_OUT_OF_RESOURCES = -5
  integer(c_int32_t), parameter :: CL_OUT_OF_HOST_MEMORY = -6
  integer(c_int32_t), parameter :: CL_PROFILING_INFO_NOT_AVAILABLE = -7
  integer(c_int32_t), parameter :: CL_MEM_COPY_OVERLAP = -8
  integer(c_int32_t), parameter :: CL_IMAGE_FORMAT_MISMATCH = -9
  integer(c_int32_t), parameter :: CL_IMAGE_FORMAT_NOT_SUPPORTED = -10
  integer(c_int32_t), parameter :: CL_BUILD_PROGRAM_FAILURE = -11
  integer(c_int32_t), parameter :: CL_MAP_FAILURE = -12
  integer(c_int32_t), parameter :: CL_MISALIGNED_SUB_BUFFER_OFFSET = -13
  integer(c_int32_t), parameter :: CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST = -14
  integer(c_int32_t), parameter :: CL_COMPILE_PROGRAM_FAILURE = -15
  integer(c_int32_t), parameter :: CL_LINKER_NOT_AVAILABLE = -16
  integer(c_int32_t), parameter :: CL_LINK_PROGRAM_FAILURE = -17
  integer(c_int32_t), parameter :: CL_DEVICE_PARTITION_FAILED = -18
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_INFO_NOT_AVAILABLE = -19

  integer(c_int32_t), parameter :: CL_INVALID_VALUE = -30
  integer(c_int32_t), parameter :: CL_INVALID_DEVICE_TYPE = -31
  integer(c_int32_t), parameter :: CL_INVALID_PLATFORM = -32
  integer(c_int32_t), parameter :: CL_INVALID_DEVICE = -33
  integer(c_int32_t), parameter :: CL_INVALID_CONTEXT = -34
  integer(c_int32_t), parameter :: CL_INVALID_QUEUE_PROPERTIES = -35
  integer(c_int32_t), parameter :: CL_INVALID_COMMAND_QUEUE = -36
  integer(c_int32_t), parameter :: CL_INVALID_HOST_PTR = -37
  integer(c_int32_t), parameter :: CL_INVALID_MEM_OBJECT = -38
  integer(c_int32_t), parameter :: CL_INVALID_IMAGE_FORMAT_DESCRIPTOR = -39
  integer(c_int32_t), parameter :: CL_INVALID_IMAGE_SIZE = -40
  integer(c_int32_t), parameter :: CL_INVALID_SAMPLER = -41
  integer(c_int32_t), parameter :: CL_INVALID_BINARY = -42
  integer(c_int32_t), parameter :: CL_INVALID_BUILD_OPTIONS = -43
  integer(c_int32_t), parameter :: CL_INVALID_PROGRAM = -44
  integer(c_int32_t), parameter :: CL_INVALID_PROGRAM_EXECUTABLE = -45
  integer(c_int32_t), parameter :: CL_INVALID_KERNEL_NAME = -46
  integer(c_int32_t), parameter :: CL_INVALID_KERNEL_DEFINITION = -47
  integer(c_int32_t), parameter :: CL_INVALID_KERNEL = -48
  integer(c_int32_t), parameter :: CL_INVALID_ARG_INDEX = -49
  integer(c_int32_t), parameter :: CL_INVALID_ARG_VALUE = -50
  integer(c_int32_t), parameter :: CL_INVALID_ARG_SIZE = -51
  integer(c_int32_t), parameter :: CL_INVALID_KERNEL_ARGS = -52
  integer(c_int32_t), parameter :: CL_INVALID_WORK_DIMENSION = -53
  integer(c_int32_t), parameter :: CL_INVALID_WORK_GROUP_SIZE = -54
  integer(c_int32_t), parameter :: CL_INVALID_WORK_ITEM_SIZE = -55
  integer(c_int32_t), parameter :: CL_INVALID_GLOBAL_OFFSET = -56
  integer(c_int32_t), parameter :: CL_INVALID_EVENT_WAIT_LIST = -57
  integer(c_int32_t), parameter :: CL_INVALID_EVENT = -58
  integer(c_int32_t), parameter :: CL_INVALID_OPERATION = -59
  integer(c_int32_t), parameter :: CL_INVALID_GL_OBJECT = -60
  integer(c_int32_t), parameter :: CL_INVALID_BUFFER_SIZE = -61
  integer(c_int32_t), parameter :: CL_INVALID_MIP_LEVEL = -62
  integer(c_int32_t), parameter :: CL_INVALID_GLOBAL_WORK_SIZE = -63
  integer(c_int32_t), parameter :: CL_INVALID_PROPERTY = -64
  integer(c_int32_t), parameter :: CL_INVALID_IMAGE_DESCRIPTOR = -65
  integer(c_int32_t), parameter :: CL_INVALID_COMPILER_OPTIONS = -66
  integer(c_int32_t), parameter :: CL_INVALID_LINKER_OPTIONS = -67
  integer(c_int32_t), parameter :: CL_INVALID_DEVICE_PARTITION_COUNT = -68
  integer(c_int32_t), parameter :: CL_INVALID_PIPE_SIZE = -69
  integer(c_int32_t), parameter :: CL_INVALID_DEVICE_QUEUE = -70
  
  ! Extension Error Codes
  integer(c_int32_t), parameter :: CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR= -1000 	
  integer(c_int32_t), parameter :: CL_PLATFORM_NOT_FOUND_KHR= -1001 	
  integer(c_int32_t), parameter :: CL_INVALID_D3D10_DEVICE_KHR= -1002 	
  integer(c_int32_t), parameter :: CL_INVALID_D3D10_RESOURCE_KHR= -1003 	
  integer(c_int32_t), parameter :: CL_D3D10_RESOURCE_ALREADY_ACQUIRED_KHR= -1004 	
  integer(c_int32_t), parameter :: CL_D3D10_RESOURCE_NOT_ACQUIRED_KHR= -1005 	
  integer(c_int32_t), parameter :: CL_INVALID_D3D11_DEVICE_KHR= -1006 	
  integer(c_int32_t), parameter :: CL_INVALID_D3D11_RESOURCE_KHR= -1007 	
  integer(c_int32_t), parameter :: CL_D3D11_RESOURCE_ALREADY_ACQUIRED_KHR= -1008 	
  integer(c_int32_t), parameter :: CL_D3D11_RESOURCE_NOT_ACQUIRED_KHR= -1009 	
  integer(c_int32_t), parameter :: CL_INVALID_D3D9_DEVICE_NV = -1010 	
  integer(c_int32_t), parameter :: CL_INVALID_DX9_DEVICE_INTEL= -1010 	
  integer(c_int32_t), parameter :: CL_INVALID_D3D9_RESOURCE_NV = -1011 	
  integer(c_int32_t), parameter :: CL_INVALID_DX9_RESOURCE_INTEL= -1011 	
  integer(c_int32_t), parameter :: CL_D3D9_RESOURCE_ALREADY_ACQUIRED_NV = -1012 	
  integer(c_int32_t), parameter :: CL_DX9_RESOURCE_ALREADY_ACQUIRED_INTEL= -1012 	
  integer(c_int32_t), parameter :: CL_D3D9_RESOURCE_NOT_ACQUIRED_NV = -1013 	
  integer(c_int32_t), parameter ::  CL_DX9_RESOURCE_NOT_ACQUIRED_INTEL= -1013 	
  integer(c_int32_t), parameter :: CL_EGL_RESOURCE_NOT_ACQUIRED_KHR= -1092 	
  integer(c_int32_t), parameter :: CL_INVALID_EGL_OBJECT_KHR= -1093 	
  integer(c_int32_t), parameter :: CL_INVALID_ACCELERATOR_INTEL= -1094 	
  integer(c_int32_t), parameter :: CL_INVALID_ACCELERATOR_TYPE_INTEL= -1095 	
  integer(c_int32_t), parameter :: CL_INVALID_ACCELERATOR_DESCRIPTOR_INTEL= -1096 	
  integer(c_int32_t), parameter :: CL_ACCELERATOR_TYPE_NOT_SUPPORTED_INTEL= -1097 	
  integer(c_int32_t), parameter :: CL_INVALID_VA_API_MEDIA_ADAPTER_INTEL= -1098 	
  integer(c_int32_t), parameter :: CL_INVALID_VA_API_MEDIA_SURFACE_INTEL= -1099 	
  integer(c_int32_t), parameter :: CL_VA_API_MEDIA_SURFACE_ALREADY_ACQUIRED_INTEL= -1100 	
  integer(c_int32_t), parameter :: CL_VA_API_MEDIA_SURFACE_NOT_ACQUIRED_INTEL= -1101 	

  ! OpenCL Version
  integer(c_int32_t), parameter :: CL_VERSION_1_0 = 1
  integer(c_int32_t), parameter :: CL_VERSION_1_1 = 1
  integer(c_int32_t), parameter :: CL_VERSION_1_2 = 1

  ! cl_bool
  integer(c_int32_t), parameter :: CL_FALSE = 0
  integer(c_int32_t), parameter :: CL_TRUE = 1
  integer(c_int32_t), parameter :: CL_BLOCKING = CL_TRUE
  integer(c_int32_t), parameter :: CL_NON_BLOCKING = CL_FALSE

  ! cl_platform_info
  integer(c_int32_t), parameter :: CL_PLATFORM_PROFILE = int(Z'0900', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PLATFORM_VERSION = int(Z'0901', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PLATFORM_NAME = int(Z'0902', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PLATFORM_VENDOR = int(Z'0903', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PLATFORM_EXTENSIONS = int(Z'0904', kind=c_int32_t)

  ! cl_device_type - bitfield
  integer(c_int64_t), parameter :: CL_DEVICE_TYPE_DEFAULT = int(b'00001', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_DEVICE_TYPE_CPU = int(b'00010', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_DEVICE_TYPE_GPU = int(b'00100', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_DEVICE_TYPE_ACCELERATOR = int(b'01000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_DEVICE_TYPE_CUSTOM = int(b'10000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_DEVICE_TYPE_ALL = int(Z'FFFFFFFF', kind=c_int64_t)

  ! cl_device_info
  integer(c_int32_t), parameter :: CL_DEVICE_TYPE = int(Z'1000', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_VENDOR_ID = int(Z'1001', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_COMPUTE_UNITS = int(Z'1002', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS = int(Z'1003', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_WORK_GROUP_SIZE = int(Z'1004', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_WORK_ITEM_SIZES = int(Z'1005', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR = int(Z'1006', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT = int(Z'1007', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT = int(Z'1008', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG = int(Z'1009', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT = int(Z'100A', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE = int(Z'100B', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_CLOCK_FREQUENCY = int(Z'100C', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_ADDRESS_BITS = int(Z'100D', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_READ_IMAGE_ARGS = int(Z'100E', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_WRITE_IMAGE_ARGS = int(Z'100F', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_MEM_ALLOC_SIZE = int(Z'1010', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_IMAGE2D_MAX_WIDTH = int(Z'1011', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_IMAGE2D_MAX_HEIGHT = int(Z'1012', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_IMAGE3D_MAX_WIDTH = int(Z'1013', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_IMAGE3D_MAX_HEIGHT = int(Z'1014', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_IMAGE3D_MAX_DEPTH = int(Z'1015', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_IMAGE_SUPPORT = int(Z'1016', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_PARAMETER_SIZE = int(Z'1017', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_SAMPLERS = int(Z'1018', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MEM_BASE_ADDR_ALIGN = int(Z'1019', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE = int(Z'101A', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_SINGLE_FP_CONFIG = int(Z'101B', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_GLOBAL_MEM_CACHE_TYPE = int(Z'101C', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE = int(Z'101D', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_GLOBAL_MEM_CACHE_SIZE = int(Z'101E', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_GLOBAL_MEM_SIZE = int(Z'101F', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE = int(Z'1020', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_MAX_CONSTANT_ARGS = int(Z'1021', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_LOCAL_MEM_TYPE = int(Z'1022', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_LOCAL_MEM_SIZE = int(Z'1023', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_ERROR_CORRECTION_SUPPORT = int(Z'1024', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PROFILING_TIMER_RESOLUTION = int(Z'1025', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_ENDIAN_LITTLE = int(Z'1026', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_AVAILABLE = int(Z'1027', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_COMPILER_AVAILABLE = int(Z'1028', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_EXECUTION_CAPABILITIES = int(Z'1029', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_QUEUE_PROPERTIES = int(Z'102A', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_NAME = int(Z'102B', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_VENDOR = int(Z'102C', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DRIVER_VERSION = int(Z'102D', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PROFILE = int(Z'102E', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_VERSION = int(Z'102F', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_EXTENSIONS = int(Z'1030', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PLATFORM = int(Z'1031', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_DOUBLE_FP_CONFIG = int(Z'1032', kind=c_int32_t)
  ! 0x1033 reserved for CL_DEVICE_HALF_FP_CONFIG
  integer(c_int32_t), parameter :: CL_DEVICE_PREFERRED_VECTOR_WIDTH_HALF = int(Z'1034', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_HOST_UNIFIED_MEMORY = int(Z'1035', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_NATIVE_VECTOR_WIDTH_CHAR = int(Z'1036', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_NATIVE_VECTOR_WIDTH_SHORT = int(Z'1037', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_NATIVE_VECTOR_WIDTH_INT = int(Z'1038', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_NATIVE_VECTOR_WIDTH_LONG = int(Z'1039', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_NATIVE_VECTOR_WIDTH_FLOAT = int(Z'103A', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE = int(Z'103B', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_NATIVE_VECTOR_WIDTH_HALF = int(Z'103C', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_OPENCL_C_VERSION = int(Z'103D', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_LINKER_AVAILABLE = int(Z'103E', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_BUILT_IN_KERNELS = int(Z'103F', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_IMAGE_MAX_BUFFER_SIZE = int(Z'1040', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_IMAGE_MAX_ARRAY_SIZE = int(Z'1041', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PARENT_DEVICE = int(Z'1042', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PARTITION_MAX_SUB_DEVICES = int(Z'1043', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PARTITION_PROPERTIES = int(Z'1044', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PARTITION_AFFINITY_DOMAIN = int(Z'1045', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PARTITION_TYPE = int(Z'1046', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_REFERENCE_COUNT = int(Z'1047', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PREFERRED_INTEROP_USER_SYNC = int(Z'1048', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEVICE_PRINTF_BUFFER_SIZE = int(Z'1049', kind=c_int32_t)

  ! cl_device_fp_config - bitfield
  integer(c_int64_t), parameter :: CL_FP_DENORM = int(b'00000001', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_FP_INF_NAN = int(b'00000010', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_FP_ROUND_TO_NEAREST = int(b'00000100', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_FP_ROUND_TO_ZERO = int(b'00001000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_FP_ROUND_TO_INF = int(b'00010000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_FP_FMA = int(b'00100000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_FP_SOFT_FLOAT = int(b'01000000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_FP_CORRECTLY_ROUNDED_DIVIDE_SQRT = int(b'10000000', kind=c_int64_t)

  ! cl_device_mem_cache_type
  integer(c_int32_t), parameter :: CL_NONE = int(Z'0', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_READ_ONLY_CACHE = int(Z'1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_READ_WRITE_CACHE = int(Z'2', kind=c_int32_t)

  ! cl_device_local_mem_type
  integer(c_int32_t), parameter :: CL_LOCAL = int(Z'1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_GLOBAL = int(Z'2', kind=c_int32_t)

  ! cl_device_exec_capabilities - bitfield
  integer(c_int64_t), parameter :: CL_EXEC_KERNEL = int(b'01', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_EXEC_NATIVE_KERNEL = int(b'10', kind=c_int64_t)

  ! cl_command_queue_properties - bitfield
  integer(c_int64_t), parameter :: CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE = int(b'01', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_QUEUE_PROFILING_ENABLE = int(b'10', kind=c_int64_t)

  ! cl_context_info
  integer(c_int32_t), parameter :: CL_CONTEXT_REFERENCE_COUNT = int(Z'1080', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_CONTEXT_DEVICES = int(Z'1081', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_CONTEXT_PROPERTIES = int(Z'1082', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_CONTEXT_NUM_DEVICES = int(Z'1083', kind=c_int32_t)

  ! cl_context_properties type(c_ptr)
  integer(c_intptr_t), parameter :: CL_CONTEXT_PLATFORM = int(Z'1084', kind=c_intptr_t)
  integer(c_intptr_t), parameter :: CL_CONTEXT_INTEROP_USER_SYNC = int(Z'1085', kind=c_intptr_t)

  ! cl_command_queue_info
  integer(c_int32_t), parameter :: CL_QUEUE_CONTEXT = int(Z'1090', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_QUEUE_DEVICE = int(Z'1091', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_QUEUE_REFERENCE_COUNT = int(Z'1092', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_QUEUE_PROPERTIES = int(Z'1093', kind=c_int32_t)

  ! cl_mem_flags - bitfield (int64)
  integer(c_int64_t), parameter :: CL_MEM_READ_WRITE = int(b'0000000001', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_MEM_WRITE_ONLY = int(b'0000000010', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_MEM_READ_ONLY = int(b'0000000100', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_MEM_USE_HOST_PTR = int(b'0000001000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_MEM_ALLOC_HOST_PTR = int(b'0000010000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_MEM_COPY_HOST_PTR = int(b'0000100000', kind=c_int64_t)
  !integer(c_int64_t), parameter :: reserved                                  = int(b'0001000000' ,kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_MEM_HOST_WRITE_ONLY = int(b'0010000000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_MEM_HOST_READ_ONLY = int(b'0100000000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_MEM_HOST_NO_ACCESS = int(b'1000000000', kind=c_int64_t)

  ! cl_buffer_create_type
  integer(c_int32_t), parameter :: CL_BUFFER_CREATE_TYPE_REGION = int(Z'1220', kind=c_int32_t)

  ! cl_channel_order
  integer(c_int32_t), parameter :: CL_R = int(Z'10B0', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_A = int(Z'10B1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_RG = int(Z'10B2', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_RA = int(Z'10B3', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_RGB = int(Z'10B4', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_RGBA = int(Z'10B5', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_BGRA = int(Z'10B6', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_ARGB = int(Z'10B7', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_INTENSITY = int(Z'10B8', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_LUMINANCE = int(Z'10B9', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_Rx = int(Z'10BA', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_RGx = int(Z'10BB', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_RGBx = int(Z'10BC', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEPTH = int(Z'10BD', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_DEPTH_STENCIL = int(Z'10BE', kind=c_int32_t)

  ! cl_channel_type
  integer(c_int32_t), parameter :: CL_SNORM_INT8 = int(Z'10D0', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_SNORM_INT16 = int(Z'10D1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNORM_INT8 = int(Z'10D2', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNORM_INT16 = int(Z'10D3', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNORM_SHORT_565 = int(Z'10D4', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNORM_SHORT_555 = int(Z'10D5', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNORM_INT_101010 = int(Z'10D6', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_SIGNED_INT8 = int(Z'10D7', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_SIGNED_INT16 = int(Z'10D8', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_SIGNED_INT32 = int(Z'10D9', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNSIGNED_INT8 = int(Z'10DA', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNSIGNED_INT16 = int(Z'10DB', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNSIGNED_INT32 = int(Z'10DC', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_HALF_FLOAT = int(Z'10DD', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_FLOAT = int(Z'10DE', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_UNORM_INT24 = int(Z'10DF', kind=c_int32_t)

  ! cl_mem_object_type
  integer(c_int32_t), parameter :: CL_MEM_OBJECT_BUFFER = int(Z'10F0', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_OBJECT_IMAGE2D = int(Z'10F1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_OBJECT_IMAGE3D = int(Z'10F2', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_OBJECT_IMAGE2D_ARRAY = int(Z'10F3', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_OBJECT_IMAGE1D = int(Z'10F4', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_OBJECT_IMAGE1D_ARRAY = int(Z'10F5', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_OBJECT_IMAGE1D_BUFFER = int(Z'10F6', kind=c_int32_t)

  ! cl_mem_info
  integer(c_int32_t), parameter :: CL_MEM_TYPE = int(Z'1100', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_FLAGS = int(Z'1101', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_SIZE = int(Z'1102', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_HOST_PTR = int(Z'1103', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_MAP_COUNT = int(Z'1104', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_REFERENCE_COUNT = int(Z'1105', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_CONTEXT = int(Z'1106', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_ASSOCIATED_MEMOBJECT = int(Z'1107', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_MEM_OFFSET = int(Z'1108', kind=c_int32_t)

  ! cl_image_info - Note that INFO was added to resolve naming conflicts.
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_FORMAT = int(Z'1110', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_ELEMENT_SIZE = int(Z'1111', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_ROW_PITCH = int(Z'1112', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_SLICE_PITCH = int(Z'1113', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_WIDTH = int(Z'1114', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_HEIGHT = int(Z'1115', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_DEPTH = int(Z'1116', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_ARRAY_SIZE = int(Z'1117', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_BUFFER = int(Z'1118', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_NUM_MIP_LEVELS = int(Z'1119', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_IMAGE_INFO_NUM_SAMPLES = int(Z'111A', kind=c_int32_t)

  ! cl_addressing_mode
  integer(c_int32_t), parameter :: CL_ADDRESS_NONE = int(Z'1130', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_ADDRESS_CLAMP_TO_EDGE = int(Z'1131', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_ADDRESS_CLAMP = int(Z'1132', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_ADDRESS_REPEAT = int(Z'1133', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_ADDRESS_MIRRORED_REPEAT = int(Z'1134', kind=c_int32_t)

  ! cl_filter_mode
  integer(c_int32_t), parameter :: CL_FILTER_NEAREST = int(Z'1140', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_FILTER_LINEAR = int(Z'1141', kind=c_int32_t)

  ! cl_sampler_info
  integer(c_int32_t), parameter :: CL_SAMPLER_REFERENCE_COUNT = int(Z'1150', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_SAMPLER_CONTEXT = int(Z'1151', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_SAMPLER_NORMALIZED_COORDS = int(Z'1152', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_SAMPLER_ADDRESSING_MODE = int(Z'1153', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_SAMPLER_FILTER_MODE = int(Z'1154', kind=c_int32_t)

  ! cl_program_info
  integer(c_int32_t), parameter :: CL_PROGRAM_REFERENCE_COUNT = int(Z'1160', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_CONTEXT = int(Z'1161', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_NUM_DEVICES = int(Z'1162', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_DEVICES = int(Z'1163', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_SOURCE = int(Z'1164', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_BINARY_SIZES = int(Z'1165', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_BINARIES = int(Z'1166', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_NUM_KERNELS = int(Z'1167', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_KERNEL_NAMES = int(Z'1168', kind=c_int32_t)

  ! cl_program_build_info
  integer(c_int32_t), parameter :: CL_PROGRAM_BUILD_STATUS = int(Z'1181', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_BUILD_OPTIONS = int(Z'1182', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_BUILD_LOG = int(Z'1183', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_BINARY_TYPE = int(Z'1184', kind=c_int32_t)

  ! cl_program_binary_type
  integer(c_int32_t), parameter :: CL_PROGRAM_BINARY_TYPE_NONE = int(Z'0', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_BINARY_TYPE_COMPILED_OBJECT = int(Z'1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_BINARY_TYPE_LIBRARY = int(Z'2', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROGRAM_BINARY_TYPE_EXECUTABLE = int(Z'4', kind=c_int32_t)

  ! cl_build_status
  integer(c_int32_t), parameter :: CL_BUILD_SUCCESS = 0
  integer(c_int32_t), parameter :: CL_BUILD_NONE = -1
  integer(c_int32_t), parameter :: CL_BUILD_ERROR = -2
  integer(c_int32_t), parameter :: CL_BUILD_IN_PROGRESS = -3

  ! cl_kernel_info
  integer(c_int32_t), parameter :: CL_KERNEL_FUNCTION_NAME = int(Z'1190', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_NUM_ARGS = int(Z'1191', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_REFERENCE_COUNT = int(Z'1192', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_CONTEXT = int(Z'1193', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_PROGRAM = int(Z'1194', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ATTRIBUTES = int(Z'1195', kind=c_int32_t)

  ! cl_kernel_arg_info
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ADDRESS_QUALIFIER = int(Z'1196', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ACCESS_QUALIFIER = int(Z'1197', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_TYPE_NAME = int(Z'1198', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_TYPE_QUALIFIER = int(Z'1199', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_NAME = int(Z'119A', kind=c_int32_t)

  ! cl_kernel_arg_address_qualifier
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ADDRESS_GLOBAL = int(Z'119B', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ADDRESS_LOCAL = int(Z'119C', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ADDRESS_CONSTANT = int(Z'119D', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ADDRESS_PRIVATE = int(Z'119E', kind=c_int32_t)

  ! cl_kernel_arg_access_qualifier
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ACCESS_READ_ONLY = int(Z'11A0', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ACCESS_WRITE_ONLY = int(Z'11A1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ACCESS_READ_WRITE = int(Z'11A2', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_ARG_ACCESS_NONE = int(Z'11A3', kind=c_int32_t)

  ! cl_kernel_arg_type_qualifer - bitfield (int64)
  integer(c_int64_t), parameter :: CL_KERNEL_ARG_TYPE_NONE = int(b'000', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_KERNEL_ARG_TYPE_CONST = int(b'001', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_KERNEL_ARG_TYPE_RESTRICT = int(b'010', kind=c_int64_t)
  integer(c_int64_t), parameter :: CL_KERNEL_ARG_TYPE_VOLATILE = int(b'100', kind=c_int64_t)

  ! cl_kernel_work_group_info
  integer(c_int32_t), parameter :: CL_KERNEL_WORK_GROUP_SIZE = int(Z'11B0', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_COMPILE_WORK_GROUP_SIZE = int(Z'11B1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_LOCAL_MEM_SIZE = int(Z'11B2', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE = int(Z'11B3', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_PRIVATE_MEM_SIZE = int(Z'11B4', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_KERNEL_GLOBAL_WORK_SIZE = int(Z'11B5', kind=c_int32_t)

  ! cl_event_info
  integer(c_int32_t), parameter :: CL_EVENT_COMMAND_QUEUE = int(Z'11D0', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_EVENT_COMMAND_TYPE = int(Z'11D1', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_EVENT_REFERENCE_COUNT = int(Z'11D2', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_EVENT_COMMAND_EXECUTION_STATUS = int(Z'11D3', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_EVENT_CONTEXT = int(Z'11D4', kind=c_int32_t)

  ! cl_profiling_info
  integer(c_int32_t), parameter :: CL_PROFILING_COMMAND_QUEUED = int(Z'1280', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROFILING_COMMAND_SUBMIT = int(Z'1281', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROFILING_COMMAND_START = int(Z'1282', kind=c_int32_t)
  integer(c_int32_t), parameter :: CL_PROFILING_COMMAND_END = int(Z'1283', kind=c_int32_t)

  interface
    ! ------------
    ! Platform API
    ! ------------

    integer(c_int32_t) function clGetPlatformIDs(num_entries, &
                                                 platforms, num_platforms) &
      bind(C, NAME='clGetPlatformIDs')
      use iso_c_binding

      integer(c_int32_t), value, intent(in)   :: num_entries
      type(c_ptr), value, intent(in)          :: platforms
      integer(c_int32_t), intent(out)         :: num_platforms
    end function

    integer(c_int32_t) function clGetPlatformInfo(platform, param_name, &
                                                  param_value_size, param_value, param_value_size_ret) &
      bind(C, NAME='clGetPlatformInfo')
      use iso_c_binding

      integer(c_intptr_t), value, intent(in)      :: platform
      integer(c_int32_t), value, intent(in)       :: param_name
      integer(c_size_t), value, intent(in)        :: param_value_size
      type(c_ptr), value, intent(in)              :: param_value
      integer(c_size_t), intent(out)              :: param_value_size_ret
    end function

    ! ----------
    ! Device API
    ! ----------
    integer(c_int32_t) function clGetDeviceIDs(platform, &
                                               device_type, &
                                               num_entries, &
                                               devices, &
                                               num_devices) &
      bind(C, NAME='clGetDeviceIDs')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: platform
      integer(c_int64_t), value  :: device_type
      integer(c_int32_t), value  :: num_entries
      type(c_ptr), value         :: devices
      integer(c_int32_t), intent(out) :: num_devices

    end function

    integer(c_int) function clGetDeviceInfo(device, &
                                            param_name, &
                                            param_value_size, &
                                            param_value, &
                                            param_value_size_ret) &
      bind(C, NAME='clGetDeviceInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: device
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    integer(c_int32_t) function clCreateSubDevices(in_device, &
                                                   properties, &
                                                   num_devices, &
                                                   out_devices, &
                                                   num_devices_ret) &
      bind(C, NAME='clCreateSubDevices')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: in_device
      type(c_ptr), value         :: properties
      integer(c_int32_t), value  :: num_devices
      type(c_ptr), value         :: out_devices
      integer(c_int32_t), intent(out) :: num_devices_ret

    end function

    integer(c_int32_t) function clRetainDevice(device) &
      bind(C, NAME='clRetainDevice')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: device
    end function

    integer(c_int32_t) function clReleaseDevice(device) &
      bind(C, NAME='clReleaseDevice')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: device
    end function

    ! ------------
    ! Context APIs
    ! ------------
    integer(c_intptr_t) function clCreateContext(properties, &
                                                 num_devices, &
                                                 devices, &
                                                 pfn_notify, &
                                                 user_data, &
                                                 errcode_ret) &
      bind(C, NAME='clCreateContext')
      use iso_c_binding

      ! Define parameters.
      type(c_ptr), value        :: properties
      integer(c_int32_t), value :: num_devices
      type(c_ptr), value        :: devices
      type(c_funptr), value     :: pfn_notify
      type(c_ptr), value        :: user_data
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_intptr_t) function clCreateContextFromType(properties, &
                                                         device_type, &
                                                         pfn_notify, &
                                                         user_data, &
                                                         errcode_ret) &
      bind(C, NAME='clCreateContextFromType')
      use iso_c_binding

      ! Define parameters.
      type(c_ptr), value        :: properties
      integer(c_int64_t), value :: device_type
      type(c_funptr), value     :: pfn_notify
      type(c_ptr), value        :: user_data
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clRetainContext(context) &
      bind(C, NAME='clRetainContext')
      use iso_c_binding

      integer(c_intptr_t), value :: context

    end function

    integer(c_int32_t) function clReleaseContext(context) &
      bind(C, NAME='clReleaseContext')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context

    end function

    integer(c_int32_t) function clGetContextInfo(context, &
                                                 param_name, &
                                                 param_value_size, &
                                                 param_value, &
                                                 param_value_size_ret) &
      bind(C, NAME='clGetContextInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context
      integer(c_int32_t), value :: param_name
      integer(c_size_t), value :: param_value_size
      type(c_ptr), value :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    ! ------------------
    ! Command Queue APIs
    ! ------------------
    integer(c_intptr_t) function clCreateCommandQueue(context, &
                                                      device, &
                                                      properties, &
                                                      errcode_ret) &
      bind(C, NAME='clCreateCommandQueue')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context
      integer(c_intptr_t), value :: device
      integer(c_int64_t), value  :: properties
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clRetainCommandQueue(command_queue) &
      bind(C, NAME='clRetainCommandQueue')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue

    end function

    integer(c_int32_t) function clReleaseCommandQueue(command_queue) &
      bind(C, NAME='clReleaseCommandQueue')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue

    end function

    integer(c_int32_t) function clGetCommandQueueInfo(command_queue, &
                                                      param_name, &
                                                      param_value_size, &
                                                      param_value, &
                                                      param_value_size_ret) &
      bind(C, NAME='clGetCommandQueueInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    ! ------------------
    ! Memory Object APIs
    ! ------------------
    integer(c_intptr_t) function clCreateBuffer(context, &
                                                flags, &
                                                sizeb, &
                                                host_ptr, &
                                                errcode_ret) &
      bind(C, NAME='clCreateBuffer')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value  :: context
      integer(c_int64_t), value   :: flags
      integer(c_size_t), value    :: sizeb
      type(c_ptr), value          :: host_ptr
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_intptr_t) function clCreateSubBuffer(buffer, &
                                                   flags, &
                                                   buffer_create_type, &
                                                   buffer_create_info, &
                                                   errcode_ret) &
      bind(C, NAME='clCreateSubBuffer')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value  :: buffer
      integer(c_int64_t), value   :: flags
      integer(c_int32_t), value   :: buffer_create_type
      type(c_ptr), value          :: buffer_create_info
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_intptr_t) function clCreateImage(context, &
                                               flags, &
                                               image_format, &
                                               image_desc, &
                                               host_ptr, &
                                               errcode_ret) &
      bind(C, NAME='clCreateImage')
      use iso_c_binding
      use clfortran_types

      ! Define parameters.
      integer(c_intptr_t), value  :: context
      integer(c_int64_t), value   :: flags
      type(cl_image_format)       :: image_format
      type(cl_image_desc)         :: image_desc
      type(c_ptr), value          :: host_ptr
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clRetainMemObject(mem_obj) &
      bind(C, NAME='clRetainMemObject')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value  :: mem_obj

    end function

    integer(c_int32_t) function clReleaseMemObject(mem_obj) &
      bind(C, NAME='clReleaseMemObject')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value  :: mem_obj

    end function

    integer(c_int32_t) function clGetSupportedImageFormats(context, &
                                                           flags, &
                                                           image_type, &
                                                           num_entries, &
                                                           image_formats, &
                                                           num_image_formats) &
      bind(C, NAME='clGetSupportedImageFormats')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value  :: context
      integer(c_int64_t), value   :: flags
      integer(c_int32_t), value   :: image_type
      integer(c_int32_t), value   :: num_entries
      type(c_ptr), value          :: image_formats
      integer(c_int32_t), intent(out) :: num_image_formats

    end function

    integer(c_int32_t) function clGetMemObjectInfo(memobj, &
                                                   param_name, &
                                                   param_value_size, &
                                                   param_value, &
                                                   param_value_size_ret) &
      bind(C, NAME='clGetMemObjectInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: memobj
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    integer(c_int32_t) function clGetImageInfo(image, &
                                               param_name, &
                                               param_value_size, &
                                               param_value, &
                                               param_value_size_ret) &
      bind(C, NAME='clGetImageInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: image
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    integer(c_int32_t) function clSetMemObjectDestructorCallback(memobj, &
                                                                 pfn_notify, &
                                                                 user_data) &
      bind(C, NAME='clSetMemObjectDestructorCallback')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value  :: memobj
      type(c_funptr), value       :: pfn_notify
      type(c_ptr), value          :: user_data

    end function

    ! ------------
    ! Sampler APIs
    ! ------------

    integer(c_intptr_t) function clCreateSampler(context, &
                                                 normalized_coords, &
                                                 addressing_mode, &
                                                 filter_mode, &
                                                 errcode_ret) &
      bind(C, NAME='clCreateSampler')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context
      integer(c_int32_t), value :: normalized_coords
      integer(c_int32_t), value :: addressing_mode
      integer(c_int32_t), value :: filter_mode
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clRetainSampler(sampler) &
      bind(C, NAME='clRetainSampler')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: sampler

    end function

    integer(c_int32_t) function clReleaseSampler(sampler) &
      bind(C, NAME='clReleaseSampler')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: sampler

    end function

    integer(c_int32_t) function clGetSamplerInfo(sampler, &
                                                 param_name, &
                                                 param_value_size, &
                                                 param_value, &
                                                 param_value_size_ret) &
      bind(C, NAME='clGetSamplerInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: sampler
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    ! -------------------
    ! Program Object APIs
    ! -------------------
    integer(c_intptr_t) function clCreateProgramWithSource(context, &
                                                           count, &
                                                           strings, &
                                                           lengths, &
                                                           errcode_ret) &
      bind(C, NAME='clCreateProgramWithSource')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context
      integer(c_int32_t), value :: count
      type(c_ptr), value :: strings
      type(c_ptr), value :: lengths
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_intptr_t) function clCreateProgramWithBinary(context, &
                                                           num_devices, &
                                                           device_list, &
                                                           lengths, &
                                                           binaries, &
                                                           binary_status, &
                                                           errcode_ret) &
      bind(C, NAME='clCreateProgramWithBinary')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context
      integer(c_int32_t), value :: num_devices
      type(c_ptr), value :: device_list
      type(c_ptr), value :: lengths
      type(c_ptr), value :: binaries
      type(c_ptr), value :: binary_status
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_intptr_t) function clCreateProgramWithBuiltInKernels(context, &
                                                                   num_devices, &
                                                                   device_list, &
                                                                   kernel_names, &
                                                                   errcode_ret) &
      bind(C, NAME='clCreateProgramWithBuiltInKernels')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context
      integer(c_int32_t), value :: num_devices
      type(c_ptr), value :: device_list
      type(c_ptr), value :: kernel_names
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clRetainProgram(program) &
      bind(C, NAME='clRetainProgram')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: program

    end function

    integer(c_int32_t) function clReleaseProgram(program) &
      bind(C, NAME='clReleaseProgram')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: program

    end function

    integer(c_int32_t) function clBuildProgram(program, &
                                               num_devices, &
                                               device_list, &
                                               options, &
                                               pfn_notify, &
                                               user_data) &
      bind(C, NAME='clBuildProgram')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: program
      integer(c_int32_t), value :: num_devices
      type(c_ptr), value :: device_list
      type(c_ptr), value :: options
      type(c_funptr), value :: pfn_notify
      type(c_ptr), value :: user_data

    end function

    integer(c_int32_t) function clCompileProgram(program, &
                                                 num_devices, &
                                                 device_list, &
                                                 options, &
                                                 num_input_headers, &
                                                 input_headers, &
                                                 header_include_names, &
                                                 pfn_notify, &
                                                 user_data) &
      bind(C, NAME='clCompileProgram')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: program
      integer(c_int32_t), value :: num_devices
      type(c_ptr), value :: device_list
      type(c_ptr), value :: options
      integer(c_int32_t), value :: num_input_headers
      type(c_ptr), value :: input_headers
      type(c_ptr), value :: header_include_names
      type(c_funptr), value :: pfn_notify
      type(c_ptr), value :: user_data

    end function

    integer(c_intptr_t) function clLinkProgram(context, &
                                               num_devices, &
                                               device_list, &
                                               options, &
                                               num_input_programs, &
                                               input_programs, &
                                               pfn_notify, &
                                               user_data, &
                                               errcode_ret) &
      bind(C, NAME='clLinkProgram')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context
      integer(c_int32_t), value :: num_devices
      type(c_ptr), value :: device_list
      type(c_ptr), value :: options
      integer(c_int32_t), value :: num_input_programs
      type(c_ptr), value :: input_programs
      type(c_funptr), value :: pfn_notify
      type(c_ptr), value :: user_data
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clUnloadPlatformCompiler(platform) &
      bind(C, NAME='clUnloadPlatformCompiler')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: platform

    end function

    integer(c_int32_t) function clGetProgramInfo(program, &
                                                 param_name, &
                                                 param_value_size, &
                                                 param_value, &
                                                 param_value_size_ret) &
      bind(C, NAME='clGetProgramInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: program
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    integer(c_int32_t) function clGetProgramBuildInfo(program, &
                                                      device, &
                                                      param_name, &
                                                      param_value_size, &
                                                      param_value, &
                                                      param_value_size_ret) &
      bind(C, NAME='clGetProgramBuildInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: program
      integer(c_intptr_t), value :: device
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    ! ------------------
    ! Kernel Object APIs
    ! ------------------

    integer(c_intptr_t) function clCreateKernel(program, &
                                                kernel_name, &
                                                errcode_ret) &
      bind(C, NAME='clCreateKernel')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: program
      type(c_ptr), value :: kernel_name
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clCreateKernelsInProgram(program, &
                                                         num_kernels, &
                                                         kernels, &
                                                         num_kernels_ret) &
      bind(C, NAME='clCreateKernelsInProgram')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: program
      integer(c_int32_t), value :: num_kernels
      type(c_ptr), value :: kernels
      integer(c_int32_t), intent(out) :: num_kernels_ret

    end function

    integer(c_int32_t) function clRetainKernel(kernel) &
      bind(C, NAME='clRetainKernel')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: kernel

    end function

    integer(c_int32_t) function clReleaseKernel(kernel) &
      bind(C, NAME='clReleaseKernel')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: kernel

    end function

    integer(c_int32_t) function clSetKernelArg(kernel, &
                                               arg_index, &
                                               arg_size, &
                                               arg_value) &
      bind(C, NAME='clSetKernelArg')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: kernel
      integer(c_int32_t), value :: arg_index
      integer(c_size_t), value :: arg_size
      type(c_ptr), value :: arg_value

    end function

    integer(c_int32_t) function clGetKernelInfo(kernel, &
                                                param_name, &
                                                param_value_size, &
                                                param_value, &
                                                param_value_size_ret) &
      bind(C, NAME='clGetKernelInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: kernel
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    integer(c_int32_t) function clGetKernelArgInfo(kernel, &
                                                   arg_index, &
                                                   param_name, &
                                                   param_value_size, &
                                                   param_value, &
                                                   param_value_size_ret) &
      bind(C, NAME='clGetKernelArgInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: kernel
      integer(c_int32_t), value  :: arg_index
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    integer(c_int32_t) function clGetKernelWorkGroupInfo(kernel, &
                                                         device, &
                                                         param_name, &
                                                         param_value_size, &
                                                         param_value, &
                                                         param_value_size_ret) &
      bind(C, NAME='clGetKernelWorkGroupInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: kernel
      integer(c_intptr_t), value  :: device
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    ! -----------------
    ! Event Object APIs
    ! -----------------

    integer(c_int32_t) function clWaitForEvents(num_events, &
                                                event_list) &
      bind(C, NAME='clWaitForEvents')
      use iso_c_binding

      ! Define parameters.
      integer(c_int32_t), value :: num_events
      type(c_ptr), value :: event_list

    end function

    integer(c_int32_t) function clGetEventInfo(event, &
                                               param_name, &
                                               param_value_size, &
                                               param_value, &
                                               param_value_size_ret) &
      bind(C, NAME='clGetEventInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: event
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    integer(c_intptr_t) function clCreateUserEvent(context, &
                                                   errcode_ret) &
      bind(C, NAME='clCreateUserEvent')
      use iso_c_binding

      ! Define parameters.
      integer(c_int32_t), value :: context
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clRetainEvent(event) &
      bind(C, NAME='clRetainEvent')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: event

    end function

    integer(c_int32_t) function clReleaseEvent(event) &
      bind(C, NAME='clReleaseEvent')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: event

    end function

    integer(c_int32_t) function clSetUserEventStatus(event, &
                                                     execution_status) &
      bind(C, NAME='clSetUserEventStatus')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: event
      integer(c_int32_t), value :: execution_status

    end function

    integer(c_int32_t) function clSetEventCallback(event, &
                                                   command_exec_callback_type, &
                                                   pfn_notify, &
                                                   user_data) &
      bind(C, NAME='clSetEventCallback')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: event
      integer(c_int32_t), value :: command_exec_callback_type
      type(c_funptr), value :: pfn_notify
      type(c_ptr), value :: user_data

    end function

    ! --------------
    ! Profiling APIs
    ! --------------

    integer(c_int32_t) function clGetEventProfilingInfo(event, &
                                                        param_name, &
                                                        param_value_size, &
                                                        param_value, &
                                                        param_value_size_ret) &
      bind(C, NAME='clGetEventProfilingInfo')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: event
      integer(c_int32_t), value  :: param_name
      integer(c_size_t), value   :: param_value_size
      type(c_ptr), value         :: param_value
      integer(c_size_t), intent(out) :: param_value_size_ret

    end function

    ! ---------------------
    ! Flush and Finish APIs
    ! ---------------------

    integer(c_int32_t) function clFlush(command_queue) &
      bind(C, NAME='clFlush')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue

    end function

    integer(c_int32_t) function clFinish(command_queue) &
      bind(C, NAME='clFinish')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue

    end function

    ! ----------------------
    ! Enqueued Commands APIs
    ! ----------------------

    integer(c_int32_t) function clEnqueueReadBuffer(command_queue, &
                                                    buffer, &
                                                    blocking_read, &
                                                    offset, &
                                                    size, &
                                                    ptr, &
                                                    num_events_in_wait_list, &
                                                    event_wait_list, &
                                                    event) &
      bind(C, NAME='clEnqueueReadBuffer')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: buffer
      integer(c_int32_t), value :: blocking_read
      integer(c_size_t), value :: offset
      integer(c_size_t), value :: size
      type(c_ptr), value :: ptr
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueReadBufferRect(command_queue, &
                                                        buffer, &
                                                        blocking_read, &
                                                        buffer_offset, &
                                                        host_offset, &
                                                        region, &
                                                        buffer_row_pitch, &
                                                        buffer_slice_pitch, &
                                                        host_row_pitch, &
                                                        host_slice_pitch, &
                                                        ptr, &
                                                        num_events_in_wait_list, &
                                                        event_wait_list, &
                                                        event) &
      bind(C, NAME='clEnqueueReadBufferRect')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue

      integer(c_intptr_t), value :: buffer
      integer(c_int32_t), value :: blocking_read
      type(c_ptr), value :: buffer_offset
      type(c_ptr), value :: host_offset
      type(c_ptr), value :: region
      integer(c_size_t), value :: buffer_row_pitch
      integer(c_size_t), value :: buffer_slice_pitch
      integer(c_size_t), value :: host_row_pitch
      integer(c_size_t), value :: host_slice_pitch
      type(c_ptr), value :: ptr
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueWriteBuffer(command_queue, &
                                                     buffer, &
                                                     blocking_write, &
                                                     offset, &
                                                     size, &
                                                     ptr, &
                                                     num_events_in_wait_list, &
                                                     event_wait_list, &
                                                     event) &
      bind(C, NAME='clEnqueueWriteBuffer')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: buffer
      integer(c_int32_t), value :: blocking_write
      integer(c_size_t), value :: offset
      integer(c_size_t), value :: size
      type(c_ptr), value :: ptr
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueWriteBufferRect(command_queue, &
                                                         buffer, &
                                                         blocking_write, &
                                                         buffer_offset, &
                                                         host_offset, &
                                                         region, &
                                                         buffer_row_pitch, &
                                                         buffer_slice_pitch, &
                                                         host_row_pitch, &
                                                         host_slice_pitch, &
                                                         ptr, &
                                                         num_events_in_wait_list, &
                                                         event_wait_list, &
                                                         event) &
      bind(C, NAME='clEnqueueWriteBufferRect')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: buffer
      integer(c_int32_t), value :: blocking_write
      type(c_ptr), value :: buffer_offset
      type(c_ptr), value :: host_offset
      type(c_ptr), value :: region
      integer(c_size_t), value :: buffer_row_pitch
      integer(c_size_t), value :: buffer_slice_pitch
      integer(c_size_t), value :: host_row_pitch
      integer(c_size_t), value :: host_slice_pitch
      type(c_ptr), value :: ptr
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueFillBuffer(command_queue, &
                                                    buffer, &
                                                    pattern, &
                                                    pattern_size, &
                                                    offset, &
                                                    size, &
                                                    num_events_in_wait_list, &
                                                    event_wait_list, &
                                                    event) &
      bind(C, NAME='clEnqueueFillBuffer')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: buffer
      type(c_ptr), value :: pattern
      integer(c_size_t), value :: pattern_size
      integer(c_size_t), value :: offset
      integer(c_size_t), value :: size
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueCopyBuffer(command_queue, &
                                                    src_buffer, &
                                                    dst_buffer, &
                                                    src_offset, &
                                                    dst_offset, &
                                                    size, &
                                                    num_events_in_wait_list, &
                                                    event_wait_list, &
                                                    event) &
      bind(C, NAME='clEnqueueCopyBuffer')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: src_buffer
      integer(c_intptr_t), value :: dst_buffer
      integer(c_size_t), value :: src_offset
      integer(c_size_t), value :: dst_offset
      integer(c_size_t), value :: size
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueCopyBufferRect(command_queue, &
                                                        src_buffer, &
                                                        dst_buffer, &
                                                        src_origin, &
                                                        dst_origin, &
                                                        region, &
                                                        src_row_pitch, &
                                                        src_slice_pitch, &
                                                        dst_row_pitch, &
                                                        dst_slice_pitch, &
                                                        num_events_in_wait_list, &
                                                        event_wait_list, &
                                                        event) &
      bind(C, NAME='clEnqueueCopyBufferRect')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: src_buffer
      integer(c_intptr_t), value :: dst_buffer
      type(c_ptr), value :: src_origin
      type(c_ptr), value :: dst_origin
      type(c_ptr), value :: region
      integer(c_size_t), value :: src_row_pitch
      integer(c_size_t), value :: src_slice_pitch
      integer(c_size_t), value :: dst_row_pitch
      integer(c_size_t), value :: dst_slice_pitch
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueReadImage(command_queue, &
                                                   image, &
                                                   blocking_read, &
                                                   origin, &
                                                   region, &
                                                   row_pitch, &
                                                   slice_pitch, &
                                                   ptr, &
                                                   num_events_in_wait_list, &
                                                   event_wait_list, &
                                                   event) &
      bind(C, NAME='clEnqueueReadImage')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: image
      integer(c_int32_t), value :: blocking_read
      type(c_ptr), value :: origin
      type(c_ptr), value :: region
      integer(c_size_t), value :: row_pitch
      integer(c_size_t), value :: slice_pitch
      type(c_ptr), value :: ptr
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueWriteImage(command_queue, &
                                                    image, &
                                                    blocking_write, &
                                                    origin, &
                                                    region, &
                                                    input_row_pitch, &
                                                    input_slice_pitch, &
                                                    ptr, &
                                                    num_events_in_wait_list, &
                                                    event_wait_list, &
                                                    event) &
      bind(C, NAME='clEnqueueWriteImage')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: image
      integer(c_int32_t), value :: blocking_write
      type(c_ptr), value :: origin
      type(c_ptr), value :: region
      integer(c_size_t), value :: input_row_pitch
      integer(c_size_t), value :: input_slice_pitch
      type(c_ptr), value :: ptr
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueFillImage(command_queue, &
                                                   image, &
                                                   fill_color, &
                                                   origin, &
                                                   region, &
                                                   num_events_in_wait_list, &
                                                   event_wait_list, &
                                                   event) &
      bind(C, NAME='clEnqueueFillImage')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: image
      type(c_ptr), value :: fill_color
      type(c_ptr), value :: origin
      type(c_ptr), value :: region
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueCopyImage(command_queue, &
                                                   src_image, &
                                                   dst_image, &
                                                   src_origin, &
                                                   dst_origin, &
                                                   region, &
                                                   num_events_in_wait_list, &
                                                   event_wait_list, &
                                                   event) &
      bind(C, NAME='clEnqueueCopyImage')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: src_image
      integer(c_intptr_t), value :: dst_image
      type(c_ptr), value :: src_origin
      type(c_ptr), value :: dst_origin
      type(c_ptr), value :: region
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueCopyImageToBuffer(command_queue, &
                                                           src_image, &
                                                           dst_buffer, &
                                                           src_origin, &
                                                           region, &
                                                           dst_offset, &
                                                           num_events_in_wait_list, &
                                                           event_wait_list, &
                                                           event) &
      bind(C, NAME='clEnqueueCopyImageToBuffer')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: src_image
      integer(c_intptr_t), value :: dst_buffer
      type(c_ptr), value :: src_origin
      type(c_ptr), value :: region
      integer(c_size_t), value :: dst_offset
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueCopyBufferToImage(command_queue, &
                                                           src_buffer, &
                                                           dst_image, &
                                                           src_offset, &
                                                           dst_origin, &
                                                           region, &
                                                           num_events_in_wait_list, &
                                                           event_wait_list, &
                                                           event) &
      bind(C, NAME='clEnqueueCopyBufferToImage')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: src_buffer
      integer(c_intptr_t), value :: dst_image
      integer(c_size_t), value :: src_offset
      type(c_ptr), value :: dst_origin
      type(c_ptr), value :: region
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    type(c_ptr) function clEnqueueMapBuffer(command_queue, &
                                            buffer, &
                                            blocking_map, &
                                            map_flags, &
                                            offset, &
                                            size, &
                                            num_events_in_wait_list, &
                                            event_wait_list, &
                                            event, &
                                            errcode_ret) &
      bind(C, NAME='clEnqueueMapBuffer')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: buffer
      integer(c_int32_t), value :: blocking_map
      integer(c_int64_t), value :: map_flags
      integer(c_size_t), value :: offset
      integer(c_size_t), value :: size
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    type(c_ptr) function clEnqueueMapImage(command_queue, &
                                           image, &
                                           blocking_map, &
                                           map_flags, &
                                           origin, &
                                           region, &
                                           image_row_pitch, &
                                           image_slice_pitch, &
                                           num_events_in_wait_list, &
                                           event_wait_list, &
                                           event, &
                                           errcode_ret) &
      bind(C, NAME='clEnqueueMapImage')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: image
      integer(c_int32_t), value :: blocking_map
      integer(c_int64_t), value :: map_flags
      type(c_ptr), value :: origin
      type(c_ptr), value :: region
      integer(c_size_t), intent(out) :: image_row_pitch
      integer(c_size_t), intent(out) :: image_slice_pitch
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event
      integer(c_int32_t), intent(out) :: errcode_ret

    end function

    integer(c_int32_t) function clEnqueueUnmapMemObject(command_queue, &
                                                        memobj, &
                                                        mapped_ptr, &
                                                        num_events_in_wait_list, &
                                                        event_wait_list, &
                                                        event) &
      bind(C, NAME='clEnqueueUnmapMemObject')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: memobj
      type(c_ptr), value :: mapped_ptr
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueMigrateMemObjects(command_queue, &
                                                           num_mem_objects, &
                                                           mem_objects, &
                                                           flags, &
                                                           num_events_in_wait_list, &
                                                           event_wait_list, &
                                                           event) &
      bind(C, NAME='clEnqueueMigrateMemObjects')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_int32_t), value :: num_mem_objects
      type(c_ptr), value :: mem_objects
      integer(c_int64_t), value :: flags
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueNDRangeKernel(command_queue, &
                                                       kernel, &
                                                       work_dim, &
                                                       global_work_offset, &
                                                       global_work_size, &
                                                       local_work_size, &
                                                       num_events_in_wait_list, &
                                                       event_wait_list, &
                                                       event) &
      bind(C, NAME='clEnqueueNDRangeKernel')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: kernel
      integer(c_int32_t), value :: work_dim
      type(c_ptr), value :: global_work_offset
      type(c_ptr), value :: global_work_size
      type(c_ptr), value :: local_work_size
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueTask(command_queue, &
                                              kernel, &
                                              num_events_in_wait_list, &
                                              event_wait_list, &
                                              event) &
      bind(C, NAME='clEnqueueTask')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_intptr_t), value :: kernel
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueNativeKernel(command_queue, &
                                                      user_func, &
                                                      args, &
                                                      cb_args, &
                                                      num_mem_objects, &
                                                      mem_list, &
                                                      args_mem_loc, &
                                                      num_events_in_wait_list, &
                                                      event_wait_list, &
                                                      event) &
      bind(C, NAME='clEnqueueNativeKernel')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      type(c_funptr), value :: user_func
      type(c_ptr), value :: args
      integer(c_size_t), value :: cb_args
      integer(c_int32_t), value :: num_mem_objects
      type(c_ptr), value :: mem_list
      type(c_ptr), value :: args_mem_loc
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueMarkerWithWaitList(command_queue, &
                                                            num_events_in_wait_list, &
                                                            event_wait_list, &
                                                            event) &
      bind(C, NAME='clEnqueueMarkerWithWaitList')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clEnqueueBarrierWithWaitList(command_queue, &
                                                             num_events_in_wait_list, &
                                                             event_wait_list, &
                                                             event) &
      bind(C, NAME='clEnqueueBarrierWithWaitList')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: command_queue
      integer(c_int32_t), value :: num_events_in_wait_list
      type(c_ptr), value :: event_wait_list
      type(c_ptr), value :: event

    end function

    integer(c_int32_t) function clSetPrintfCallback(context, &
                                                    pfn_notify, &
                                                    user_data) &
      bind(C, NAME='clSetPrintfCallback')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: context
      type(c_funptr), value :: pfn_notify
      type(c_ptr), value :: user_data

    end function

    ! -------------------------
    ! Extension function access
    ! -------------------------
    type(c_funptr) function clGetExtensionFunctionAddressForPlatform(platform, &
                                                                     func_name) &
      bind(C, NAME='clGetExtensionFunctionAddressForPlatform')
      use iso_c_binding

      ! Define parameters.
      integer(c_intptr_t), value :: platform
      type(c_ptr), value :: func_name

    end function
  
  end interface

  contains

    subroutine getErrorMessage(error_code)
      !< Provide meaningful error messages (rather than just an integer code)
      integer(c_int32_t), intent(in) :: error_code

      select case(error_code)
      case(CL_DEVICE_NOT_FOUND)
        error stop "Error code: CL_DEVICE_NOT_FOUND"
      case(CL_DEVICE_NOT_AVAILABLE)
        error stop "Error code: CL_DEVICE_NOT_AVAILABLE"
      case(CL_COMPILER_NOT_AVAILABLE)
        error stop "Error code: CL_COMPILER_NOT_AVAILABLE"
      case(CL_MEM_OBJECT_ALLOCATION_FAILURE)
        error stop "Error code: CL_MEM_OBJECT_ALLOCATION_FAILURE"
      case(CL_OUT_OF_RESOURCES)
        error stop "Error code: CL_OUT_OF_RESOURCES"
      case(CL_OUT_OF_HOST_MEMORY)
        error stop "Error code: CL_OUT_OF_HOST_MEMORY"
      case(CL_PROFILING_INFO_NOT_AVAILABLE)
        error stop "Error code: CL_PROFILING_INFO_NOT_AVAILABLE"
      case(CL_MEM_COPY_OVERLAP)
        error stop "Error code: CL_MEM_COPY_OVERLAP"
      case(CL_IMAGE_FORMAT_MISMATCH)
        error stop "Error code: CL_IMAGE_FORMAT_MISMATCH"
      case(CL_IMAGE_FORMAT_NOT_SUPPORTED)
        error stop "Error code: CL_IMAGE_FORMAT_NOT_SUPPORTED"
      case(CL_BUILD_PROGRAM_FAILURE)
        error stop "Error code: CL_BUILD_PROGRAM_FAILURE"
      case(CL_MAP_FAILURE)
        error stop "Error code: CL_MAP_FAILURE"
      case(CL_MISALIGNED_SUB_BUFFER_OFFSET)
        error stop "Error code: CL_MISALIGNED_SUB_BUFFER_OFFSET"
      case(CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST)
        error stop "Error code: CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST"
      case(CL_COMPILE_PROGRAM_FAILURE)
        error stop "Error code: CL_COMPILE_PROGRAM_FAILURE"
      case(CL_LINKER_NOT_AVAILABLE)
        error stop "Error code: CL_LINKER_NOT_AVAILABLE"
      case(CL_LINK_PROGRAM_FAILURE)
        error stop "Error code: CL_LINK_PROGRAM_FAILURE"
      case(CL_DEVICE_PARTITION_FAILED)
        error stop "Error code: CL_DEVICE_PARTITION_FAILED"
      case(CL_KERNEL_ARG_INFO_NOT_AVAILABLE)
        error stop "Error code: CL_KERNEL_ARG_INFO_NOT_AVAILABLE"
      case(CL_INVALID_VALUE)
        error stop "Error code: CL_INVALID_VALUE"
      case(CL_INVALID_DEVICE_TYPE)
        error stop "Error code: CL_INVALID_DEVICE_TYPE"
      case(CL_INVALID_PLATFORM)
        error stop "Error code: CL_INVALID_PLATFORM"
      case(CL_INVALID_DEVICE)
        error stop "Error code: CL_INVALID_DEVICE"
      case(CL_INVALID_CONTEXT)
        error stop "Error code: CL_INVALID_CONTEXT"
      case(CL_INVALID_QUEUE_PROPERTIES)
        error stop "Error code: CL_INVALID_QUEUE_PROPERTIES"
      case(CL_INVALID_COMMAND_QUEUE)
        error stop "Error code: CL_INVALID_COMMAND_QUEUE"
      case(CL_INVALID_HOST_PTR)
        error stop "Error code: CL_INVALID_HOST_PTR"
      case(CL_INVALID_MEM_OBJECT)
        error stop "Error code: CL_INVALID_MEM_OBJECT"
      case(CL_INVALID_IMAGE_FORMAT_DESCRIPTOR)
        error stop "Error code: CL_INVALID_IMAGE_FORMAT_DESCRIPTOR"
      case(CL_INVALID_IMAGE_SIZE)
        error stop "Error code: CL_INVALID_IMAGE_SIZE"
      case(CL_INVALID_SAMPLER)
        error stop "Error code: CL_INVALID_SAMPLER"
      case(CL_INVALID_BINARY)
        error stop "Error code: CL_INVALID_BINARY"
      case(CL_INVALID_BUILD_OPTIONS)
        error stop "Error code: CL_INVALID_BUILD_OPTIONS"
      case(CL_INVALID_PROGRAM)
        error stop "Error code: CL_INVALID_PROGRAM"
      case(CL_INVALID_PROGRAM_EXECUTABLE)
        error stop "Error code: CL_INVALID_PROGRAM_EXECUTABLE"
      case(CL_INVALID_KERNEL_NAME)
        error stop "Error code: CL_INVALID_KERNEL_NAME"
      case(CL_INVALID_KERNEL_DEFINITION)
        error stop "Error code: CL_INVALID_KERNEL_DEFINITION"
      case(CL_INVALID_KERNEL)
        error stop "Error code: CL_INVALID_KERNEL"
      case(CL_INVALID_ARG_INDEX)
        error stop "Error code: CL_INVALID_ARG_INDEX"
      case(CL_INVALID_ARG_VALUE)
        error stop "Error code: CL_INVALID_ARG_VALUE"
      case(CL_INVALID_ARG_SIZE)
        error stop "Error code: CL_INVALID_ARG_SIZE"
      case(CL_INVALID_KERNEL_ARGS)
        error stop "Error code: CL_INVALID_KERNEL_ARGS"
      case(CL_INVALID_WORK_DIMENSION)
        error stop "Error code: CL_INVALID_WORK_DIMENSION"
      case(CL_INVALID_WORK_GROUP_SIZE)
        error stop "Error code: CL_INVALID_WORK_GROUP_SIZE"
      case(CL_INVALID_WORK_ITEM_SIZE)
        error stop "Error code: CL_INVALID_WORK_ITEM_SIZE"
      case(CL_INVALID_GLOBAL_OFFSET)
        error stop "Error code: CL_INVALID_GLOBAL_OFFSET"
      case(CL_INVALID_EVENT_WAIT_LIST)
        error stop "Error code: CL_INVALID_EVENT_WAIT_LIST"
      case(CL_INVALID_EVENT)
        error stop "Error code: CL_INVALID_EVENT"
      case(CL_INVALID_OPERATION)
        error stop "Error code: CL_INVALID_OPERATION"
      case(CL_INVALID_GL_OBJECT)
        error stop "Error code: CL_INVALID_GL_OBJECT"
      case(CL_INVALID_BUFFER_SIZE)
        error stop "Error code: CL_INVALID_BUFFER_SIZE"
      case(CL_INVALID_MIP_LEVEL)
        error stop "Error code: CL_INVALID_MIP_LEVEL"
      case(CL_INVALID_GLOBAL_WORK_SIZE)
        error stop "Error code: CL_INVALID_GLOBAL_WORK_SIZE"
      case(CL_INVALID_PROPERTY)
        error stop "Error code: CL_INVALID_PROPERTY"
      case(CL_INVALID_IMAGE_DESCRIPTOR)
        error stop "Error code: CL_INVALID_IMAGE_DESCRIPTOR"
      case(CL_INVALID_COMPILER_OPTIONS)
        error stop "Error code: CL_INVALID_COMPILER_OPTIONS"
      case(CL_INVALID_LINKER_OPTIONS)
        error stop "Error code: CL_INVALID_LINKER_OPTIONS"
      case(CL_INVALID_DEVICE_PARTITION_COUNT)
        error stop "Error code: CL_INVALID_DEVICE_PARTITION_COUNT"
      case(CL_INVALID_PIPE_SIZE)
        error stop "Error code: CL_INVALID_PIPE_SIZE"
      case(CL_INVALID_DEVICE_QUEUE)
        error stop "Error code: CL_INVALID_DEVICE_QUEUE"
      case(CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR)
        error stop "Error code: CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR"
      case(CL_PLATFORM_NOT_FOUND_KHR)
        error stop "Error code: CL_PLATFORM_NOT_FOUND_KHR"
      case(CL_INVALID_D3D10_DEVICE_KHR)
        error stop "Error code: CL_INVALID_D3D10_DEVICE_KHR"
      case(CL_INVALID_D3D10_RESOURCE_KHR)
        error stop "Error code: CL_INVALID_D3D10_RESOURCE_KHR"
      case(CL_D3D10_RESOURCE_ALREADY_ACQUIRED_KHR)
        error stop "Error code: CL_D3D10_RESOURCE_ALREADY_ACQUIRED_KHR"
      case(CL_D3D10_RESOURCE_NOT_ACQUIRED_KHR)
        error stop "Error code: CL_D3D10_RESOURCE_NOT_ACQUIRED_KHR"
      case(CL_INVALID_D3D11_DEVICE_KHR)
        error stop "Error code: CL_INVALID_D3D11_DEVICE_KHR"
      case(CL_INVALID_D3D11_RESOURCE_KHR)
        error stop "Error code: CL_INVALID_D3D11_RESOURCE_KHR"
      case(CL_D3D11_RESOURCE_ALREADY_ACQUIRED_KHR)
        error stop "Error code: CL_D3D11_RESOURCE_ALREADY_ACQUIRED_KHR"
      case(CL_D3D11_RESOURCE_NOT_ACQUIRED_KHR)
        error stop "Error code: CL_D3D11_RESOURCE_NOT_ACQUIRED_KHR"
      case(CL_INVALID_DX9_DEVICE_INTEL)
        error stop "Error code: CL_INVALID_D3D9_DEVICE_NV or CL_INVALID_DX9_DEVICE_INTEL"
      case(CL_INVALID_DX9_RESOURCE_INTEL)
        error stop "Error code: CL_INVALID_D3D9_RESOURCE_NV or CL_INVALID_DX9_RESOURCE_INTEL"
      case(CL_DX9_RESOURCE_ALREADY_ACQUIRED_INTEL)
        error stop "Error code: CL_D3D9_RESOURCE_ALREADY_ACQUIRED_NV or CL_DX9_RESOURCE_ALREADY_ACQUIRED_INTEL"
      case(CL_DX9_RESOURCE_NOT_ACQUIRED_INTEL)
        error stop "Error code: CL_D3D9_RESOURCE_NOT_ACQUIRED_NV or CL_DX9_RESOURCE_NOT_ACQUIRED_INTEL"
      case(CL_EGL_RESOURCE_NOT_ACQUIRED_KHR)
        error stop "Error code: CL_EGL_RESOURCE_NOT_ACQUIRED_KHR"
      case(CL_INVALID_EGL_OBJECT_KHR)
        error stop "Error code: CL_INVALID_EGL_OBJECT_KHR"
      case(CL_INVALID_ACCELERATOR_INTEL)
        error stop "Error code: CL_INVALID_ACCELERATOR_INTEL"
      case(CL_INVALID_ACCELERATOR_TYPE_INTEL)
        error stop "Error code: CL_INVALID_ACCELERATOR_TYPE_INTEL"
      case(CL_INVALID_ACCELERATOR_DESCRIPTOR_INTEL)
        error stop "Error code: CL_INVALID_ACCELERATOR_DESCRIPTOR_INTEL"
      case(CL_ACCELERATOR_TYPE_NOT_SUPPORTED_INTEL)
        error stop "Error code: CL_ACCELERATOR_TYPE_NOT_SUPPORTED_INTEL"
      case(CL_INVALID_VA_API_MEDIA_ADAPTER_INTEL) 	
        error stop "Error code: CL_INVALID_VA_API_MEDIA_ADAPTER_INTEL"
      case(CL_INVALID_VA_API_MEDIA_SURFACE_INTEL) 	
        error stop "Error code: CL_INVALID_VA_API_MEDIA_SURFACE_INTEL"
      case(CL_VA_API_MEDIA_SURFACE_ALREADY_ACQUIRED_INTEL)
        error stop "Error code: CL_VA_API_MEDIA_SURFACE_ALREADY_ACQUIRED_INTEL"
      case(CL_VA_API_MEDIA_SURFACE_NOT_ACQUIRED_INTEL)
        error stop "Error code: CL_VA_API_MEDIA_SURFACE_NOT_ACQUIRED_INTEL"
      case default
        error stop "Uknown error code"
      end select

    end subroutine

end module clfortran
