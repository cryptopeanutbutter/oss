cmake_minimum_required(VERSION 3.10)

set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")
set(FLUTTER_LIBRARY "${EPHEMERAL_DIR}/libflutter_linux_gtk.so")
set(FLUTTER_ENGINE "${EPHEMERAL_DIR}/flutter_linux")
set(FLUTTER_ICU_DATA "${EPHEMERAL_DIR}/icudtl.dat")

set(FLUTTER_TOOL "${EPHEMERAL_DIR}/flutter-gtk")
set(WRAPPER_INCLUDE "${EPHEMERAL_DIR}/include")

add_library(flutter SHARED IMPORTED)
set_target_properties(flutter PROPERTIES
  IMPORTED_LOCATION "${FLUTTER_LIBRARY}"
  INTERFACE_INCLUDE_DIRECTORIES "${WRAPPER_INCLUDE}"
)

set(FLUTTER_PLUGIN_DIR "${CMAKE_CURRENT_SOURCE_DIR}/plugins")
include(flutter/generated_plugins.cmake)

function(apply_standard_settings TARGET)
  target_compile_definitions(${TARGET} PRIVATE "$<$<NOT:$<CONFIG:Debug>>:G_DISABLE_ASSERT>")
  target_compile_options(${TARGET} PRIVATE -Wall -Werror)
  target_link_libraries(${TARGET} PRIVATE pthread dl)
endfunction()

function(define_plugin_imports TARGET)
  foreach(plugin ${FLUTTER_PLUGIN_LIST})
    add_subdirectory(${plugin})
    target_link_libraries(${TARGET} PRIVATE ${plugin}_plugin)
  endforeach()
endfunction()
