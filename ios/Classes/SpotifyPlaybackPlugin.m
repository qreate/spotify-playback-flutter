#import "SpotifyPlaybackPlugin.h"
#import <spotify_playback/spotify_playback-Swift.h>

@implementation SpotifyPlaybackPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSpotifyPlaybackPlugin registerWithRegistrar:registrar];
}
@end
