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

TensorFlow Lite Flutter plugin provides a flexible and fast solution for accessing TensorFlow Lite interpreter and performing inference. The API is similar to the TFLite Java and Swift APIs. It directly binds to TFLite C API making it efficient (low-latency). Offers acceleration support using NNAPI, GPU delegates on Android, Metal and CoreML delegates on iOS, and XNNPack delegate on Desktop platforms.


## Key Features

* Multi-platform Support for Android, iOS, Windows, Mac, Linux.
* Flexibility to use any TFLite Model.
* Acceleration using multi-threading and delegate support.
* Similar structure as TensorFlow Lite Java API.
* Inference speeds close to native Android Apps built using the Java API.
* You can choose to use any TensorFlow version by building binaries locally.
* Run inference in different isolates to prevent jank in UI thread.


## (Important) Initial setup : Add dynamic libraries to your app

### Android

1. Place the script [install.sh](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.sh) (Linux/Mac) or [install.bat](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.bat) (Windows) at the root of your project.

2. Execute `sh install.sh` (Linux) / `install.bat` (Windows) at the root of your project to automatically download and place binaries at appropriate folders.

   Note: *The binaries installed will **not** include support for `GpuDelegateV2` and `NnApiDelegate` however `InterpreterOptions().useNnApiForAndroid` can still be used.* 

3. Use **`sh install.sh -d`** (Linux) or **`install.bat -d`** (Windows) instead if you wish to use these `GpuDelegateV2` and `NnApiDelegate`.

These scripts install pre-built binaries based on latest stable tensorflow release. For info about using other tensorflow versions follow [instructions in wiki](https://github.com/am15h/tflite_flutter_plugin/wiki/). 

### iOS

1. Download [`TensorFlowLiteC.framework`](https://github.com/am15h/tflite_flutter_plugin/releases/download/v0.5.0/TensorFlowLiteC.framework.zip). For building a custom version of tensorflow, follow [instructions in wiki](https://github.com/am15h/tflite_flutter_plugin/wiki/). 
2. Place the `TensorFlowLiteC.framework` in the pub-cache folder of this package.

 Pub-Cache folder location: [(ref)](https://dart.dev/tools/pub/cmd/pub-get#the-system-package-cache)

 - `~/.pub-cache/hosted/pub.dartlang.org/tflite_flutter-<plugin-version>/ios/` (Linux/ Mac) 
 - `%LOCALAPPDATA%\Pub\Cache\hosted\pub.dartlang.org\tflite_flutter-<plugin-version>\ios\` (Windows)

### Desktop

Follow instructions in [this guide](https://github.com/am15h/tflite_flutter_plugin/wiki/Building-Desktop-binaries-with-XNNPack-Delegate) to build and use desktop binaries.

## TFLite Flutter Helper Library

A dedicated library with simple architecture for processing and manipulating input and output of TFLite Models. API design and documentation is identical to the TensorFlow Lite Android Support Library. Strongly recommended to be used with `tflite_flutter_plugin`. [Learn more](https://github.com/am15h/tflite_flutter_helper). 

## Examples

|Title|Code|Demo|Blog|
|-----|----|----|----|
|Text Classification App| [Code](https://github.com/am15h/tflite_flutter_plugin/tree/master/example)|<img src="https://github.com/am15h/tflite_flutter_plugin/raw/master/example/demo.gif" width=120/> |[Blog/Tutorial](https://medium.com/@am15hg/text-classification-using-tensorflow-lite-plugin-for-flutter-3b92f6655982)| 
|Image Classification App| [Code](https://github.com/am15h/tflite_flutter_helper/tree/master/example/image_classification)|<img src="https://github.com/am15h/tflite_flutter_helper/raw/master/example/image_classification/demo.gif" width=120/> |-|
|Object Detection App| [Code](https://github.com/am15h/object_detection_flutter)|<img src="https://github.com/am15h/object_detection_flutter/raw/master/object_detection_demo.gif" width=120/> |[Blog/Tutorial](https://medium.com/@am15hg/real-time-object-detection-using-new-tensorflow-lite-flutter-support-ea41263e801d)|
|Reinforcement Learning App| [Code](https://github.com/windmaple/planestrike-flutter)|<img src="https://github.com/windmaple/planestrike-flutter/raw/main/demo.gif" width=120/> |[Blog/Tutorial](https://windmaple.medium.com/playing-a-board-game-on-device-using-tensorflow-lite-and-fluter-a7c865b9aefc)| 

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
    var output = List.filled(1*2, 0).reshape([1,2]);

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

    var output0 = List<double>.filled(1, 0);  
    var output1 = List<double>.filled(1, 0);

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

Refer [Tests](https://github.com/am15h/tflite_flutter_plugin/blob/master/example/integration_test/tflite_flutter_test.dart) to see more example code for each method.

## Credits

* Tian LIN, Jared Duke, Andrew Selle, YoungSeok Yoon, Shuangfeng Li from the TensorFlow Lite Team for their invaluable guidance.
* Authors of [dart-lang/tflite_native](https://github.com/dart-lang/tflite_native).
