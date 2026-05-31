# Project Status and Support Routing

Status refresh: May 2026

This repository is deprecated. The active `tflite_flutter` package is published at:

- Package: https://pub.dev/packages/tflite_flutter
- Repository: https://github.com/tensorflow/flutter-tflite
- Issues: https://github.com/tensorflow/flutter-tflite/issues

The source in this repository remains useful for historical reference, but new package work should happen in the TensorFlow-managed repository.

## Common Issue Routing

Recent issues in this repository show two common patterns:

- iOS packaging and Swift Package Manager support, such as #247, should be filed against `tensorflow/flutter-tflite`. The iOS code here uses the older plugin layout and is not the active implementation for future Flutter packaging changes.
- Image preprocessing, tensor shape conversion, and helper-library replacement questions, such as #245, should use the current package docs and upstream discussions. For object detection models, confirm the input tensor shape and type from the interpreter, decode and resize the source image with a maintained image package, normalize to the model's expected range, and pass a `Float32List` or shaped Dart list matching the input tensor.

## Folder Notes

Platform folders in this repository now include short status notes so users landing directly in `android/`, `ios/`, `linux/`, `macos/`, or `windows/` are routed to the maintained package before opening stale issues here.
