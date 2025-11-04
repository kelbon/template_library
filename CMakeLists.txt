cmake_minimum_required(VERSION 3.20)
project(KELBON_TEMPLATE_PROJECT_NAME)

include(cmake/deps.cmake)

option(KELBON_TEMPLATE_PROJECT_NAME_ENABLE_TESTING "enables testing" OFF)
option(KELBON_TEMPLATE_PROJECT_NAME_ENABLE_ASAN "build ASAN (for CI)" OFF)
option(KELBON_TEMPLATE_PROJECT_NAME_ENABLE_UBSAN "build UNSAN (for CI)" OFF)

add_library(KELBON_TEMPLATE_PROJECT_NAMElib STATIC
    # add new .cpp files here. GLOB for libraries is bad practice  
    src/common.cpp
)

target_include_directories(KELBON_TEMPLATE_PROJECT_NAMElib PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")

target_link_libraries(KELBON_TEMPLATE_PROJECT_NAMElib PUBLIC
    ${CMAKE_THREAD_LIBS_INIT}
    anyanylib
    kelcorolib
    zallib
)

set_target_properties(KELBON_TEMPLATE_PROJECT_NAMElib PROPERTIES
	LINKER_LANGUAGE CXX
	CXX_STANDARD 20
	CMAKE_CXX_STANDARD_REQUIRED ON
)

if(KELBON_TEMPLATE_PROJECT_NAME_ENABLE_TESTING)
	include(CTest)
	add_subdirectory(test)
endif()

# generates launch.json, places compile_commands.json correctly for clangd
ccozy_on_configuration_end_vscode()
