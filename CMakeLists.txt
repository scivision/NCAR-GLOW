cmake_minimum_required(VERSION 3.13)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release" FORCE)
endif()

project(GLOW
  LANGUAGES Fortran
  VERSION 0.981)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

add_subdirectory(src/ncarglow)
