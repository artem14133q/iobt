//
// Created by Артем Дубровский on 19.07.2022.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tools.h"

//                        a 0  -  b 1  -  c 3  -  d 4  -  e 5  -  f 6
#define ADDRESS_UUID_MASK 1,1, 2, 1,1, 2, 1,1, 2, 1,1, 2, 1,1, 2, 1,1

#define ADDRESS_SIZE 17
#define RECENT_ACCESS_DATE_SIZE 25

#define ERROR_ADDRESS_MASK_PREFIX_STRING "unexpected char %d in address '%s' expect "

#define UUID_FORMAT_APPLE 1
#define UUID_FORMAT_IOBT 2

/**
 * Check address by mask like '[0-9a-f]{2}(:[0-9a-f]{2}){5}'
 * @param address
 * @param error
 */
void checkAddress(const char * address, char * error) {
    if (strlen(address) != ADDRESS_SIZE) {
        sprintf(error, "Wrong address len '%s', must be 17.", address); return;
    }

    uint8_t mask[] = {ADDRESS_UUID_MASK};

    for (int i = 0; i < ADDRESS_SIZE; ++i) {
        uint8_t code = (uint8_t) address[i];
        uint8_t maskFlag = mask[i];

        if (maskFlag == 1) {
            if ((code >= 0x61 && code <= 0x66) || ((code >= 0x30 && code <= 0x39))) continue;

            sprintf(error, ERROR_ADDRESS_MASK_PREFIX_STRING "[a-f0-9]", i + 1, address); break;
        } else if (maskFlag == 2) {
            if (code == 0x3a) continue;

            sprintf(error, ERROR_ADDRESS_MASK_PREFIX_STRING "[:]", i + 1, address); break;
        }
    }
}

/**
 * Change uuid separator ':' <-> '-'.
 * @param uuid
 * @param format
 */
void formatUuid(char * uuid, uint8_t format) {
    if (format < UUID_FORMAT_APPLE && format > UUID_FORMAT_IOBT) {
        iobtErr(EXIT_FAILURE, "Undefined uuid Format '%d'", format);
    }

    char sep = (char) (format == UUID_FORMAT_APPLE ? '-' : ':');

    uuid[2] = uuid[5] = uuid[8] = uuid[11] = uuid[14] = sep;
}

/**
 * Fill `Device` struct by data from Apple device object.
 * @param device
 * @param iOBTDevice
 */
void fillDevice(IOBluetoothDevice * device, IOBT_DEVICE * iOBTDevice) {
    iOBTDevice->address = malloc(sizeof (char) * ADDRESS_SIZE);
    strcpy(iOBTDevice->address, [[device addressString] UTF8String]);
    formatUuid(iOBTDevice->address, UUID_FORMAT_IOBT);

    iOBTDevice->rssi = (int) [device rawRSSI];

    if ([device isConnected]) {
        iOBTDevice->connected = [device isIncoming] ? Slave : Master;
    } else {
        iOBTDevice->connected = No;
    }

    iOBTDevice->favorite = [device isFavorite];
    iOBTDevice->paired = [device isPaired];
    iOBTDevice->name = (char *) ([device name] ? [[device name] UTF8String] : "-");

    iOBTDevice->recentAccessDate = malloc(sizeof(char) * RECENT_ACCESS_DATE_SIZE);
    strcpy(
        iOBTDevice->recentAccessDate,
        [device recentAccessDate] ? [[[device recentAccessDate] description] UTF8String] : "-"
    );
}

/**
 * Fill struct array with devices
 * @param devices
 * @param deviceArray
 */
void createDevicesArray(NSArray * devices, IOBT_DEVICES * iOBTDevices) {
    struct Device *items;

    items = malloc(sizeof(IOBT_DEVICE) * devices.count);

    NSUInteger i = 0;

    for (; i < devices.count; ++i) {
        fillDevice(devices[i], &items[i]);
    }

    iOBTDevices->len = (int) i;
    iOBTDevices->devices = items;
}

/**
 * Create Apple string from char array
 * @param string
 * @return
 */
NSString * toNSString(const char * string) {
    return [NSString stringWithCString:string encoding:[NSString defaultCStringEncoding]];
}

/**
 * Find device by address.
 * @param address
 * @return
 */
IOBluetoothDevice * findDevice(const char * address) {
    char errorBuf[100];

    errorBuf[0] = '\0';

    char * id = malloc(sizeof(char) * ADDRESS_SIZE);
    strcpy(id, address);

    checkAddress(id, errorBuf);
    formatUuid(id, UUID_FORMAT_APPLE);

    if (strlen(errorBuf) > 0) { iobtErr(EXIT_FAILURE, "%s", errorBuf); }

    IOBluetoothDevice *device = [IOBluetoothDevice deviceWithAddressString:toNSString(id)];

    if (!device) { iobtErr(EXIT_FAILURE, "Device not found by address: %s", address); }

    return device;
}
