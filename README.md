

# TensorFlow Lite Flutter Plugin

TensorFlow Lite plugin provides a dart API for accessing TensorFlow Lite interpreter and performing inference. It binds to TensorFlow Lite C API using dart:ffi. 

##  Import

    import 'package:tflite_flutter_plugin/tflite.dart' as tfl;

## Usage instructions

### Creating the Interpreter


#### Interpreter can be created in three ways:

* **directly from asset** (easiest)

	Place `your_model.tflite` in `assets` directory. Make sure to include assets in `pubspec.yaml`.

	```
	final interpreter = await Interpreter.fromAsset('your_model.tflite');
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

Refer [Tests](https://github.com/am15h/tflite_flutter_plugin/blob/master/example/test/tflite_flutter_plugin_example_e2e.dart) to see more example code for each method.

Refer [Text Classification Flutter Example App](https://github.com/am15h/tflite_flutter_plugin/tree/master/example) for demo.

