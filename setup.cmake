
# this script must be used to start project,
# usage: cmake -Dproject_name=<name> -P setup.cmake

cmake_minimum_required(VERSION 3.24)

# validate inputs

if(NOT DEFINED project_name)
    message(FATAL_ERROR "Usage: cmake -Dproject_name=<name> -P setup.cmake. NOTE ORDER. -D args must be before -P")
endif()

message(STATUS "Setting up project '${project_name}'")

# replacing project name placeholder to project name

function(replace_in_files dir NEEDLE REPLACE_VALUE)
    file(GLOB_RECURSE all_files
        "${dir}/*"
    )
    foreach(file_path IN LISTS all_files)
        if(IS_DIRECTORY "${file_path}")
            continue()
        endif()
        file(READ "${file_path}" file_content)
        string(REPLACE "${NEEDLE}" "${REPLACE_VALUE}" new_content "${file_content}")
        if(NOT "${file_content}" STREQUAL "${new_content}")
            file(WRITE "${file_path}" "${new_content}")
        endif()
    endforeach()
endfunction()

# creating CMakePresets.json

set(presets_content [[
{
    "version": 3,
    "configurePresets": [
        {
            "name": "reldbg",
            "displayName": "RelWithDebInfo",
            "description": "",
            "generator": "Ninja",
            "binaryDir": "${sourceDir}/build_reldbg",
            "cacheVariables": {
                "CMAKE_BUILD_TYPE": "RelWithDebInfo",
                "CMAKE_EXPORT_COMPILE_COMMANDS": "1",
                "CMAKE_POLICY_VERSION_MINIMUM": "3.5",
                "KELBON_TEMPLATE_PROJECT_NAME_ENABLE_TESTING": "1"
            },
            "environment": {}
        },
        {
            "name": "release",
            "displayName": "Release",
            "description": "",
            "generator": "Ninja",
            "binaryDir": "${sourceDir}/build_release",
            "cacheVariables": {
                "CMAKE_BUILD_TYPE": "Release",
                "CMAKE_EXPORT_COMPILE_COMMANDS": "1",
                "CMAKE_POLICY_VERSION_MINIMUM": "3.5",
                "KELBON_TEMPLATE_PROJECT_NAME_ENABLE_TESTING": "1"
            },
            "environment": {}
        },
        {
            "name": "debug",
            "displayName": "Debug",
            "description": "",
            "generator": "Ninja",
            "binaryDir": "${sourceDir}/build",
            "cacheVariables": {
                "CMAKE_BUILD_TYPE": "Debug",
                "CMAKE_EXPORT_COMPILE_COMMANDS": "1",
                "CMAKE_POLICY_VERSION_MINIMUM": "3.5",
                "KELBON_TEMPLATE_PROJECT_NAME_ENABLE_TESTING": "1"
            },
            "environment": {}
        }
    ]
}
]])
file(WRITE "${CMAKE_CURRENT_LIST_DIR}/CMakePresets.json" "${presets_content}")

# replace after creating configurePresets

replace_in_files(${CMAKE_CURRENT_LIST_DIR} "KELBON_TEMPLATE_PROJECT_NAME" "${project_name}")

# create include/libname dir

file(RENAME "include/KELBON_TEMPLATE_PROJECT_NAME" "include/${project_name}" NO_REPLACE)

# rm .git (clearing info about template repository) for allowing user git init

if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/.git")
    file(REMOVE_RECURSE "${CMAKE_CURRENT_LIST_DIR}/.git")
endif()

# print instruction

message(STATUS
"Project '${project_name}' is ready!\n\n"
"1. to start new repo use git init\n"
"2. for building project use cmake . --preset=debug|release|reldbg\n"
)

# rm script itself
file(REMOVE "${CMAKE_CURRENT_LIST_DIR}/setup.cmake")
