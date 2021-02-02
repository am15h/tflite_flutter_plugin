 <p align="center">
    <br>
    <img src="https://github.com/am15h/tflite_flutter_plugin/raw/update_readme/docs/tflite_flutter_cover.png"/>
    </br>
</p>
<p align="center">
 
   <a href="https://flutter.dev">
     <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter"
       alt="Platform" />
   </a>
   <a href="https://pub.dartlang.org/packages/tflite_flutter">
     <img src="https://img.shields.io/pub/v/tflite_flutter.svg"
       alt="Pub Package" />
   </a>
    <a href="https://pub.dev/documentation/tflite_flutter/latest/tflite_flutter/tflite_flutter-library.html">
        <img alt="Docs" src="https://readthedocs.org/projects/hubdb/badge/?version=latest">
    </a>
    <a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg"></a>


</a>
</p>

## Overview

TensorFlow Lite Flutter plugin provides a flexible and fast solution for accessing TensorFlow Lite interpreter and performing inference. The API is similar to the TFLite Java and Swift APIs. It directly binds to TFLite C API making it efficient (low-latency). Offers acceleration support using NNAPI, GPU delegates on Android, and Metal delegate on iOS.


## Key Features

* Flexibility to use any TFLite Model.
* Acceleration using multi-threading and delegate support.
* Similar structure as TensorFlow Lite Java API.
* Inference speeds close to native Android Apps built using the Java API.
* You can choose to use any TensorFlow version by building binaries locally.
* Run inference in different isolates to prevent jank in UI thread.


## (Important) Initial setup

### Add dynamic libraries to your app

#### Android

1. Place the script [install.sh](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.sh) (Linux/Mac) or [install.bat](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.bat) (Windows) at the root of your project.

2. Execute `sh install.sh` (Linux) / `install.bat` (Windows) at the root of your project to automatically download and place binaries at appropriate folders.

   Note: *The binaries installed will **not** include support for `GpuDelegateV2` and `NnApiDelegate` however `InterpreterOptions().useNnApiForAndroid` can still be used.* 

3. Use **`sh install.sh -d`** (Linux) or **`install.bat -d`** (Windows) instead if you wish to use these `GpuDelegateV2` and `NnApiDelegate`.

These scripts install pre-built binaries based on latest stable tensorflow release. For info about using other tensorflow versions refer to [this](#use-the-plugin-with-any-tensorflow-version) part of readme.

#### iOS


## Examples

|Title|Code|Demo|Blog|
|-----|----|----|----|
|Text Classification App| [Code](https://github.com/am15h/tflite_flutter_plugin/tree/master/example)|<img src="https://github.com/am15h/tflite_flutter_plugin/raw/master/example/demo.gif" width=120/> |[Blog/Tutorial](https://medium.com/@am15hg/text-classification-using-tensorflow-lite-plugin-for-flutter-3b92f6655982)| 
|Image Classification App| [Code](https://github.com/am15h/tflite_flutter_helper/tree/master/example/image_classification)|<img src="https://github.com/am15h/tflite_flutter_helper/blob/master/example/image_classification/demo.gif" width=120/> |-|
|Object Detection App| [Code](https://github.com/am15h/object_detection_flutter)|<img src="https://github.com/am15h/object_detection_flutter/blob/master/object_detection_demo.gif" width=120/> |[Blog/Tutorial](https://medium.com/@am15hg/real-time-object-detection-using-new-tensorflow-lite-flutter-support-ea41263e801d)|

## Import

    import 'package:tflite_flutter/tflite_flutter.dart';

## Usage instructions

### Creating the Interpreter

* **From asset**

    Place `your_model.tflite` in `assets` directory. Make sure to include assets in `pubspec.yaml`.

    ```dart
    final interpreter = await tfl.Interpreter.fromAsset('your_model.tflite');
    ```

Refer to the documentation for info on creating interpreter from buffer or file.

### Performing inference

See [TFLite Flutter Helper Library](https://www.github.com/am15h/tflite_flutter_helper) for easy processing of input and output.

* **For single input and output**

    Use `void run(Object input, Object output)`.
    ```dart
    // For ex: if input tensor shape [1,5] and type is float32
    var input = [[1.23, 6.54, 7.81. 3.21, 2.22]];

    // if output tensor shape [1,2] and type is float32
    var output = List(1*2).reshape([1,2]);

    // inference
    interpreter.run(input, output);

    // print the output
    print(output);
    ```
  
* **For multiple inputs and outputs**

    Use `void runForMultipleInputs(List<Object> inputs, Map<int, Object> outputs)`.

    ```dart
    var input0 = [1.23];  
    var input1 = [2.43];  

    // input: List<Object>
    var inputs = [input0, input1, input0, input1];  

    var output0 = List<double>(1);  
    var output1 = List<double>(1);

    // output: Map<int, Object>
    var outputs = {0: output0, 1: output1};

    // inference  
    interpreter.runForMultipleInputs(inputs, outputs);

    // print outputs
    print(outputs)
    ```

### Closing the interpreter

```dart
interpreter.close();
```

### Improve performance using delegate support

    Note: This feature is under testing and could be unstable with some builds and on some devices.

* **NNAPI delegate for Android**

    ```dart
    var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
    final interpreter = await Interpreter.fromAsset('your_model.tflite',
        options: interpreterOptions);

    ```

    or

    ```dart
    var interpreterOptions = InterpreterOptions()..addDelegate(NnApiDelegate());
    final interpreter = await Interpreter.fromAsset('your_model.tflite',
        options: interpreterOptions);

    ```

* **GPU delegate for Android and iOS**

  * **Android** GpuDelegateV2

    ```dart
    final gpuDelegateV2 = GpuDelegateV2(
            options: GpuDelegateOptionsV2(
            false,
            TfLiteGpuInferenceUsage.fastSingleAnswer,
            TfLiteGpuInferencePriority.minLatency,
            TfLiteGpuInferencePriority.auto,
            TfLiteGpuInferencePriority.auto,
        ));

    var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegateV2);
    final interpreter = await Interpreter.fromAsset('your_model.tflite',
        options: interpreterOptions);
    ```

  * **iOS** Metal Delegate (GpuDelegate)

    ```dart
    final gpuDelegate = GpuDelegate(
          options: GpuDelegateOptions(true, TFLGpuDelegateWaitType.active),
        );
    var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegate);
    final interpreter = await Interpreter.fromAsset('your_model.tflite',
        options: interpreterOptions);
    ```

Refer [Tests](https://github.com/am15h/tflite_flutter_plugin/blob/master/example/test/tflite_flutter_plugin_example_e2e.dart) to see more example code for each method.

#### Use the plugin with any tensorflow version

The pre-built binaries are updated with each stable tensorflow release. However, you many want to use latest unstable tf releases or older tf versions, for that proceed to build locally, if you are unable to find the required version in [release assets](https://github.com/am15h/tflite_flutter_plugin/releases).

Make sure you have required version of bazel installed. (Check TF_MIN_BAZEL_VERSION, TF_MAX_BAZEL_VERSION in configure.py)

* **Android**

Configure your workspace for android builds as per [these instructions](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/g3doc/guide/build_android.md#configure-workspace-and-bazelrc).

For TensorFlow >= v2.2

```
    bazel build -c opt --cxxopt=--std=c++11 --config=android_arm //tensorflow/lite/c:tensorflowlite_c

    // similarily for arm64 use --config=android_arm64
```

For TensorFlow <= v2.1
```
    bazel build -c opt --cxxopt=--std=c++11 --config=android_arm //tensorflow/lite/experimental/c:libtensorflowlite_c.so

    // similarily for arm64 use --config=android_arm64
```

* **iOS**

Refer [instructions on TensorFlow Lite website](https://www.tensorflow.org/lite/guide/build_ios#install_bazel) to build locally for iOS.

Note: You must use macOS for building iOS.

#### More info on dynamic linking

`tflite_flutter` dynamically links to C APIs which are supplied in the form of `libtensorflowlite_c.so` on Android and `TensorFlowLiteC.framework` on iOS.

For Android, We need to manually download these binaries from release assets and place the libtensorflowlite_c.so files in the `<root>/android/app/src/main/jniLibs/` directory for each arm, arm64, x86, x86_64 architecture as done here in the example app.  

## Future Work

* Enabling support for Flutter Desktop Applications.
* Better and more precise error handling.

## Credits

* Tian LIN, Jared Duke, Andrew Selle, YoungSeok Yoon, Shuangfeng Li from the TensorFlow Lite Team for their invaluable guidance.
* Authors of [dart-lang/tflite_native](https://github.com/dart-lang/tflite_native).
