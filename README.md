
# TensorFlow Lite Flutter Plugin

TensorFlow Lite plugin provides a dart API for accessing TensorFlow Lite interpreter and performing inference. It binds to TensorFlow Lite C API using dart:ffi. 

##  Import

    import 'package:tflite_flutter_plugin/tflite.dart' as tfl;

## Usage instructions

### Creating the Interpreter


#### Interpreter can be created in three ways:

* **directly from Asset** (easiest)
Place `your_model.tflite` in `assets` directory. Make sure to include assets in `pubspec.yaml`.
```
    final interpreter = await Interpreter.fromAsset('your_model.tflite');
```
* **from Buffer**
```
    final file = await getBuffer('assets/your_model.tflite');
    final interpreter = tfl.Interpreter.fromFile(file);

	Future<Uint8List> getBuffer(String filePath) async {  
	 final rawAssetFile = await rootBundle.load(filePath);  
	 final rawBytes = rawAssetFile.buffer.asUint8List();  
	 return rawBytes;  
	}
```

### Performing inference

