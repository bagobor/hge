
#=============================================================================
# Copyright 2002-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

# determine the compiler to use for Java programs
# NOTE, a generator may set CMAKE_Java_COMPILER before
# loading this file to force a compiler.

if(NOT CMAKE_Java_COMPILER)
  # prefer the environment variable CC
  if($ENV{JAVA_COMPILER} MATCHES ".+")
    get_filename_component(CMAKE_Java_COMPILER_INIT $ENV{JAVA_COMPILER} PROGRAM PROGRAM_ARGS CMAKE_Java_FLAGS_ENV_INIT)
    if(CMAKE_Java_FLAGS_ENV_INIT)
      set(CMAKE_Java_COMPILER_ARG1 "${CMAKE_Java_FLAGS_ENV_INIT}" CACHE STRING "First argument to Java compiler")
    endif()
    if(NOT EXISTS ${CMAKE_Java_COMPILER_INIT})
      message(SEND_ERROR "Could not find compiler set in environment variable JAVA_COMPILER:\n$ENV{JAVA_COMPILER}.")
    endif()
  endif()

  if($ENV{JAVA_RUNTIME} MATCHES ".+")
    get_filename_component(CMAKE_Java_RUNTIME_INIT $ENV{JAVA_RUNTIME} PROGRAM PROGRAM_ARGS CMAKE_Java_FLAGS_ENV_INIT)
    if(NOT EXISTS ${CMAKE_Java_RUNTIME_INIT})
      message(SEND_ERROR "Could not find compiler set in environment variable JAVA_RUNTIME:\n$ENV{JAVA_RUNTIME}.")
    endif()
  endif()

  if($ENV{JAVA_ARCHIVE} MATCHES ".+")
    get_filename_component(CMAKE_Java_ARCHIVE_INIT $ENV{JAVA_ARCHIVE} PROGRAM PROGRAM_ARGS CMAKE_Java_FLAGS_ENV_INIT)
    if(NOT EXISTS ${CMAKE_Java_ARCHIVE_INIT})
      message(SEND_ERROR "Could not find compiler set in environment variable JAVA_ARCHIVE:\n$ENV{JAVA_ARCHIVE}.")
    endif()
  endif()

  set(Java_BIN_PATH
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\JavaSoft\\Java Development Kit\\2.0;JavaHome]/bin"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\JavaSoft\\Java Development Kit\\1.9;JavaHome]/bin"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\JavaSoft\\Java Development Kit\\1.8;JavaHome]/bin"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\JavaSoft\\Java Development Kit\\1.7;JavaHome]/bin"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\JavaSoft\\Java Development Kit\\1.6;JavaHome]/bin"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\JavaSoft\\Java Development Kit\\1.5;JavaHome]/bin"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\JavaSoft\\Java Development Kit\\1.4;JavaHome]/bin"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\JavaSoft\\Java Development Kit\\1.3;JavaHome]/bin"
    $ENV{JAVA_HOME}/bin
    /usr/bin
    /usr/lib/java/bin
    /usr/share/java/bin
    /usr/local/bin
    /usr/local/java/bin
    /usr/local/java/share/bin
    /usr/java/j2sdk1.4.2_04
    /usr/lib/j2sdk1.4-sun/bin
    /usr/java/j2sdk1.4.2_09/bin
    /usr/lib/j2sdk1.5-sun/bin
    /opt/sun-jdk-1.5.0.04/bin
    )
  # if no compiler has been specified yet, then look for one
  if(CMAKE_Java_COMPILER_INIT)
    set(CMAKE_Java_COMPILER ${CMAKE_Java_COMPILER_INIT} CACHE PATH "Java Compiler")
  else()
    find_program(CMAKE_Java_COMPILER
      NAMES javac
      PATHS ${Java_BIN_PATH}
    )
  endif()

  # if no runtime has been specified yet, then look for one
  if(CMAKE_Java_RUNTIME_INIT)
    set(CMAKE_Java_RUNTIME ${CMAKE_Java_RUNTIME_INIT} CACHE PATH "Java Compiler")
  else()
    find_program(CMAKE_Java_RUNTIME
      NAMES java
      PATHS ${Java_BIN_PATH}
    )
  endif()

  # if no archive has been specified yet, then look for one
  if(CMAKE_Java_ARCHIVE_INIT)
    set(CMAKE_Java_ARCHIVE ${CMAKE_Java_ARCHIVE_INIT} CACHE PATH "Java Compiler")
  else()
    find_program(CMAKE_Java_ARCHIVE
      NAMES jar
      PATHS ${Java_BIN_PATH}
    )
  endif()
endif()
mark_as_advanced(CMAKE_Java_COMPILER)

# configure variables set in this file for fast reload later on
configure_file(${CMAKE_ROOT}/Modules/CMakeJavaCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeJavaCompiler.cmake IMMEDIATE @ONLY)
set(CMAKE_Java_COMPILER_ENV_VAR "JAVA_COMPILER")
