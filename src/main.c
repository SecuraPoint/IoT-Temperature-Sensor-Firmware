#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "sensor.h"

int main() {
    printf("Starting IoT Temperature Sensor (Local Logger)...\n");

    while (1) {
        double temp = read_temperature();
        log_temperature(temp);
        sleep(60);
    }

    return 0;
}
