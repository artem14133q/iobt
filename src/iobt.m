#include "tools.h"
#include "iobt.h"

#include "DeviceInquiryRunLoopStopper.h"
#include "DeviceNotificationRunLoopStopper.h"
#include "DevicePairDelegate.h"

__unused IOBT_DEVICES connected() {
    IOBT_DEVICES deviceArray = {0, NULL};

    NSPredicate *filter = [NSPredicate predicateWithFormat:@"isConnected == YES"];

    createDevicesArray([[IOBluetoothDevice pairedDevices] filteredArrayUsingPredicate:filter], &deviceArray);

    return deviceArray;
}

__unused IOBT_DEVICES paired() {
    IOBT_DEVICES deviceArray = {0, NULL};

    createDevicesArray([IOBluetoothDevice pairedDevices], &deviceArray);

    return deviceArray;
}

__unused IOBT_DEVICES search(int8_t timeout) {
    if (timeout < 1) {
        timeout = 10;
    }

    IOBT_DEVICES deviceArray = {0, NULL};

    if (!IOBluetoothPreferencesAvailable()) return deviceArray;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    @autoreleasepool {
        DeviceInquiryRunLoopStopper *stopper = [[[DeviceInquiryRunLoopStopper alloc] init] autorelease];
        IOBluetoothDeviceInquiry *inquirer = [IOBluetoothDeviceInquiry inquiryWithDelegate:stopper];

        [inquirer setInquiryLength:(uint8_t) timeout];

        [inquirer start];
        CFRunLoopRun();
        [inquirer stop];

        createDevicesArray([inquirer foundDevices], &deviceArray);
    }

    [pool release];

    return deviceArray;
}

__unused IOBT_DEVICE getDevice(const char * address) {
    IOBluetoothDevice *iOBTDevice = findDevice(address);

    IOBT_DEVICE device;

    fillDevice(iOBTDevice, &device);

    return device;
}

__unused bool closeConnection(const char * address) {
    IOBluetoothDevice *device = findDevice(address);

    [device closeConnection];

    if (@available(macOS 12.0, *)) {
        @autoreleasepool {
            DeviceNotificationRunLoopStopper *stopper =
                    [[[DeviceNotificationRunLoopStopper alloc] initWithExpectedDevice:device] autorelease];

            CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(
                    kCFAllocatorDefault, 0, 0, 0, 0, ^(__unused CFRunLoopTimerRef _) {
                        if ([device isConnected]) {
                            [device registerForDisconnectNotification:stopper selector:@selector(notification:fromDevice:)];
                            return;
                        }

                        CFRunLoopStop(CFRunLoopGetCurrent());
                    }
            );

            CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopDefaultMode);

            CFRunLoopRun();

            CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopDefaultMode);
            CFRelease(timer);
        }
    }

    return ![device isConnected];
}

__unused bool openConnection(const char * address) {
    IOBluetoothDevice *device = findDevice(address);

    return [device openConnection] == kIOReturnSuccess;
}

__unused int pair(const char * address, const char * pin) {
    IOBluetoothDevice *device = findDevice(address);

    @autoreleasepool {
        DevicePairDelegate *delegate = [[[DevicePairDelegate alloc] init] autorelease];

        delegate.pin = (char *) pin;

        IOBluetoothDevicePair *devicePair = [IOBluetoothDevicePair pairWithDevice:device];
        devicePair.delegate = delegate;

        if ([devicePair start] != kIOReturnSuccess) { iobtErr(EXIT_FAILURE, "Failed to start pair \"%s\"\n", address); }

        CFRunLoopRun();

        [devicePair stop];

        if (![device isPaired]) {
            return [delegate errorCode];
        }
    }

    return 0;
}

__unused bool unpair(const char * address) {
    IOBluetoothDevice *device = findDevice(address);

    if ([device respondsToSelector:@selector(remove)]) {
        [device performSelector:@selector(remove)];
        return ![device isPaired];
    }

    return false;
}

__unused bool power() {
    return IOBluetoothPreferenceGetControllerPowerState() == 1;
}

__unused bool setPower(bool enable) {
    IOBluetoothPreferenceSetControllerPowerState(enable ? 1 : 0);

    return power() == enable;
}
