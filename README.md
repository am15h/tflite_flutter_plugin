

# TensorFlow Lite Flutter Plugin

TensorFlow Lite plugin provides a dart API for accessing TensorFlow Lite interpreter and performing inference. It binds to TensorFlow Lite C API using dart:ffi. 

## Initial setup
#### Download dynamic libraries

The pre-built binaries can be found in [release assets](https://github.com/am15h/tflite_flutter_plugin/releases).

Place the script [install.sh](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.sh) at the root of your project.

Run <pre>sh [install.sh](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.sh)</pre> at the root of your project to automatically download and place binaries at appropriate folders.
    
**Important**
    
If you do not wish to use `GpuDelegateV2` and `NnApiDelegate` in your app then its recommended and sufficient <br/>
to run <pre>sh [install.sh](https://github.com/am15h/tflite_flutter_plugin/blob/master/install.sh) -b</pre> to install only basic .so for android which comes with reduced size. 

##  Import

    import 'package:tflite_flutter_plugin/tflite.dart' as tfl;

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
    final interpreter = tfl.Interpreter.fromBuffer(buffer);

	Future<Uint8List> getBuffer(String filePath) async {  
	 final rawAssetFile = await rootBundle.load(filePath);  
	 final rawBytes = rawAssetFile.buffer.asUint8List();  
	 return rawBytes;  
	}
	```

* **from file**

   ```
   final dataFile = await getFile('assets/your_model.tflite');
   final interpreter = tfl.Interpreter.fromFile(dataFile);
   
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
    var interpreterOptions = tfl.InterpreterOptions()..useNnApiForAndroid = true;
    final interpreter = await tfl.Interpreter.fromAsset('your_model.tflite',
        options: interpreterOptions);
    
    ```
    or
    
    ```
    var interpreterOptions = tfl.InterpreterOptions()..addDelegate(tfl.NnApiDelegate());
    final interpreter = await tfl.Interpreter.fromAsset('your_model.tflite',
        options: interpreterOptions);
        
    ```


* **GPU delegate for Android and iOS**
    

Refer [Tests](https://github.com/am15h/tflite_flutter_plugin/blob/master/example/test/tflite_flutter_plugin_example_e2e.dart) to see more example code for each method.

Refer [Text Classification Flutter Example App](https://github.com/am15h/tflite_flutter_plugin/tree/master/example) for demo.

## Credits

* Tian LIN, Jared Duke, Andrew Selle, YoungSeok Yoon, Shuangfeng Li from the TensorFlow Lite Team for their invaluable guidance.
* Authors of [dart-lang/tflite_native](https://github.com/dart-lang/tflite_native).
