fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### ci_build
```
fastlane ci_build
```
Runs tests and builds example for the given environment

The lane to run by ci on every commit and PR. This lanes calls the lanes `static_code_analysis`, `generate_xcodeproj`, `test_framework` and `generate_docs`.

####Example:

```
fastlane ci_build configuration:Debug skip_generate_xcodeproj:true --env osx
```

####Options

 * **`configuration`**: The build configuration to use [default: Release]. (`SC_CONFIGURATION`)

 * **`skip_generate_xcodeproj`**: Whether to slip the generate_xcodeproj lane [default: false]. (`SC_SKIP_generate_xcodeproj`)


### generate_xcodeproj
```
fastlane generate_xcodeproj
```
Generate the Xcodeproj based on Xcodegen or SPM

####Example:

```
fastlane generate_xcodeproj
```


### spm_generate_xcodeproj
```
fastlane spm_generate_xcodeproj
```
Update the xcodeproj to fix the Swift Package manager dependency path(s)

####Example:

```
fastlane spm_generate_xcodeproj
```


### test_framework
```
fastlane test_framework
```
Runs all tests for the given environment

Set `scan` action environment variables to control test configuration

####Example:

```
fastlane test_framework configuration:Debug --env osx
```

####Options

 * **`configuration`**: The build configuration to use.


### code_coverage
```
fastlane code_coverage
```
Produces code coverage information

Set `scan` action environment variables to control test configuration

####Example:

```
fastlane code_coverage configuration:Debug skip_generate_xcodeproj:false
```

####Options

 * **`configuration`**: The build configuration to use. The only supported configuration is the `Debug` configuration.

 * **`skip_generate_xcodeproj`**: Whether to slip the generate_xcodeproj lane [default: false]. (`SC_SKIP_generate_xcodeproj`)


### static_code_analysis
```
fastlane static_code_analysis
```
Run static code analysis (swiftlint)

####Example:

```
fastlane static_code_analysis fail_build:true strict:false
```

####Options

 * **`fail_build`**: Whether the build should fail when linting produces errors [default: true]. ('SC_CODE_ANALYSIS_FAILS_BUILD')

 * **`strict`**: Lint mode strict [default: true]. ('SC_CODE_ANALYSIS_STRICT')


### build_example
```
fastlane build_example
```
Builds the example file

Set `xcodebuild` action environment variables to control build configuration

####Example:

```
fastlane build_example configuration:Debug --env osx
```

####Options

 * **`configuration`**: The build configuration to use.


### fix_xcodeproj_config
```
fastlane fix_xcodeproj_config
```
Fix Xcodeproj build configuration where needed

Set Swift Bridging Header for Benchmark target

Access: private


### gen_docs
```
fastlane gen_docs
```
Run the jazzy documentation generator



----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
