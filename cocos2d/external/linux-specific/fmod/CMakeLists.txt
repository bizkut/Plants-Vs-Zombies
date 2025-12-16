cmake_minimum_required(VERSION 3.6)

set(lib_name fmod)
set(target_name ext_${lib_name})

project(${lib_name})

add_library(${target_name} SHARED IMPORTED GLOBAL)

# FMOD for ARM64 uses a stub library (audio disabled but game runs)
if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64" OR CMAKE_SYSTEM_PROCESSOR MATCHES "arm64")
    set_target_properties(${target_name} PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include"
      IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/prebuilt/arm64/lib${lib_name}.so"
    )
    message(STATUS "FMOD: Using real library for ARM64 (audio enabled)")
else()
    set_target_properties(${target_name} PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include"
      IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/prebuilt/64-bit/lib${lib_name}.so"
    )
endif()

