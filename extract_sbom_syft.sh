#!/bin/bash
# extract_sbom_syft.sh - Extract the SBOM created by syft after build

set -e

IMAGE_NAME="iot-temp-sensor"
CONTAINER_NAME="sbom-generator"
LOCKFILE="conan.lock"
SBOM_FILE="sbom-syft-build.json"
SBOM_WITH_LIBS_FILE="sbom-syft-build_with_libs.json"

echo "🔵 Starting temporary container..."
docker run -d --name $CONTAINER_NAME $IMAGE_NAME sleep infinity

echo "🔵 Copying generated syft SBOMs from container..."
docker cp $CONTAINER_NAME:/iot-temp-sensor/build/$SBOM_FILE ./scan-reports/
docker cp $CONTAINER_NAME:/iot-temp-sensor/build/$SBOM_WITH_LIBS_FILE ./scan-reports/

echo "🔵 Cleaning up container..."
docker rm -f $CONTAINER_NAME

echo "✅ SBOM generation complete: $SBOM_FILE and $LOCKFILE"
