cmake_minimum_required(VERSION 3.10)
project(cross_build)

set(CMAKE_CXX_STANDARD 11)

include_directories(${PROJECT_SOURCE_DIR}/include)

add_library(hello SHARED src/hello.cpp)