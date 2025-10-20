cmake_minimum_required(VERSION 3.10)
project(pharaohsearch LANGUAGES CXX)

set(FLUTTER_MANAGED_DIR flutter)
set(BINARY_NAME "pharaohsearch")

cmake_policy(SET CMP0063 NEW)

add_subdirectory(${FLUTTER_MANAGED_DIR})

add_executable(${BINARY_NAME}
  main.cc
  my_application/my_application.cc
  my_application/my_application.h
)

apply_standard_settings(${BINARY_NAME})
target_compile_features(${BINARY_NAME} PUBLIC cxx_std_17)

target_link_libraries(${BINARY_NAME} PRIVATE flutter)

define_plugin_imports(${BINARY_NAME})

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION bin)
