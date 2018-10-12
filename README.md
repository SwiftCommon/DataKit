# DataKit

Swift µframework for Data operations.

# Features

### Data+String

- Convert Data to UTF-8 or ASCII String

```swift
let data = Data(bytes: [0xc3, 0x98, 0x61, 0x62, 0x63, 0x64])
data.utf8string // -> "Øabcd"
data.asciiString // -> nil 
``` 

- Map Data to Hexidecimal String

```swift
let data = Data(bytes: [0xc3, 0x98, 0x61, 0x62, 0x63, 0x64])
data.hexString() // -> "C39861626364
```

- Initialize Data with Hex String

```swift
let hexString = "C39861626364"
Data(hex: hexString) // -> [0xc3, 0x98, 0x61, 0x62, 0x63, 0x64]
```
        
# Installation

### SwiftPM

```swift
   ...
   dependencies: [
      .package(url: "https://github.com/SwiftCommon/DataKit", "0.0.1" ..< "1.0.0")
   ],
   targets: [
      .target(
         name: "YourAwesomeApp",
         dependencies: ["DataKit"]
      )
   ]
```


# Contributing

Feel free to check the TODO list and/or add your favourite missing Data related feature through a Pull request.

# License

Licensed under the MIT license.