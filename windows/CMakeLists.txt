# CMakeLists.txt for the Windows runner of Swallpaper

cmake_minimum_required(VERSION 3.14)

project(swallpaper LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Flutter embedder
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/flutter)

# Runner
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/runner)
