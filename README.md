# 📊 xcstats(1)
[![CircleCI](https://circleci.com/gh/horimislime/xcstats.svg?style=svg)](https://circleci.com/gh/horimislime/xcstats)
[![Language: Swift 4.2](https://img.shields.io/badge/swift-4.2-4BC51D.svg?style=flat)](https://developer.apple.com/swift)

`xcstats` is a command line tool for analyzing Xcode project and prints statistics of source codes like `rake stats`.

[![asciicast](https://asciinema.org/a/218906.svg)](https://asciinema.org/a/218906)

This project leverages [SwiftSyntax](https://github.com/apple/swift-syntax) to generate Swift code statistics that describes how many Swift types (class, struct, enum, etc.) are declared on your project.

---

# System Requirements
- Xcode 10.1

---

# Installation
Using homebrew:

```
$ brew tap horimislime/taproom
$ brew install xcstats
```

You can also download portable executable from [releases](https://github.com/horimislime/xcstats/releases) and install it manually.

---

# Usage
Under your Xcode project root, just hit `xcstats` .

```
$ cd /path/to/your/project/root
$ xcstats
```

---

# Development
Generate .xcodeproj with `make xcodeproj` and open it in Xcode 10.1 or later.

---

# TODOs
This project is still under early development. Missing features are:

- Specifying Xcode project path other than current working directory
- Detailed Objective-C code statistics (currently xcstats only prints lines/LOC. I need SwiftSyntax for ObjC! 😄)
- And some other useful statistics (number of tests, assets, etc.)

---

# License
[MIT](LICENSE)
