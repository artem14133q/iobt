//
// Created by Артем Дубровский on 22.07.2022.
//

#ifndef IOBT_DEVICEPAIRDELEGATE_H
#define IOBT_DEVICEPAIRDELEGATE_H

@interface DevicePairDelegate : NSObject <IOBluetoothDevicePairDelegate>

@property (readonly) IOReturn errorCode;
@property char *pin;

@end

@implementation DevicePairDelegate

- (void)devicePairingFinished:(__unused id)sender error:(IOReturn)error {
    _errorCode = error;
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)devicePairingPINCodeRequest:(id)sender {
    BluetoothPINCode pinCode;

    if (!_pin) { iobtErr(EXIT_FAILURE, "Pin requested but not got."); }

    ByteCount size = strlen(_pin);

    if (size > 16) size = 16;

    strncpy((char *)pinCode.data, _pin, size);

    [sender replyPINCode:size PINCode:&pinCode];
}

@end


#endif //IOBT_DEVICEPAIRDELEGATE_H
