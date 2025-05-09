#!/bin/sh

ARCHIVE_DIRECTORY=build/archive

if [ $# -ne 1 ]
then
	echo "Version is missing"
	exit
fi

VERSION=$1

xcodebuild archive \
    -project PinLayout.xcodeproj \
    -scheme PinLayout \
    -destination "generic/platform=iOS" \
    -archivePath "$ARCHIVE_DIRECTORY/PinLayout-iOS" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
    -project PinLayout.xcodeproj \
    -scheme PinLayout \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$ARCHIVE_DIRECTORY/PinLayout-iOS_Simulator" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild -create-xcframework \
    -archive $ARCHIVE_DIRECTORY/PinLayout-iOS.xcarchive -framework PinLayout.framework \
    -archive $ARCHIVE_DIRECTORY/PinLayout-iOS_Simulator.xcarchive -framework PinLayout.framework \
    -output build/archive/PinLayout.xcframework

mkdir build/xcframework

cp LICENSE build/archive
cd build/archive

zip -r ../xcframework/PinLayout-$VERSION.zip PinLayout.xcframework LICENSE
