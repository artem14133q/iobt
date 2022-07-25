//
// Created by Артем Дубровский on 18.07.2022.
//

#ifndef IOBT_IOBT_H
#define IOBT_IOBT_H

#include "iobtTypes.h"

#define IOBT_EXPORT __exported __unused

/**
 * Start scan device time (timeout). If timeout < 1 when timeout = 10 sec.
 * @param timout
 * @return
 */
IOBT_EXPORT IOBT_DEVICES search(int8_t timout);

/**
 * Return DeviceArray struct with paired devices.
 * @return
 */
IOBT_EXPORT IOBT_DEVICES paired();

/**
 * Return DeviceArray struct with connected devices. If devices not fround len = 0.
 * @return
 */
IOBT_EXPORT IOBT_DEVICES connected();

/**
 * Find Device by address. If device not found create error and exit with error code 1.
 * @param address
 * @return
 */
IOBT_EXPORT IOBT_DEVICE getDevice(const char * address);

/**
 * Close connection. If device not connected return false. If device not found return false.
 * @param address
 * @return
 */
IOBT_EXPORT bool closeConnection(const char * address);

/**
 * Close connection. If device is connected return true. If device not found return false.
 * @param address
 * @return
 */
IOBT_EXPORT bool openConnection(const char * address);

/**
 * Pair devices. If device paired when return 0. If device error when return value > 0.
 * @param address
 * @param pin
 * @return
 */
IOBT_EXPORT int pair(const char * address, const char * pin);

/**
 * Unpair devices. If device not paired raise error. If device could not unpair return false.
 * @param address
 * @return
 */
IOBT_EXPORT bool unpair(const char * address);

/**
 * Return Bluetooth adapter power state;
 * @return
 */
IOBT_EXPORT bool power();

/**
 * Power on/off (true/false) Bluetooth adapter. Return success flag.
 * @param enable
 * @return
 */
IOBT_EXPORT bool setPower(bool enable);

#endif //IOBT_IOBT_H
