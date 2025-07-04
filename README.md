# IoT Temperature Sensor Firmware (Local Logger)

## Overview

This project simulates a basic firmware for an IoT temperature sensor.  
The firmware measures the ambient temperature periodically and **logs the measurements locally** (e.g., to a serial console or terminal).

It **does not** require any network connection (e.g., no HTTP, MQTT, or other protocols).  
The purpose is to create a minimal and extendable foundation for future real IoT firmware projects.

---

## Project Features

- Simulated ambient temperature measurements every 60 seconds
- Timestamps added to each measurement
- Local console output (instead of network upload)
- Dockerized build process for reproducible environments
- Conan package manager for clean dependency management
- Ready for extension to include real sensors or secure transmission

---

## Technology Stack

| Component      | Purpose                      |
|----------------|-------------------------------|
| C (C11)        | Firmware implementation       |
| CMake          | Build system                  |
| Conan          | Dependency management         |
| Docker         | Build environment containerization |
| OpenSSL        | Placeholder for future TLS security features |
| cJSON          | Placeholder for future JSON formatting |

---

## Folder Structure

```plaintext
iot-temp-sensor/
├── src/            # Source code (.c files)
│   ├── main.c      # Firmware main loop
│   └── sensor.c    # Temperature sensor simulation
├── include/        # Header files (.h files)
│   └── config.h    # (Reserved for future configuration constants)
├── conanfile.txt   # Dependency specification for Conan
├── CMakeLists.txt  # Build configuration (CMake)
├── Dockerfile      # Build instructions for containerized build
└── README.md       # Project documentation
```

---

## Getting Started

### Prerequisites

You will need the following tools installed:

- Docker (recommended)

OR if building manually:

- GCC / Clang
- CMake ≥ 3.22
- Conan ≥ 2.0
- Python 3 (for Conan)

For running the scripts:
- jq
- Docker
- trivy
- syft

---

### Quick Start (Using Docker)

1. Clone or download this project.
2. Build the Docker image:

```bash
docker build -t iot-temp-sensor .
```

3. Run the firmware simulation:

```bash
docker run --rm iot-temp-sensor
```

You will see a new temperature measurement logged to the console every 60 seconds.

---

### Manual Build (Without Docker)

1. Install system dependencies:

```bash
sudo apt install build-essential cmake python3-pip
pip3 install conan
```

2. Detect your system profile for Conan:

```bash
conan profile detect
```

3. Install project dependencies:

```bash
conan install . --output-folder=build --build=missing
```

4. Build the firmware:

```bash
cmake -Bbuild -S. -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

5. Run the binary:

```bash
./build/iot_temp_sensor
```

---

## How It Works

- **Temperature Simulation:**  
  The sensor randomly generates a value between 20.00°C and 30.00°C.
  
- **Logging:**  
  Every minute, the firmware logs a timestamped temperature reading to the console.
  
- **Sleep Interval:**  
  A 60-second delay (`sleep(60)`) is used to simulate periodic measurements.

---

## Trivy Scan commands

### Scan repository
To scan the repository. Will focus on Dockerfile:

```bash
trivy fs --scanners vuln,config,secret --severity CRITICAL,HIGH,MEDIUM .
```

### Scan binary / built application
To scan the build results. Will focus on build artifact and dependencies:

```bash
./scan.sh

# or scan with json report
./scan-with-report.sh
```

### Scan docker image
To scan the docker image. Will focus on OS-level of container:

```bash
trivy image iot-temp-sensor
```



## Possible Extensions

This basic firmware can easily be extended in the future:

- **Integrate real hardware sensors** (e.g., using I2C/SPI)
- **Output temperature as JSON objects** using cJSON
- **Securely transmit temperature data** to a remote server using OpenSSL
- **Add persistent local storage** (e.g., writing to flash memory or SD cards)
- **Support for OTA (Over-The-Air Updates)**

---

## Notes

- The OpenSSL library is currently included as a placeholder for potential secure communication functionality but is not used actively yet.
- The cJSON library is downloaded and included but not actively used in this version. It prepares the project for future JSON serialization of data.

---

## License

This project is provided as-is for educational and demonstration purposes.

---

# 🚀 Final Words

This project provides a **lightweight, modern starting point** for building real-world IoT firmware solutions.  
Its design emphasizes **simplicity, clean architecture, and extensibility**.

Feel free to clone, extend, and integrate it into your own embedded or IoT workflows!