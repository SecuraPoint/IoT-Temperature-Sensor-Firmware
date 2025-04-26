#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <openssl/rand.h>
#include "sensor.h"

void log_crypto_random() {
    unsigned char buf[4];
    if (RAND_bytes(buf, sizeof(buf)) != 1) {
        printf("Error generating cryptographic random number!\n");
        return;
    }
    unsigned int num = (buf[0] << 24) | (buf[1] << 16) | (buf[2] << 8) | buf[3];
    printf("Generated secure random number: %u\n", num);
}

int main() {
    setvbuf(stdout, NULL, _IONBF, 0);
    
    printf("Starting IoT Temperature Sensor (Local Logger)...\n");

    while (1) {
        double temp = read_temperature();
        log_temperature(temp);
        log_crypto_random();
        sleep(60);
    }

    return 0;
}
