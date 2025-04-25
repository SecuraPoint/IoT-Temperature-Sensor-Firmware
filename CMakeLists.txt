cmake_minimum_required(VERSION 3.22)
project(iot_temp_sensor C)

set(CMAKE_C_STANDARD 11)

add_executable(iot_temp_sensor
    src/main.c
    src/sensor.c
)

find_package(OpenSSL REQUIRED)

target_link_libraries(iot_temp_sensor
    OpenSSL::SSL
    OpenSSL::Crypto
)

target_include_directories(iot_temp_sensor PRIVATE
    include
    ${CMAKE_BINARY_DIR}/_deps/cjson-src
)