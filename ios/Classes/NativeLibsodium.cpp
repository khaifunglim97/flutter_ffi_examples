#include <sodium.h>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint32_t libsodium_random( void ) {
    if (sodium_init() < 0) {
        return 1;
    }

    return randombytes_random();
}
