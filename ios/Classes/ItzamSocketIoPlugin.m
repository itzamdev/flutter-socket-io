#import "ItzamSocketIoPlugin.h"
#import <itzam_socket_io/itzam_socket_io-Swift.h>

@implementation ItzamSocketIoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftItzamSocketIoPlugin registerWithRegistrar:registrar];
}
@end
