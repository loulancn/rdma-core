# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file

# cmake does not have way to do this even slightly sanely until CMP0056
function(RDMA_CHECK_C_LINKER_FLAG FLAG CACHE_VAR)
  set(SAFE_CMAKE_REQUIRED_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES}")
  set(SAFE_CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")

  if (POLICY CMP0056)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${FLAG}")
  else()
    set(CMAKE_REQUIRED_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES} ${FLAG}")
  endif()

  CHECK_C_COMPILER_FLAG("" ${CACHE_VAR})

  set(CMAKE_EXE_LINKER_FLAGS "${SAFE_CMAKE_EXE_LINKER_FLAGS}")
  set(CMAKE_REQUIRED_LIBRARIES "${SAFE_CMAKE_REQUIRED_LIBRARIES}")
endfunction()

# Test if the CC compiler supports the linker flag and if so add it to TO_VAR
function(RDMA_AddOptLDFlag TO_VAR CACHE_VAR FLAG)
  RDMA_CHECK_C_LINKER_FLAG("${FLAG}" ${CACHE_VAR})
  if (${CACHE_VAR})
    SET(${TO_VAR} "${${TO_VAR}} ${FLAG}" PARENT_SCOPE)
  endif()
endfunction()

# Test if the CC compiler supports the flag and if so add it to TO_VAR
function(RDMA_AddOptCFlag TO_VAR CACHE_VAR FLAG)
  CHECK_C_COMPILER_FLAG("${FLAG}" ${CACHE_VAR})
  if (${CACHE_VAR})
    SET(${TO_VAR} "${${TO_VAR}} ${FLAG}" PARENT_SCOPE)
  endif()
endfunction()

# Enable the minimum required gnu99 standard in the compiler.
function(RDMA_EnableCStd)
  if (CMAKE_VERSION VERSION_LESS "3.1")
    # Check for support of the usual flag
    CHECK_C_COMPILER_FLAG("-std=gnu99" SUPPORTS_GNU99)
    if (SUPPORTS_GNU99)
      SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99" PARENT_SCOPE)
    endif()
  else()
    # Newer cmake can do this internally
    set(CMAKE_C_STANDARD 99 PARENT_SCOPE)
  endif()
endfunction()
