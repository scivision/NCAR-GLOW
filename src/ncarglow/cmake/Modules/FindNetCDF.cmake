# based on: https://github.com/Kitware/VTK/blob/master/CMake/FindNetCDF.cmake
# in general, NetCDF requires C compiler, even if only using Fortran

function(netcdf_c)

if(NOT CMAKE_C_COMPILER)
  return()
endif()

pkg_check_modules(NCDF netcdf)  # C / CXX

find_path(NetCDF_INCLUDE_DIR
  NAMES netcdf.h
  HINTS ${NCDF_INCLUDE_DIRS}
  DOC "NetCDF include directories")

if(NOT NetCDF_INCLUDE_DIR)
  return()
endif()

find_library(NetCDF_C_LIBRARY
  NAMES netcdf
  HINTS ${NCDF_LIBRARY_DIRS} ${NCDF_LIBDIR}
  DOC "NetCDF C library")

if(NOT NetCDF_C_LIBRARY)
  return()
endif()

include(CheckSymbolExists)
set(CMAKE_REQUIRED_INCLUDES ${NetCDF_INCLUDE_DIR})
set(CMAKE_REQUIRED_LIBRARIES ${NetCDF_C_LIBRARY})
check_symbol_exists(nc_open netcdf.h _ncdf_symb)

if(_ncdf_symb)
  set(NetCDF_C_FOUND true PARENT_SCOPE)
  set(NetCDF_INCLUDE_DIR ${NetCDF_INCLUDE_DIR} PARENT_SCOPE)
  set(NetCDF_LIBRARY ${NetCDF_C_LIBRARY} PARENT_SCOPE)
endif()
endfunction()


function(netcdf_fortran)

if(NOT CMAKE_Fortran_COMPILER)
  return()
endif()

pkg_check_modules(NCDFF netcdf-fortran)  # Fortran

find_library(NetCDF_Fortran_LIBRARY
  NAMES netcdff
  HINTS ${NCDFF_LIBRARY_DIRS} ${NCDFF_LIBDIR}
  DOC "NetCDF Fortran library")

if(NOT NetCDF_Fortran_LIBRARY)
  return()
endif()

set(NetCDF_LIBRARY ${NetCDF_Fortran_LIBRARY} ${NetCDF_LIBRARY})
set(CMAKE_REQUIRED_INCLUDES ${NetCDF_INCLUDE_DIR})
set(CMAKE_REQUIRED_LIBRARIES ${NetCDF_LIBRARY})
include(CheckFortranFunctionExists)
check_fortran_function_exists(nf90_open _ncdff_func)

if(_ncdff_func)
include(CheckFortranSourceCompiles)
check_fortran_source_compiles("use netcdf; end" _ncdff_comp SRC_EXT f90)
endif()

if(_ncdff_comp)
  set(NetCDF_Fortran_FOUND true PARENT_SCOPE)
  set(NetCDF_LIBRARY ${NetCDF_LIBRARY} PARENT_SCOPE)
endif()
endfunction()

#============================================================
find_package(PkgConfig)

netcdf_c()

if(NetCDF_LIBRARY AND Fortran IN_LIST NetCDF_FIND_COMPONENTS)
  netcdf_fortran()
endif()
mark_as_advanced(NetCDF_LIBRARY NetCDF_INCLUDE_DIR)


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NetCDF
  REQUIRED_VARS NetCDF_LIBRARY NetCDF_INCLUDE_DIR
  HANDLE_COMPONENTS)

if(NetCDF_FOUND)
  set(NetCDF_INCLUDE_DIRS ${NetCDF_INCLUDE_DIR})
  set(NetCDF_LIBRARIES ${NetCDF_LIBRARY})
endif()
