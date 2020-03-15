module clfortran_hl
  !! Summary: Create a high-level interface for Fortran+OpenCL.
  !! Author: Sam Miller
  use iso_c_binding
  use iso_fortran_env, only: std_out => output_unit, std_err => error_unit
  implicit none
  
  private

  type device_context
  end type

contains
  
end module clfortran_hl