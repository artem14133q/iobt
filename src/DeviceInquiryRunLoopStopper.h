//
// Created by Артем Дубровский on 22.07.2022.
//

#ifndef IOBT_DEVICEINQUIRYRUNLOOPSTOPPER_H
#define IOBT_DEVICEINQUIRYRUNLOOPSTOPPER_H

@interface DeviceInquiryRunLoopStopper : NSObject <IOBluetoothDeviceInquiryDelegate>
@end

@implementation DeviceInquiryRunLoopStopper

- (void)deviceInquiryComplete:(__unused IOBluetoothDeviceInquiry *)sender
        error:(__unused IOReturn)error
        aborted:(__unused BOOL)aborted {
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end

#endif //IOBT_DEVICEINQUIRYRUNLOOPSTOPPER_H
