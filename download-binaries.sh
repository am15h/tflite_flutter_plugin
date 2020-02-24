#!/usr/bin/env bash

cd "$(dirname "$(readlink -f "$0")")"

wget https://github.com/am15h/tfl_flutter_blobs/raw/master/ios/fat/TensorFlowLiteC.framework.zip
unzip TensorFlowLiteC.framework.zip
rm TensorFlowLiteC.framework.zip
mv TensorFlowLiteC.framework ios/

wget https://github.com/am15h/tfl_flutter_blobs/raw/master/android/arm64-v8a/libtensorflowlite_c.so
mkdir -p android/src/main/jniLibs/arm64-v8a/
mv libtensorflowlite_c.so android/src/main/jniLibs/arm64-v8a/

wget https://github.com/am15h/tfl_flutter_blobs/raw/master/android/armeabi-v7a/libtensorflowlite_c.so
mkdir -p android/src/main/jniLibs/armeabi-v7a/
mv libtensorflowlite_c.so android/src/main/jniLibs/armeabi-v7a/
