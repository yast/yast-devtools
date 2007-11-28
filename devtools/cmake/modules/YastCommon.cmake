#SET( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O3 -Wall -Woverloaded-virtual" )
#SET( CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -g -O3 -Wall" )

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
SET(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})
#SET(CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/share/cmake/Modules ${CMAKE_MODULE_PATH})

IF (NOT DEFINED RPMNAME)
  FILE(READ "${CMAKE_SOURCE_DIR}/RPMNAME" RPMNAME)
ENDIF (NOT DEFINED RPMNAME)

MESSAGE(STATUS "package name set to '${RPMNAME}'")
INCLUDE(${CMAKE_SOURCE_DIR}/VERSION.cmake)
SET ( VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}" )

####################################################################
# RPM SPEC                                                         #
####################################################################
MESSAGE(STATUS "Writing spec file...")

SET(HEADER-COMMENT
"#
# spec file for package ${RPMNAME} (Version ${VERSION})
#
# norootforbuild",
#"/work/built/info/failed/
)

SET(HEADER
"Name:           ${RPMNAME}
Version:        ${VERSION}
Release:        0
License:        GPL
Group:          System/YaST
BuildRoot:      %{_tmppath}/%{name}-%{version}-build\n
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

CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/${RPMNAME}.spec.in ${CMAKE_BINARY_DIR}/package/${RPMNAME}.spec @ONLY)
####################################################################

SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "-")
SET(CPACK_PACKAGE_VENDOR "-")
SET(CPACK_PACKAGE_VERSION_MAJOR ${VERSION_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${VERSION_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${VERSION_PATCH})

SET( CPACK_GENERATOR "TBZ2")
SET( CPACK_SOURCE_GENERATOR "TBZ2")
SET( CPACK_SOURCE_PACKAGE_FILE_NAME "${RPMNAME}-${VERSION}" )

# The following components are regex's to match anywhere (unless anchored)
# in absolute path + filename to find files or directories to be excluded
# from source tarball.
SET (CPACK_SOURCE_IGNORE_FILES
"/CVS/;/.svn/;/.libs/;/.deps/;.swp$;.#;/#;/build/"
"~$"
"\\\\.cvsignore$"
"/package"
"Makefile\\\\.in$"
)
INCLUDE(CPack)

INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

ADD_CUSTOM_TARGET( svncheck
  COMMAND cd $(CMAKE_SOURCE_DIR) && ! LC_ALL=C svn status --show-updates --quiet | grep -v '^Status against revision'
)

SET( AUTOBUILD_COMMAND
  COMMAND ${CMAKE_MAKE_PROGRAM} package_source
  COMMAND ${CMAKE_COMMAND} -E copy ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.bz2 ${CMAKE_BINARY_DIR}/package
  COMMAND ${CMAKE_COMMAND} -E remove ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.bz2
  COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_SOURCE_DIR}/package/${RPMNAME}.changes" "${CMAKE_BINARY_DIR}/package/${RPMNAME}.changes"
)

ADD_CUSTOM_TARGET( srcpackage_local
  ${AUTOBUILD_COMMAND}
)

ADD_CUSTOM_TARGET( srcpackage
  COMMAND ${CMAKE_MAKE_PROGRAM} svncheck
  ${AUTOBUILD_COMMAND}
)


