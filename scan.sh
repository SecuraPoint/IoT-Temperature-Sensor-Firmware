#!/bin/bash
# scan.sh - Trivy scanning helper script for the IoT Temperature Sensor project

set -e

IMAGE_NAME="iot-temp-sensor"
CONTAINER_NAME="temp-sensor-container"
BINARY_NAME="iot_temp_sensor"

echo "🔵 Starting container temporarily to extract the firmware binary..."
docker build -t iot-temp-sensor .
docker run -d --name $CONTAINER_NAME $IMAGE_NAME sleep 3600

echo "🔵 Copying the firmware binary from the container..."
docker cp $CONTAINER_NAME:/iot-temp-sensor/build/$BINARY_NAME ./

echo "🔵 Removing temporary container..."
docker rm -f $CONTAINER_NAME

echo "🔵 Running Trivy filesystem scan on the firmware binary..."
trivy fs --scanners vuln,secret --severity CRITICAL,HIGH,MEDIUM ./$BINARY_NAME

echo "✅ Scan complete."

# Optional: clean up the copied binary afterwards
rm -f $BINARY_NAME
