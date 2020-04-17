

# TensorFlow Lite Flutter Plugin

TensorFlow Lite plugin provides a dart API for accessing TensorFlow Lite interpreter and performing inference. It binds to TensorFlow Lite C API using dart:ffi. 

## Initial setup
#### Add dynamic libraries to your app

The pre-built binaries can be found in [release assets](https://github.com/am15h/tflite_flutter_plugin/releases).

Place the script [install.sh](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.sh) at the root of your project.

Run <pre>sh [install.sh](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.sh)</pre> at the root of your project to automatically download and place binaries at appropriate folders.

*The binaries installed will **not** include support for `GpuDelegateV2` and `NnApiDelegate` however `InterpreterOptions().useNnApiForAndroid` can still be used.* 

Use **`install.sh -d`** instead if you wish to use these `GpuDelegateV2` and `NnApiDelegate`.

The pre-built binaries are updated with each stable tensorflow release. However, you many want to use latest unstable tf releases or older tf versions, 
for that proceed to build locally.   

Currently, The `TensorFlowLiteC.framework` is implicitly included with the plugin. 

#### How to build locally ?

Make sure you have required version of bazel installed. (Check TF_MIN_BAZEL_VERSION, TF_MAX_BAZEL_VERSION in configure.py)

* **Android**

Configure your workspace for android builds as per [these instructions](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/g3doc/guide/android.md#configure-workspace-and-bazelrc). 

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

##  Import

    import 'package:tflite_flutter/tflite_flutter.dart';

## Usage instructions

### Creating the Interpreter


#### Interpreter can be created in three ways:

* **directly from asset** (easiest)

	Place `your_model.tflite` in `assets` directory. Make sure to include assets in `pubspec.yaml`.

	```
	final interpreter = await tfl.Interpreter.fromAsset('your_model.tflite');
	```
	
* **from buffer**
	```
    final buffer = await getBuffer('assets/your_model.tflite');
    final interpreter = Interpreter.fromBuffer(buffer);

	Future<Uint8List> getBuffer(String filePath) async {  
	 final rawAssetFile = await rootBundle.load(filePath);  
	 final rawBytes = rawAssetFile.buffer.asUint8List();  
	 return rawBytes;  
	}
	```

* **from file**

   ```
   final dataFile = await getFile('assets/your_model.tflite');
   final interpreter = Interpreter.fromFile(dataFile);
   
   Future<File> getFile(String fileName) async {
     final appDir = await getTemporaryDirectory();
     final appPath = appDir.path;
     final fileOnDevice = File('$appPath/$fileName');
     final rawAssetFile = await rootBundle.load(fileName);
     final rawBytes = rawAssetFile.buffer.asUint8List();
     await fileOnDevice.writeAsBytes(rawBytes, flush: true);
     return fileOnDevice;
   }
   ```

### Performing inference

* **For single input and output**
	
	Use `void run(Object input, Object output)`. 
	```
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
	```
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

```
interpreter.close();
```

### Improve performance using delegate support

    Note: This feature is under testing and could be unstable with some builds and on some devices.

* **NNAPI delegate for Android**

    ```
    var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
    final interpreter = await Interpreter.fromAsset('your_model.tflite',
        options: interpreterOptions);
    
    ```
    or
    
    ```
    var interpreterOptions = InterpreterOptions()..addDelegate(NnApiDelegate());
    final interpreter = await Interpreter.fromAsset('your_model.tflite',
        options: interpreterOptions);
        
    ```


* **GPU delegate for Android and iOS**
    

Refer [Tests](https://github.com/am15h/tflite_flutter_plugin/blob/master/example/test/tflite_flutter_plugin_example_e2e.dart) to see more example code for each method.

Refer [Text Classification Flutter Example App](https://github.com/am15h/tflite_flutter_plugin/tree/master/example) for demo.

## Credits

* Tian LIN, Jared Duke, Andrew Selle, YoungSeok Yoon, Shuangfeng Li from the TensorFlow Lite Team for their invaluable guidance.
* Authors of [dart-lang/tflite_native](https://github.com/dart-lang/tflite_native).