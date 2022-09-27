cmake_minimum_required(VERSION 3.0.0)
project(yolov5_deepsort VERSION 0.1.0)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wl,--allow-shlib-undefined")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wl,--allow-shlib-undefined -g")

# Set Compiler

set(GCC_COMPILER  aarch64-linux-gnu)
set (CMAKE_C_COMPILER ${GCC_COMPILER}-gcc)
set (CMAKE_CXX_COMPILER ${GCC_COMPILER}-g++)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/build/bin)

# install target and libraries
set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/install)

set(CMAKE_SKIP_INSTALL_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

# rknn api
set(RKNN_RT_LIB 3rdparty/librknn_api/aarch64/librknnrt.so)
include_directories(3rdparty/librknn_api/include)
include_directories(${CMAKE_SOURCE_DIR}/3rdparty)


add_subdirectory(deepsort)

# set(OpenCV_DIR /home/linaro/workspace/opencv/lib/cmake/opencv4)  # 填入OpenCVConfig.cmake
# find_package(OpenCV 4 REQUIRED)
# include_directories(${OpenCV_INCLUDE_DIRS})

# opencv
find_package(OpenCV 4 REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

# find_package(Rga REQUIRED)
# include_directories(${OpenCV_INCLUDE_DIRS})
# include_directories(${OpenCV_INCLUDE_DIRS})

set(
    include_libs  
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/yolov5/include
    ${PROJECT_SOURCE_DIR}/deepsort/include
    ${PROJECT_SOURCE_DIR}/3rdparty/librknn_api/include
    ${PROJECT_SOURCE_DIR}/3rdparty/rga/include
    ${PROJECT_SOURCE_DIR}/3rdparty/Eigen
)

include_directories(${include_libs})

aux_source_directory(${PROJECT_SOURCE_DIR}/yolov5/src YOLO_SRC_DIR)
aux_source_directory(${PROJECT_SOURCE_DIR}/src YOLO_SRC_DIR)
add_executable(yolov5_deepsort yolov5_deepsort.cpp ${YOLO_SRC_DIR})

set(CMAKE_INSTALL_RPATH "lib")

# 添加动态链接库
set(
    dynamic_libs  pthread
    ${PROJECT_SOURCE_DIR}/3rdparty/librknn_api/aarch64/librknnrt.so
    ${PROJECT_SOURCE_DIR}/3rdparty/rga/lib/librga.so
)

# # 开启调试选项
# add_definitions("-g")

target_link_libraries(yolov5_deepsort ${OpenCV_LIBS})
target_link_libraries(yolov5_deepsort ${dynamic_libs} deepsort)

# install target and libraries
set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/install)
install(TARGETS yolov5_deepsort DESTINATION ./)

install(PROGRAMS ${RKNN_RT_LIB} DESTINATION lib)
install(PROGRAMS ${RGA_LIB} DESTINATION lib)
install(DIRECTORY model DESTINATION ./)