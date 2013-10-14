# Generic macros for YaST
#
# The module defined the following functions and variables
#
# LIB_INSTALL_DIR - where to install libraries
#                   usually ${CMAKE_INSTALL_PREFIX}/lib or lib64
#
# YAST_PLUGIN_DIR - where YaST plugins, agents etc, go
#                   ${LIB_INSTALL_DIR}/YaST2/plugins
# YAST_IMAGE_DIR
# YAST_DATA_DIR
#
#


#SET( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O3 -Wall -Woverloaded-virtual" )
#SET( CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -g -O3 -Wall" )

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
SET(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})
#SET(CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/share/cmake/Modules ${CMAKE_MODULE_PATH})

# set /usr as default prefix if not set
IF ( DEFINED CMAKE_INSTALL_PREFIX )
  MESSAGE(STATUS "prefix set to ${CMAKE_INSTALL_PREFIX}")
ELSE ( DEFINED CMAKE_INSTALL_PREFIX )
  SET(CMAKE_INSTALL_PREFIX /usr)
  MESSAGE(STATUS "No prefix, set to default /usr")
ENDIF ( DEFINED CMAKE_INSTALL_PREFIX )

# Library
IF ( NOT DEFINED LIB )
  IF (CMAKE_SIZEOF_VOID_P MATCHES "8")
    SET( LIB "lib64" )
  ELSE (CMAKE_SIZEOF_VOID_P MATCHES "8")
    SET( LIB "lib" )
  ENDIF(CMAKE_SIZEOF_VOID_P MATCHES "8")
  SET ( LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}" )
ENDIF ( NOT DEFINED  LIB )
SET ( LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/${LIB}" )
MESSAGE(STATUS "Libraries will be installed in ${LIB_INSTALL_DIR}" )

SET(YAST_PLUGIN_DIR ${LIB_INSTALL_DIR}/YaST2/plugin)
SET(YAST_IMAGE_DIR ${CMAKE_INSTALL_PREFIX}/YaST2/plugin)
SET(YAST_DATA_DIR ${CMAKE_INSTALL_PREFIX}/share/YaST2/data)

IF (NOT DEFINED RPMNAME)
  FILE(READ "${CMAKE_SOURCE_DIR}/RPMNAME" RPMNAME)
  STRING(REPLACE "\n" "" RPMNAME ${RPMNAME})
ENDIF (NOT DEFINED RPMNAME)

MESSAGE(STATUS "package name set to '${RPMNAME}'")
file (STRINGS ${CMAKE_SOURCE_DIR}/VERSION VERSION)

INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

####################################################################
# RPM SPEC                                                         #
####################################################################

MACRO(SPECFILE)
  MESSAGE(STATUS "Writing spec file...")
  
  SET(SPECIN ${CMAKE_SOURCE_DIR}/${PACKAGE}.spec.cmake)
  IF (NOT EXISTS ${SPECIN})
    SET(SPECIN ${CMAKE_SOURCE_DIR}/${PACKAGE}.spec.in)
  ENDIF (NOT EXISTS ${SPECIN})

  # License and Group may be present(new) or missing(old)
  FILE(READ ${SPECIN} SPECIN_S)
  # test only in main package, HEADER is not used for subpackages
  STRING(REGEX REPLACE "\n%package.*" "" SPECIN_S ${SPECIN_S})
  IF(NOT SPECIN_S MATCHES "\nLicense:")
    SET(DEFAULTLICENSE "License:\tGPL")
  ENDIF(NOT SPECIN_S MATCHES "\nLicense:")
  IF(NOT SPECIN_S MATCHES "\nGroup:")
    SET(DEFAULTGROUP "Group:\tSystem/YaST")
  ENDIF(NOT SPECIN_S MATCHES "\nGroup:")

  SET(HEADERCOMMENT
    "#
# spec file for package ${RPMNAME} (Version ${VERSION})
#
# norootforbuild",
    )

  SET(HEADER
"Name:           ${RPMNAME}
Version:        ${VERSION}
Release:        0
${DEFAULTLICENSE}
${DEFAULTGROUP}
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        ${RPMNAME}-${VERSION}.tar.bz2"
    )

  SET(PREP
"%prep
%setup -n ${RPMNAME}-${VERSION}"
    )

  SET(CLEAN
"%clean
rm -rf \"\$RPM_BUILD_ROOT\""
    )

  SET(INSTALL
"%install
make install DESTDIR=\"$RPM_BUILD_ROOT\""
    )

  CONFIGURE_FILE(${SPECIN} ${CMAKE_BINARY_DIR}/package/${PACKAGE}.spec @ONLY)
  MESSAGE(STATUS "I hate you rpm-lint...!!!")
  IF (EXISTS ${CMAKE_SOURCE_DIR}/package/${PACKAGE}-rpmlint.cmake)
    CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/package/${PACKAGE}-rpmlint.cmake ${CMAKE_BINARY_DIR}/package/${PACKAGE}-rpmlintrc @ONLY)
  ENDIF (EXISTS ${CMAKE_SOURCE_DIR}/package/${PACKAGE}-rpmlint.cmake)
ENDMACRO(SPECFILE)

MACRO(PKGCONFGFILE)
  MESSAGE(STATUS "Writing pkg-config file...")
  CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/${PACKAGE}.pc.cmake ${CMAKE_BINARY_DIR}/${PACKAGE}.pc @ONLY)
  INSTALL( FILES ${CMAKE_BINARY_DIR}/${PACKAGE}.pc DESTINATION ${LIB_INSTALL_DIR}/pkgconfig )
ENDMACRO(PKGCONFGFILE)

MACRO(GENERATE_PACKAGING PACKAGE VERSION)
  # The following components are regex's to match anywhere (unless anchored)
  # in absolute path + filename to find files or directories to be excluded
  # from source tarball.
  SET (CPACK_SOURCE_IGNORE_FILES
  #svn files
  "\\\\.svn/"
  "\\\\.cvsignore$"
  # temporary files
  "\\\\.swp$"
  # backup files
  "~$"
  # eclipse files
  "\\\\.cdtproject$"
  "\\\\.cproject$"
  "\\\\.project$"
  "\\\\.settings/"
  # others
  "\\\\.#"
  "/#"
  "/build/"
  "/_build/"
  "/\\\\.git/"
  # used before
  "/CVS/"
  "/\\\\.libs/"
  "/\\\\.deps/"
  "\\\\.o$"
  "\\\\.lo$"
  "\\\\.la$"
  "Makefile\\\\.in$"
  )

  SET(CPACK_PACKAGE_VENDOR "Novell Inc.")
  SET( CPACK_GENERATOR "TBZ2")
  SET( CPACK_SOURCE_GENERATOR "TBZ2")
  SET( CPACK_SOURCE_PACKAGE_FILE_NAME "${PACKAGE}-${VERSION}" )
  INCLUDE(CPack)
  
  SET(PACKAGE ${RPMNAME})
  SPECFILE()
  
  ADD_CUSTOM_TARGET( svncheck
    COMMAND cd $(CMAKE_SOURCE_DIR) && ! LC_ALL=C svn status --show-updates --quiet | grep -v '^Status against revision'
  )

  SET( AUTOBUILD_COMMAND
    COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_BINARY_DIR}/package/*.tar.bz2
    COMMAND ${CMAKE_MAKE_PROGRAM} package_source
    COMMAND ${CMAKE_COMMAND} -E copy ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.bz2 ${CMAKE_BINARY_DIR}/package
    COMMAND ${CMAKE_COMMAND} -E remove ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.bz2
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_SOURCE_DIR}/package/${PACKAGE}.changes" "${CMAKE_BINARY_DIR}/package/${PACKAGE}.changes"
  )
  
  ADD_CUSTOM_TARGET( srcpackage_local
    ${AUTOBUILD_COMMAND}
  )
  
  ADD_CUSTOM_TARGET( srcpackage
    COMMAND ${CMAKE_MAKE_PROGRAM} svncheck
    ${AUTOBUILD_COMMAND}
  )
ENDMACRO(GENERATE_PACKAGING)

macro(y2_add_agent)
  set(name ${ARGV0})
  set(srcs ${ARGV1})
  if(NOT srcs)
     file( GLOB srcs ${CMAKE_CURRENT_SOURCE_DIR}/*.cc )
  endif(NOT srcs)
  add_library(pyag_${name} SHARED ${srcs})
  SET_TARGET_PROPERTIES( pyag_${name} PROPERTIES VERSION 2.0 )
  SET_TARGET_PROPERTIES( pyag_${name} PROPERTIES SOVERSION 2 )
  add_definitions(-DY2LOG=\\\"pyag_${name}\\\")
  install(TARGETS pyag_${name} DESTINATION YAST_PLUGIN_DIR)
endmacro(y2_add_agent)


