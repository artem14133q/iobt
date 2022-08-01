cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(iobt VERSION 1.0.0)

set(STATIC_LIB ${PROJECT_NAME}_static)
set(SHARED_LIB ${PROJECT_NAME}_shared)

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
        src/iobt.h
        src/iobtTypes.h)


set(OUTPUT_BIN_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(OUTPUT_LIB_DIRECTORY "${OUTPUT_BIN_DIRECTORY}/${PROJECT_NAME}")

set(OUTPUT_SHARED_LIB_DIRECTORY "${OUTPUT_BIN_DIRECTORY}/${PROJECT_NAME}/shared")
set(OUTPUT_STATIC_LIB_DIRECTORY "${OUTPUT_BIN_DIRECTORY}/${PROJECT_NAME}/static")

set(STATIC_LIB_PREFIX "lib")
set(STATIC_LIB_FULL_PATH ${OUTPUT_STATIC_LIB_DIRECTORY}/${STATIC_LIB_PREFIX}${PROJECT_NAME}.${PROJECT_VERSION}.a)

# ==================================================================
# CONFIGURE CMAKE
# ==================================================================

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-sized-deallocation -Wall -Wextra -pedantic -fvisibility=hidden")

# ==================================================================
# SET OUTPUT BINARY FILES DIRS
# ==================================================================

foreach(FILE IN LISTS COPY_FILES)
    file(COPY ${FILE} DESTINATION ${OUTPUT_LIB_DIRECTORY}/headers)
endforeach()

include_directories(${CMAKE_BINARY_DIR})

# =====================================================================
# CREATE SHARED LIB
# =====================================================================

add_library(${SHARED_LIB} SHARED ${RESOURCES})

set_target_properties(${PROJECT_NAME}_shared
        PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_SHARED_LIB_DIRECTORY}
        VERSION ${PROJECT_VERSION}
        SOVERSION ${PROJECT_VERSION_MAJOR}
        OUTPUT_NAME ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME}_shared PUBLIC ${INCLUDE_DIRECTORIES})
target_link_libraries(${PROJECT_NAME}_shared ${INCLUDE_PROJECT_LIBS})

# ====================================================================
# CREATE STATIC LIB
# ====================================================================

function(create_symlink target input_file output_file)
    add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E create_symlink
            ${input_file}
            ${output_file})
endfunction()

add_library(${STATIC_LIB} STATIC ${RESOURCES} ${INCLUDE_DIRECTORIES})

set_target_properties(${STATIC_LIB}
        PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_STATIC_LIB_DIRECTORY}
        ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_STATIC_LIB_DIRECTORY}
        OUTPUT_NAME ${PROJECT_NAME}
        SUFFIX ".${PROJECT_VERSION}.a")

target_include_directories(${STATIC_LIB} PUBLIC ${INCLUDE_DIRECTORIES})
target_link_libraries(${PROJECT_NAME}_static ${INCLUDE_PROJECT_LIBS})

create_symlink(${STATIC_LIB}
        ${STATIC_LIB_FULL_PATH}
        ${OUTPUT_STATIC_LIB_DIRECTORY}/${STATIC_LIB_PREFIX}${PROJECT_NAME}.${PROJECT_VERSION_MAJOR}.a)

create_symlink(${STATIC_LIB}
        ${STATIC_LIB_FULL_PATH}
        ${OUTPUT_STATIC_LIB_DIRECTORY}/${STATIC_LIB_PREFIX}${PROJECT_NAME}.a)

# ====================================================================
# CREATE ARCHIVE
# ====================================================================

add_custom_command(TARGET ${STATIC_LIB} ${SHARED_LIB} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E tar cfv "${PROJECT_NAME}.zip" --format=zip ${OUTPUT_LIB_DIRECTORY}
        WORKING_DIRECTORY ${OUTPUT_BIN_DIRECTORY})