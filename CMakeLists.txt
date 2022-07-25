cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(iobt VERSION 1.0.0)

# ====================================================================
# DEFINES
# ====================================================================

set(RESOURCES
        src/iobt.h src/iobt.m
        src/tools.h src/tools.m

        src/DeviceInquiryRunLoopStopper.h
        src/DeviceNotificationRunLoopStopper.h
        src/DevicePairDelegate.h

        src/iobtTypes.h)

set(INCLUDE_PROJECT_LIBS
        "-framework Foundation"
        "-framework IOBluetooth")

set(COPY_FILES
        src/iobt.h)

# ==================================================================
# CONFIGURE CMAKE
# ==================================================================

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-sized-deallocation -Wall -Wextra -pedantic -fvisibility=hidden")

# ==================================================================
# SET OUTPUT BINARY FILES DIRS
# ==================================================================

foreach(FILE IN LISTS COPY_FILES)
    file(COPY ${FILE} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/lib)
endforeach()

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

include_directories(${CMAKE_BINARY_DIR})

# =====================================================================
# DEFINE RESOURCE FILES OF YOUR PROJECT
# =====================================================================

add_library(${PROJECT_NAME} SHARED ${RESOURCES})

# ====================================================================
# INSTALL TARGETS FOR COMPILED RESOURCES
# ====================================================================

target_include_directories(${PROJECT_NAME} PUBLIC ${INCLUDE_DIRECTORIES})

# ====================================================================
# DEFILE LIBS OF YOUR PROJECT
# ====================================================================

target_link_libraries(${PROJECT_NAME} ${INCLUDE_PROJECT_LIBS})