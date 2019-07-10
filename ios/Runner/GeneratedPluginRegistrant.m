//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <audioplayers/AudioplayersPlugin.h>
#import <media_notification/MediaNotificationPlugin.h>
#import <path_provider/PathProviderPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AudioplayersPlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioplayersPlugin"]];
  [MediaNotificationPlugin registerWithRegistrar:[registry registrarForPlugin:@"MediaNotificationPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
}

@end
