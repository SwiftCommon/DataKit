# DataKit

![Swift 4.0+](https://img.shields.io/badge/Swift-4.0+-orange.svg)
[![license](https://img.shields.io/github/license/SwiftCommon/DataKit.svg)](https://github.com/SwiftCommon/DataKit/LICENSE)
[![Build Status](https://travis-ci.org/SwiftCommon/DataKit.svg?branch=master)](https://travis-ci.org/SwiftCommon/DataKit)
[![codecov](https://codecov.io/gh/SwiftCommon/DataKit/branch/master/graph/badge.svg)](https://codecov.io/gh/SwiftCommon/DataKit)

Swift µframework for Data operations.

Getting started
---------------

On first checkout you best run: `$ script/setup` and when you're a regular user just: `$ script/update`. These scripts are also available through GNUMake: `$ make setup` & `$ make update`.
For more info on the scripts checkout [script/README.md]()

** Note: these scripts may update the Xcode project file and resolve the `Package.resolved` dependencies. You can also do this by running:  
`$ bundle install && bundle exec fastlane gen_xcodeproj`

Features
--------

### Data+Base64

- Base64 encode data blob

```swift
let data = Data(bytes: [0xc3, 0x98, 0x61, 0x62, 0x63, 0x64])
let base64encoded = Base64.standard.encode(data: data)
```

- Base64 (URL and File safe) encode data

```swift
let data = Data(bytes: [0xc3, 0x98, 0x61, 0x62, 0x63, 0x64])
let urlSafeEncoded = Base64.urlSafe.encode(data: data, padding: .none)
```

- Base64 decode data blob

```swift
let base64 = Data(bytes: [0x75, 0xF7, 0xAB, 0xE7, 0xAE, 0x9F, 0x14, 0x38, 0x63, 0x7C, 0x50, 0xD2, 0xB2, 0xCC, 0x2B, 0xAF, 0x0C, 0x30])
let data = try Base64.decode(data: base64) // Base64 decoded data or error
```

- Base64 decode string

```swift
let base64 = "dfer566fFDhjfFDSsswrrwwwwsd"
let data = try Base64.decode(string: base64) // Base64 decoded data or error
```

### Data+String

- Convert Data to UTF-8 or ASCII String

```swift
let data = Data(bytes: [0xc3, 0x98, 0x61, 0x62, 0x63, 0x64])
data.utf8string // -> "Øabcd"
data.asciiString // -> nil
```

* Map Data to Hexidecimal String

```swift
let data = Data(bytes: [0xc3, 0x98, 0x61, 0x62, 0x63, 0x64])
data.hexString() // -> "C39861626364
```

* Initialize Data with Hex String

```swift
let hexString = "C39861626364"
Data(hex: hexString) // -> [0xc3, 0x98, 0x61, 0x62, 0x63, 0x64]
```

Installation
------------

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

Documentation
-------------

To create the documentation run: `bundle exec fastlane gen_docs` and open `./docs/index.html`


Contributing
------------

Feel free to check the [TODO](./TODO.md) list and/or add your favourite missing Data related feature through a Pull request.

License
-------

Licensed under the MIT license.
