//
// Created by Артем Дубровский on 18.07.2022.
//

#ifndef IOBT_IOBT_H
#define IOBT_IOBT_H

#include "iobtTypes.h"

#define IOBT_EXPORT __exported __unused

/**
 * Start scan device in range (seconds). If timeout < 1 when timeout = 10 sec.
 * @param timout
 * @return
 */
IOBT_EXPORT IOBT_DEVICES search(int8_t timout);

/**
 * Return array with paired devices.
 * @return
 */
IOBT_EXPORT IOBT_DEVICES paired();

/**
 * Return array with connected devices.
 * @return
 */
IOBT_EXPORT IOBT_DEVICES connected();

/**
 * Find device by address. If device not found, return fake device with current address.
 * If strict flag is true it exit with error when device not paired and not favorite.
 * @param address
 * @return
 */
IOBT_EXPORT IOBT_DEVICE getDevice(const char * address, bool strict);

/**
 * Close connection. If device not disconnected return false.
 * @param address
 * @return
 */
IOBT_EXPORT bool closeConnection(const char * address);

/**
 * Open connection. If device not connected, return false. If device not found it try to connect with current address.
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
 * Unpair devices. If device could not unpair, return false.
 * @param address
 * @return
 */
IOBT_EXPORT bool unpair(const char * address);

/**
 * Return Bluetooth adapter power state.
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
