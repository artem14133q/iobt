//
// Created by Артем Дубровский on 22.07.2022.
//

#ifndef IOBT_IOBTTYPES_H
#define IOBT_IOBTTYPES_H

enum ConnectionStatus {
    No = 1,
    Slave = 2,
    Master = 3,
};

struct Device {
    char * address;
    char * name;
    char * recentAccessDate;
    enum ConnectionStatus connected;
    int rssi;
    bool favorite;
    bool paired;
};

#define IOBT_DEVICE struct Device

struct DeviceArray {
    int len;
    IOBT_DEVICE * devices;
};

#define IOBT_DEVICES struct DeviceArray

#endif //IOBT_IOBTTYPES_H
