if(NOT HAVE_PYTHON)
  message(STATUS "Python interface is disabled or not all required dependecies found. Building without it...")
  return()
endif()


SET(Darknet_LINK darknetLib)

include_directories(${PYTHON_INCLUDE_DIRS} ${NUMPY_INCLUDE_DIR} ${Boost_INCLUDE_DIRS} ${NUMPY-OPENCV-CONVERTER_INCLUDE_DIR} ${OpenCV_INCLUDE_DIR} ${RAPIDJSON_INCLUDE_DIR})
include_directories(${DARKNET_INCLUDE_DIR})
file(GLOB_RECURSE python_srcs ${PROJECT_SOURCE_DIR}/python/*.cpp)

add_library(pydarknet SHARED ${python_srcs})


link_directories(${OpenCV_LIB_DIR})

target_link_libraries(pydarknet ${Darknet_LINK} ${PYTHON_LIBRARIES} ${Boost_LIBRARIES} ${Darknet_LINKER_LIBS} ${CUDA_LIBRARIES} ${OpenCV_LIBRARIES})


if(UNIX OR APPLE)
    set(__linkname "${PROJECT_SOURCE_DIR}/python/darknet/libpydarknet.so")
    add_custom_command(TARGET pydarknet POST_BUILD
                       COMMAND ln -sf $<TARGET_LINKER_FILE:pydarknet> "${__linkname}"
                       COMMENT "Creating symlink ${__linkname} -> ${PROJECT_BINARY_DIR}/lib/_darknet${darknet_POSTFIX}.so")
endif()

# ---[ Install
file(GLOB files1 *.py requirements.txt)
install(FILES ${files1} DESTINATION python)

file(GLOB files2 darknet/*.py)
install(FILES  ${files2} DESTINATION python/darknet)
install(TARGETS pydarknet  DESTINATION python/darknet)




