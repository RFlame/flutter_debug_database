#import "FlutterDebugDatabasePlugin.h"
#if __has_include(<flutter_debug_database/flutter_debug_database-Swift.h>)
#import <flutter_debug_database/flutter_debug_database-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_debug_database-Swift.h"
#endif

@implementation FlutterDebugDatabasePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterDebugDatabasePlugin registerWithRegistrar:registrar];
}
@end
