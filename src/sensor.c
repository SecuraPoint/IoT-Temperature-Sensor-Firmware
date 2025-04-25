#include "sensor.h"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>

double read_temperature() {
    return 20.0 + (rand() % 1000) / 100.0;
}

void log_temperature(double temp) {
    time_t now = time(NULL);
    char *timestamp = ctime(&now);
    timestamp[strcspn(timestamp, "\n")] = 0; // remove newline
    printf("[%s] Temperature: %.2f°C\n", timestamp, temp);
}
