# select_library_configurations( basename )
#
# This macro takes a library base name as an argument, and will choose good
# values for basename_LIBRARY, basename_LIBRARIES, basename_LIBRARY_DEBUG, and
# basename_LIBRARY_RELEASE depending on what has been found and set.  If only
# basename_LIBRARY_RELEASE is defined, basename_LIBRARY, basename_LIBRARY_DEBUG,
# and basename_LIBRARY_RELEASE will be set to the release value.  If only
# basename_LIBRARY_DEBUG is defined, then basename_LIBRARY,
# basename_LIBRARY_DEBUG and basename_LIBRARY_RELEASE will take the debug value.
#
# If the generator supports configuration types, then basename_LIBRARY and
# basename_LIBRARIES will be set with debug and optimized flags specifying the
# library to be used for the given configuration.  If no build type has been set
# or the generator in use does not support configuration types, then
# basename_LIBRARY and basename_LIBRARIES will take only the release values.

#=============================================================================
# Copyright 2009 Will Dicharry <wdicharry@stellarscience.com>
# Copyright 2005-2009 Kitware, Inc.
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

# This macro was adapted from the FindQt4 CMake module and is maintained by Will
# Dicharry <wdicharry@stellarscience.com>.

# Utility macro to check if one variable exists while another doesn't, and set
# one that doesn't exist to the one that exists.
macro( _set_library_name basename GOOD BAD )
    if( ${basename}_LIBRARY_${GOOD} AND NOT ${basename}_LIBRARY_${BAD} )
        set( ${basename}_LIBRARY_${BAD} ${${basename}_LIBRARY_${GOOD}} )
        set( ${basename}_LIBRARY ${${basename}_LIBRARY_${GOOD}} )
        set( ${basename}_LIBRARIES ${${basename}_LIBRARY_${GOOD}} )
    endif()
endmacro()

macro( select_library_configurations basename )
    # if only the release version was found, set the debug to be the release
    # version.
    _set_library_name( ${basename} RELEASE DEBUG )
    # if only the debug version was found, set the release value to be the
    # debug value.
    _set_library_name( ${basename} DEBUG RELEASE )

    # Set a default case, which will come into effect if
    # -no build type is set and the generator only supports one build type
    #  at a time (i.e. CMAKE_CONFIGURATION_TYPES is false)
    # -${basename}_LIBRARY_DEBUG and ${basename}_LIBRARY_RELEASE are the same
    # -${basename}_LIBRARY_DEBUG and ${basename}_LIBRARY_RELEASE are both empty
    set( ${basename}_LIBRARY ${${basename}_LIBRARY_RELEASE} )
    set( ${basename}_LIBRARIES ${${basename}_LIBRARY_RELEASE} )

    if( ${basename}_LIBRARY_DEBUG AND ${basename}_LIBRARY_RELEASE AND
           NOT ${basename}_LIBRARY_DEBUG STREQUAL ${basename}_LIBRARY_RELEASE )
        # if the generator supports configuration types or CMAKE_BUILD_TYPE
        # is set, then set optimized and debug options.
        if( CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE )
            set( ${basename}_LIBRARY )
            foreach( _libname IN LISTS ${basename}_LIBRARY_RELEASE )
                list( APPEND ${basename}_LIBRARY optimized "${_libname}" )
            endforeach()
            foreach( _libname IN LISTS ${basename}_LIBRARY_DEBUG )
                list( APPEND ${basename}_LIBRARY debug "${_libname}" )
            endforeach()
            set( ${basename}_LIBRARIES "${${basename}_LIBRARY}" )
        endif()
    endif()

    set( ${basename}_LIBRARY ${${basename}_LIBRARY} CACHE FILEPATH
        "The ${basename} library" )

    if( ${basename}_LIBRARY )
        set( ${basename}_FOUND TRUE )
    endif()

    mark_as_advanced( ${basename}_LIBRARY
        ${basename}_LIBRARY_RELEASE
        ${basename}_LIBRARY_DEBUG
    )
endmacro()
