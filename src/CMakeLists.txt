AUTO_FILES(".." "src" "README\\.md")
AUTO_FILES("." "src" "\\.(cpp|h)$")
include_directories(${COMMON_INCLUDE_DIR})
link_directories(${COMMON_LIBRARY_DIR})
add_definitions(-DCURL_STATICLIB)
if(WIN32)
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /MT")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /MT")
endif()
ADD_EXE(3dstool "${src}")
if(WIN32)
  target_link_libraries(3dstool libeay32 libcurl WS2_32)
  set_target_properties(3dstool PROPERTIES LINK_FLAGS_DEBUG "/NODEFAULTLIB:LIBCMT")
else()
  target_link_libraries(3dstool curl ssl crypto)
  if(NOT linux) #Neither OS X, Cygwin nor BSD have iconv in their LIBC
    target_link_libraries(3dstool iconv)
  endif()
  link_directories(/usr/local/lib)
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L/usr/local/lib")
endif()
install(TARGETS 3dstool DESTINATION bin)
