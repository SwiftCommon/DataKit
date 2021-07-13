# Changelog

Pre-release
-----------

1.1.0
-----

* [Tools] Add support for xcframeworks with Carthage for supporting all apple architectures with Carthage (@dennishahn)
* [Migration] Change Fastlane to version v2.187 to be able to use Carthage with xcframeworks (@dennishahn)
* [Migration] Change Danger to version v8.3.1 to solve underlying dependency conflicts of Fastlane version v2.187 (@dennishahn)
* [Migration] Change Nimble to version v9.2.0 so that there are no conflicts with our other dependencies :) (@dennishahn)
* [Migration] Add BUILD_LIBRARY_FOR_DISTRIBUTION: true to be able to have diffing swift versions (@dennishahn)
* [Migration] Change iOS minimal version support to iOS v9 (which is minimal supported version for Xcode12) (@dennishahn)
* [Fix] Buffer underrun (@mfiebig)

1.0.2
-----

* [Config] Added bundleIdePrefix to project.yml

1.0.1
-----

* [Change] iOS deployment target (12.0)

1.0.0
-----

* [Tools] Nimble
* [Tools] Danger
* [Tools] SwiftLint
* [Added] Array<UInt8>.data -> Data
* [Added] Data.asciiString
* [Added] Data.utf8string
* [Added] Data.hexString()
* [Added] Data.init(hex:)
* [Added] Base64.decode(data: Data) -> Data
* [Added] Base64.decode(string: String) -> Data
* [Added] Base64.standard.encode(data: Data) -> Data
* [Added] Base64.urlSafe.encode(data: Data) -> Data
* [Migration] Swift 5.0
* [Migration] XcodeGen + Carthage
