FROM ubuntu:22.04

RUN apt-get update && apt-get install -y build-essential cmake python3-pip curl && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install conan

RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

RUN conan profile detect

WORKDIR /iot-temp-sensor

COPY . .

# Install dependencies
RUN conan install . --output-folder=build --build=missing

# Build the project
RUN cmake -Bbuild -S. -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build

# Generate SBOM as part of the build
RUN syft ./build/iot_temp_sensor --output cyclonedx-json > ./build/sbom-syft-build.json

# Generate experimental SBOM with dynamically linked libraries
RUN syft file:./build/iot_temp_sensor --scope all-layers --output cyclonedx-json > ./build/sbom-syft-build_with_libs.json


CMD ["./build/iot_temp_sensor"]
