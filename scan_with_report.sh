#!/bin/bash
# scan_with_report.sh - Trivy scanning script with HTML and JSON reports

set -e

IMAGE_NAME="iot-temp-sensor"
CONTAINER_NAME="temp-sensor-container"
BINARY_NAME="iot_temp_sensor"
REPORT_DIR="scan-reports"

mkdir -p $REPORT_DIR

echo "🔵 Starting container temporarily to extract the firmware binary..."
docker build -t iot-temp-sensor .
docker run -d --name $CONTAINER_NAME $IMAGE_NAME sleep 3600

echo "🔵 Copying the firmware binary from the container..."
docker cp $CONTAINER_NAME:/iot-temp-sensor/build/$BINARY_NAME ./

echo "🔵 Removing temporary container..."
docker rm -f $CONTAINER_NAME

echo "🔵 Running Trivy filesystem scan (live output)..."
trivy fs --scanners vuln,secret --severity CRITICAL,HIGH,MEDIUM ./$BINARY_NAME

echo "🔵 Creating detailed JSON report..."
trivy fs --scanners vuln,secret --severity CRITICAL,HIGH,MEDIUM --format json --output $REPORT_DIR/scan_report.json ./$BINARY_NAME

echo "✅ Scans complete. Reports saved in the '$REPORT_DIR' directory."

# Optional: clean up the copied binary afterwards
rm -f $BINARY_NAME
