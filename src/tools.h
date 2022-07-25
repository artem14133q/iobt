//
// Created by Артем Дубровский on 19.07.2022.
//

#ifndef IOBT_TOOLS_H
#define IOBT_TOOLS_H

#import <IOBluetooth/IOBluetooth.h>

#include "iobtTypes.h"

#define iobtErr(error_code, m, ...) printf("[IOBT_ERROR] " m "\n", ##__VA_ARGS__); exit(error_code)

void checkAddress(const char * address, char * error);
void createDevicesArray(NSArray * devices, IOBT_DEVICES * iOBTDevices);
void fillDevice(IOBluetoothDevice * device, IOBT_DEVICE * iOBTDevice);

IOBluetoothDevice * findDevice(const char * address);

int IOBluetoothPreferencesAvailable();

int IOBluetoothPreferenceGetControllerPowerState();
void IOBluetoothPreferenceSetControllerPowerState(int state);

#endif //IOBT_TOOLS_H
