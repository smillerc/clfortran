cmake_minimum_required(VERSION 3.8)

project(
  clfortran
  DESCRIPTION "A modern Fortran-OpenCL interface"
  HOMEPAGE_URL "https://github.com/smillerc/fortrancl"
  LANGUAGES Fortran C
  VERSION 0.1.0)

set(CMAKE_VERBOSE_MAKEFILE "Off")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

cmake_policy(SET CMP0074 NEW)

# Add the cmake folder for helper scripts
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# set output paths for modules, archives, and executables
set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/include)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# if build type not specified, default to release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
endif()
message(STATUS "CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE}")

find_package(OpenCL 1.2 REQUIRED)

# Host information There is much more info available with this query, but for
# now only get the host name
cmake_host_system_information(RESULT HOST_NAME QUERY HOSTNAME)

# Insert the git version information into the version.h header file See
# https://goo.gl/697j8v (short stackoverflow link)
include(GetGitRevisionDescription)
get_git_head_revision(GIT_REFSPEC GIT_SHA1)
git_local_changes(GIT_LOCAL_CHANGES)

# This takes variables like HOST_NAME, CMAKE_Fortran_COMPILER_VERSION, etc, and
# includes it in the draco build
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/include/version.h.in"
               "${CMAKE_CURRENT_BINARY_DIR}/generated/version.h" @ONLY)

# Include the newly generated version.h file
include_directories(${CMAKE_BINARY_DIR}/generated)

set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g -fbacktrace")

# if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)

#   list(APPEND CMAKE_Fortran_FLAGS "-cpp -std=f2018 -ffree-line-length-none")
#   set(CMAKE_Fortran_FLAGS_DEBUG
#       "-O0 -g
#  -Wall -Wextra -Wpedantic\
#  -Wconversion \
#  -fimplicit-none -fbacktrace \
#  -fcheck=all -ffpe-trap=zero,overflow,invalid,underflow -finit-real=nan")

#   set(CMAKE_Fortran_FLAGS_RELEASE "-O3")

#   if(ENABLE_PROFILING)
#     set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -pg -g")
#   endif(ENABLE_PROFILING)

# endif()

# # compiler flags for ifort
# if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
#   if(CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 19.0.3)
#     list(
#       APPEND CMAKE_Fortran_FLAGS "-fpp -stand f15 -diag-disable 5268 -diag-disable 8770"
#     )
#   else()
#     list(
#       APPEND CMAKE_Fortran_FLAGS  "-fpp -stand f18 -diag-disable 5268 -diag-disable 8770"
#     )
#   endif()
# endif()

add_subdirectory(src)

if(NOT ENABLE_TESTING)
  set(ENABLE_TESTING Off)
endif()

if(ENABLE_TESTING)
  enable_testing()
  add_subdirectory(tests)
endif()
