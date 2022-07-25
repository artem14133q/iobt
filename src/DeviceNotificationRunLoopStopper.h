//
// Created by Артем Дубровский on 22.07.2022.
//

#ifndef IOBT_DEVICENOTIFICATIONRUNLOOPSTOPPER_H
#define IOBT_DEVICENOTIFICATIONRUNLOOPSTOPPER_H

@interface DeviceNotificationRunLoopStopper : NSObject
@end

@implementation DeviceNotificationRunLoopStopper {
        IOBluetoothDevice *expectedDevice;
}

- (id)initWithExpectedDevice:(IOBluetoothDevice *)device {
    expectedDevice = device;
    return self;
}

- (void)notification:(IOBluetoothUserNotification *)notification fromDevice:(IOBluetoothDevice *)device {
    if (![expectedDevice isEqual:device]) return;

    [notification unregister];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end

#endif //IOBT_DEVICENOTIFICATIONRUNLOOPSTOPPER_H
