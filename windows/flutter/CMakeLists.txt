cmake_minimum_required(VERSION 3.14)

project(flutter_wrapper LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# This file is configured by Flutter's build system.
# It links the Flutter engine library and generates plugin registrant.

# Find Flutter library
find_library(FLUTTER_LIBRARY NAMES flutter_wrapper_plugin flutter_engine
    PATHS "${FLUTTER_ROOT}/bin/cache/artifacts/windows/flutter"
)

if(NOT FLUTTER_LIBRARY)
    message(FATAL_ERROR "Flutter library not found. Run 'flutter pub get' first.")
endif()

# Create an interface library
add_library(flutter_wrapper INTERFACE)
target_link_libraries(flutter_wrapper INTERFACE "${FLUTTER_LIBRARY}")
target_include_directories(flutter_wrapper INTERFACE
    "${FLUTTER_ROOT}/packages/flutter_tools/include"
)

# Generated plugin registrant
set(PLUGIN_REGISTRANT_SOURCES
    "generated_plugin_registrant.cc"
    "generated_plugin_registrant.h"
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/generated_plugin_registrant.cc")
    add_library(flutter_plugin_registrant STATIC
        ${PLUGIN_REGISTRANT_SOURCES}
    )
    target_link_libraries(flutter_plugin_registrant PUBLIC flutter_wrapper)
    target_include_directories(flutter_plugin_registrant PUBLIC
        "${CMAKE_CURRENT_SOURCE_DIR}"
    )
endif()
