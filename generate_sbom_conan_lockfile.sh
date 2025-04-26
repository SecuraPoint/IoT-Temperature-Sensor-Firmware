#!/bin/bash
# generate_sbom_conan_lockfile.sh - Create conan.lock and CycloneDX SBOM inside Docker

set -e

IMAGE_NAME="iot-temp-sensor"
CONTAINER_NAME="sbom-generator"
LOCKFILE="conan.lock"
SBOM_FILE_GRAPH="sbom-conan-lockfile-graph.json"

echo "🔵 Starting temporary container..."
docker run -d --name $CONTAINER_NAME $IMAGE_NAME sleep infinity

echo "🔵 Creating conan.lock inside container..."
docker exec $CONTAINER_NAME conan lock create conanfile.txt --lockfile-out=$LOCKFILE

echo "🔵 Running conan install (to populate metadata)..."
docker exec $CONTAINER_NAME conan install . --lockfile=$LOCKFILE --output-folder=build --build=missing

echo "🔵 Generating dependency graph as JSON..."
docker exec $CONTAINER_NAME conan graph info . --lockfile=$LOCKFILE --format=json > scan-reports/temp_graph.json

echo "🔵 Building CycloneDX SBOM from graph info..."
jq '{
  "bomFormat": "CycloneDX",
  "specVersion": "1.4",
  "version": 1,
  "components": (
    .graph.nodes // [] | map({
      "type": "library",
      "name": .ref,
      "version": (.package_id // "unknown"),
      "purl": ("pkg:generic/" + (.ref | gsub("[/@]"; "-")))
    })
  )
}' scan-reports/temp_graph.json > scan-reports/$SBOM_FILE_GRAPH

echo "🔵 Copying generated files from container..."
docker cp $CONTAINER_NAME:/iot-temp-sensor/$LOCKFILE ./scan-reports/

echo "🔵 Cleaning up container..."
docker rm -f $CONTAINER_NAME

echo "✅ SBOM generation complete: $SBOM_FILE_GRAPH and $LOCKFILE"
