

message("DIR: ${CUDA_INCLUDE_DIRS}")

include_directories(${CMAKE_CURRENT_LIST_DIR}/../src ${OpenCV_INCLUDE_DIR} ${RAPIDJSON_INCLUDE_DIR} ${CUDA_INCLUDE_DIRS})
add_executable(darknetTest main.cpp)

target_link_libraries(darknetTest darknetLib pthread m ${Darknet_LINKER_LIBS} ${CUDA_LIBRARIES} ${OpenCV_LIBRARIES} cudart cublas curand)
