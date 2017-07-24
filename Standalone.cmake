cmake_minimum_required(VERSION 2.8)

PROJECT(DARKNET C CXX)

SET(USE_GPU ON)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)
OPTION(BUILD_python "Build Python wrapper" ON)

SET(DARKNET_INCLUDE_DIR ${CMAKE_CURRENT_LIST_DIR}/src)



####################################################################
####################################################################
######           DEFINE LOCAL CMAKE REPO AND TOOLS            ######
####################################################################
####################################################################
IF (DEFINED $ENV{REPO_DIR})
  set(REPO_DIR $ENV{REPO_DIR})
ELSE()
  IF (WIN32)
    set (REPO_DIR $ENV{USERPROFILE}/.repo/)
    string(REPLACE "\\" "/" REPO_DIR ${REPO_DIR})
  ELSE()
    set (REPO_DIR $ENV{HOME}/.repo/)
  ENDIF()
ENDIF()
include(${REPO_DIR}/deps/macros/CMakeLists.txt)
####################################################################
####################################################################



####################################################################
######           DEPENDENCIES                                 ######
####################################################################
#Rapidjon
set(rapidjson_version 0.1)
include(${REPO_DIR}/deps/rapidjson/CMakeLists.txt)






# ---[ Python
if(BUILD_python)
  if(NOT "${python_version}" VERSION_LESS "3.0.0")
    # use python3
    find_package(PythonInterp 3.0)
    find_package(PythonLibs 3.0)
    find_package(NumPy 1.7.1)
    # Find the matching boost python implementation
    set(version ${PYTHONLIBS_VERSION_STRING})
    
    STRING( REPLACE "." "" boost_py_version ${version} )
    find_package(Boost 1.46 COMPONENTS "python-py${boost_py_version}")
    set(Boost_PYTHON_FOUND ${Boost_PYTHON-PY${boost_py_version}_FOUND})
    
    while(NOT "${version}" STREQUAL "" AND NOT Boost_PYTHON_FOUND)
      STRING( REGEX REPLACE "([0-9.]+).[0-9]+" "\\1" version ${version} )
      
      STRING( REPLACE "." "" boost_py_version ${version} )
      find_package(Boost 1.46 COMPONENTS "python-py${boost_py_version}")
      set(Boost_PYTHON_FOUND ${Boost_PYTHON-PY${boost_py_version}_FOUND})
      
      STRING( REGEX MATCHALL "([0-9.]+).[0-9]+" has_more_version ${version} )
      if("${has_more_version}" STREQUAL "")
        break()
      endif()
    endwhile()
    if(NOT Boost_PYTHON_FOUND)
      find_package(Boost 1.46 COMPONENTS python)
    endif()
  else()
    # disable Python 3 search
    find_package(PythonInterp 2.7)
    find_package(PythonLibs 2.7)
    find_package(NumPy 1.7.1)
    find_package(Boost 1.46 COMPONENTS python )
  endif()
  if(PYTHONLIBS_FOUND AND NUMPY_FOUND AND Boost_PYTHON_FOUND)
    set(HAVE_PYTHON TRUE)
    if(BUILD_python_layer)
      add_definitions(-DWITH_PYTHON_LAYER)
      include_directories(SYSTEM ${PYTHON_INCLUDE_DIRS} ${NUMPY_INCLUDE_DIR} ${Boost_INCLUDE_DIRS})
      list(APPEND Caffe_LINKER_LIBS ${PYTHON_LIBRARIES} ${Boost_LIBRARIES})
    endif()
  endif()
endif()




#Cuda
include(cmake/Cuda.cmake)

#test wrapper boost

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

add_subdirectory(../numpy-opencv-converter numpy-opencv-converter)
include_directories(${CMAKE_CURRENT_LIST_DIR}/../numpy-opencv-converter)
include_directories(${OpenCV_INCLUDE_DIRS})


####################################################################
####################################################################
######           SET COMPILLER OPTIONS                        ######
####################################################################
####################################################################
add_definitions(-std=c++0x)

add_definitions(-fPIC)
####################################################################
####################################################################



add_subdirectory(src)
add_subdirectory(python)
add_subdirectory(test)
