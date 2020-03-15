add_library(clfortran clfortran.f90 clfortran_hl.f90)
target_include_directories(clfortran PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(clfortran ${OpenCL_LIBRARY})
