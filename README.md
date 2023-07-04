# iobt
Library for manage bluetooth in MacOS system

## Structs

```objectivec
// Contains some IOBluetoothDevice object parameters
// Alias: IOBT_DEVICE
struct Device {
    char * address;
    char * name;
    char * recentAccessDate;
    enum ConnectionStatus connected;
    int rssi;
    bool favorite; 
    bool paired; 
};

// List of devices
// Alias: IOBT_DEVICES
struct DeviceArray {
    int len;
    struct Device * devices;
};
```

## Connection statuses

| Value | Name              |
| ----- | ----------------- |
| `1`   | **Not connected** |
| `2`   | **Slave**         |
| `3`   | **Master**        |


## Usage

1. Start scan device in range (seconds). If `timeout < 1` when `timeout = 10` sec.
```objectivec
struct DeviceArray search(int8_t timout);
```

2. Return array with paired devices.
```objectivec
struct DeviceArray paired();
```

3. Return array with connected devices.
```objectivec
struct DeviceArray connected();
```

4. Find device by `address`. If device not found, return fake device with current `address`.
   If `strict` flag is `true` it exit with error when device not paired and not favorite.
```objectivec
struct Device getDevice(const char * address, bool strict);
```

5. Close connection. If device not disconnected, return `false`.
```objectivec
bool closeConnection(const char * address);
```

6. Open connection. If device not connected, return false. If device not found it try to connect with current `address`.
```objectivec
bool openConnection(const char * address);
```

7. Pair devices. If device paired when return 0. If device error when return `value > 0`.
```objectivec
int pair(const char * address, const char * pin);
```

8. Unpair devices. If device could not unpair, return `false`.
```objectivec
bool unpair(const char * address);
```

9. Return Bluetooth adapter power state.
```objectivec
bool power();
```

10. Power on/off (`true`/`false`) Bluetooth adapter. Return success flag.
```objectivec
bool setPower(bool enable);
```

## Building

#### Dev tools

* Apple clang
* cmake
* git

#### Make

```zsh
git clone git@github.com:artem14133q/iobt.git
cd iobt
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -G "CodeBlocks - Unix Makefiles" .. --build . --target all -- -j 1
```

`bin` directory will be generated in root project dir 

#### Folder structure

```
.
└─ bin
   │
   ├─ iobt
   │  ├─ headers
   │  │  ├─ iobt.h
   │  │  └─ iobtTypes.h
   │  │
   │  ├─ shared
   │  │  ├─ libiobt.<version>.dylib
   │  │  ├─ libiobt.<version-major>.dylib
   │  │  └─ libiobt.dylib
   │  │
   │  └─ static
   │     ├─ libiobt.<version>.a
   │     ├─ libiobt.<version-major>.a
   │     └─ libiobt.a
   │  
   └─ iobt.zip
```

## Contacts

**Telegram:** <a href="https://t.me/artem14133q">@artem_du</a> <br>
**Gmail:** <a href="mailto:dubisoft1520@gmail.com">dubisoft1520@gmail.com</a>

## Contribute

**Welcome**
