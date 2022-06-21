#import "GojekCourierPlugin.h"
#if __has_include(<gojek_courier/gojek_courier-Swift.h>)
#import <gojek_courier/gojek_courier-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gojek_courier-Swift.h"
#endif

@implementation GojekCourierPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGojekCourierPlugin registerWithRegistrar:registrar];
}
@end
