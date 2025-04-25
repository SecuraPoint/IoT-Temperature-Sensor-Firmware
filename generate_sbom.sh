#!/bin/bash
# generate_sbom_in_docker.sh - Create conan.lock and CycloneDX SBOM inside Docker

set -e

IMAGE_NAME="iot-temp-sensor"
CONTAINER_NAME="sbom-generator"
LOCKFILE="conan.lock"
SBOM_FILE="sbom.json"

echo "🔵 Starting temporary container..."
docker run -d --name $CONTAINER_NAME $IMAGE_NAME sleep infinity

echo "🔵 Creating conan.lock inside container..."
docker exec $CONTAINER_NAME conan lock create conanfile.txt --lockfile-out=$LOCKFILE

echo "🔵 Running conan install (to populate metadata)..."
docker exec $CONTAINER_NAME conan install . --lockfile=$LOCKFILE --output-folder=build --build=missing

echo "🔵 Generating dependency graph as JSON..."
docker exec $CONTAINER_NAME conan graph info . --lockfile=$LOCKFILE --format=json > temp_graph.json

echo "🔵 Building CycloneDX SBOM from graph info..."
jq '{
  "bomFormat": "CycloneDX",
  "specVersion": "1.4",
  "version": 1,
  "components": (
    .nodes // [] | map({
      "type": "library",
      "name": .ref,
      "version": (.package_id // "unknown"),
      "purl": ("pkg:generic/" + (.ref | gsub("[/@]"; "-")))
    })
  )
}' temp_graph.json > scan-reports/$SBOM_FILE

rm -f temp_graph.json

echo "🔵 Copying generated lockfile from container..."
docker cp $CONTAINER_NAME:/iot-temp-sensor/$LOCKFILE ./

echo "🔵 Cleaning up container..."
docker rm -f $CONTAINER_NAME

echo "✅ SBOM generation complete: $SBOM_FILE and $LOCKFILE"
