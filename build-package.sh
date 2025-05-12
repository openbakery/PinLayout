#!/bin/sh

swift build -Xswiftc "-sdk" -Xswiftc `xcrun --sdk iphonesimulator --show-sdk-path` -Xswiftc "-target" -Xswiftc "arm64-apple-ios18.4-simulator"
