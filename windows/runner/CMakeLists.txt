cmake_minimum_required(VERSION 3.14)

project(runner LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Application source files
set(APP_SOURCES
    "main.cpp"
    "flutter_window.cpp"
    "flutter_window.h"
    "run_loop.cpp"
    "run_loop.h"
)

add_executable(${BINARY_NAME} WIN32
    ${APP_SOURCES}
    "Runner.rc"
    "resource.h"
)

# Link to Flutter DLL
target_link_libraries(${BINARY_NAME} PRIVATE flutter_wrapper)

# Include directories
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")

# Windows-specific
target_compile_definitions(${BINARY_NAME} PRIVATE NOMINMAX)

# Set application icon
set(APP_ICON "${CMAKE_CURRENT_SOURCE_DIR}/../resources/app_icon.ico")
if(EXISTS "${APP_ICON}")
    target_sources(${BINARY_NAME} PRIVATE "${APP_ICON}")
endif()

# Install the executable
install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}")
