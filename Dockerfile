FROM ubuntu:22.04

RUN apt-get update && apt-get install -y build-essential cmake python3-pip curl && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install conan

RUN conan profile detect

WORKDIR /iot-temp-sensor

COPY . .

# Install dependencies
RUN conan install . --output-folder=build --build=missing

# Build the project
RUN cmake -Bbuild -S. -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build

CMD ["./build/iot_temp_sensor"]
