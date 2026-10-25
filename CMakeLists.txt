cmake_minimum_required(VERSION 3.20)
project(relvia VERSION 0.1.0 LANGUAGES CXX)

add_library(relvia INTERFACE)
add_library(relvia::core ALIAS relvia)
target_compile_features(relvia INTERFACE cxx_std_17)
target_include_directories(relvia INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> $<INSTALL_INTERFACE:include>)

include(CTest)
if(BUILD_TESTING)
    add_executable(relvia_contract_test tests/contract_test.cpp)
    target_link_libraries(relvia_contract_test PRIVATE relvia::core)
    add_test(NAME relvia_contract COMMAND relvia_contract_test)
endif()
