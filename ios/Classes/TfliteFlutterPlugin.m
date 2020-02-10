#import "TfliteFlutterPlugin.h"
#if __has_include(<tflite_flutter_plugin/tflite_flutter_plugin-Swift.h>)
#import <tflite_flutter_plugin/tflite_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tflite_flutter_plugin-Swift.h"
#endif

@implementation TfliteFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTfliteFlutterPlugin registerWithRegistrar:registrar];
}
@end
