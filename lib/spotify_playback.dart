import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class SpotifyPlayback {
  /// Spotify playback method channel
  /// The method channel is used to call methods and wait for a response
  static const MethodChannel _channel = const MethodChannel('spotify_playback');

  /// Spotify playback status channel
  /// The event channel fill notify the listener of changes to the playback status
  static const EventChannel _status_channel =
      const EventChannel('spotify_playback_status');

  /// The spotifyConnect method can be called to initialize spotify
  static Future<bool> spotifyConnect(
      {String clientId, String redirectUrl}) async {
    final bool connected = await _channel.invokeMethod(
        "connectSpotify", {"clientId": clientId, "redirectUrl": redirectUrl});
    return connected;
  }

  /// The play method is used to play an song/album/playlist
  static Future<bool> play(String id) async {
    final bool success = await _channel.invokeMethod("playSpotify", {"id": id});
    return success;
  }

  /// The pause method is used to pause the current playing song
  static Future<bool> pause() async {
    final bool paused = await _channel.invokeMethod("pauseSpotify");
    return paused;
  }

  /// The resume method resumes the currently paused song
  static Future<bool> resume() async {
    final bool resumed = await _channel.invokeMethod("resumeSpotify");
    return resumed;
  }

  /// The queue method adds song / playlist / album to the players queue
  static Future<bool> queue(String id) async {
    final bool queued = await _channel.invokeMethod("queue", {"id": id});
    return queued;
  }

  /// The getPlaybackPosition method is used to get the current tracks playback position
  static Future<int> getPlaybackPosition() async {
    final int position = await _channel.invokeMethod("playbackPositionSpotify");
    return position;
  }

  /// The is connected method is used to check if
  /// the Spotify player is correctly Initialized
  static Future<bool> isConnected() async {
    final bool connected = await _channel.invokeMethod("isConnected");
    return connected;
  }

  /// The currently playing track method is used to get the
  /// Currently playing track information in an Json string
  static Future<String> getCurrentlyPlayingTrack() async {
    final String track =
        await _channel.invokeMethod("getCurrentlyPlayingTrack");
    return track;
  }

  /// This method is used to handle current track position callback
  @deprecated
  static Stream enableTimer() {
    return _status_channel.receiveBroadcastStream(
        {"clientId": "clientId", "redirectUrl": "redirectUrl"});
  }

  /// The skipNext method is used to play the next song
  static Future<bool> skipNext() async {
    final bool success = await _channel.invokeMethod("skipNext");
    return success;
  }

  /// The skipPrevious method is used to play the previous song
  static Future<bool> skipPrevious() async {
    final bool success = await _channel.invokeMethod("skipPrevious");
    return success;
  }

  /// The toggleRepeat method is used to toggle the repeat types
  static Future<bool> toggleRepeat() async {
    final bool success = await _channel.invokeMethod("toggleRepeat");
    return success;
  }

  /// The toggleShuffle method is used to toggle the shuffle types
  static Future<bool> toggleShuffle() async {
    final bool success = await _channel.invokeMethod("toggleShuffle");
    return success;
  }

  /// The seekTo method is used to seek to a specific time in a song
  static Future<bool> seekTo(int time) async {
    final bool success =
        await _channel.invokeMethod("seekTo", {"time": time.toString()});
    return success;
  }

  static Future<bool> seekToRelativePosition(int relativeTime) async {
    final bool success = await _channel.invokeMethod(
        "seekToRelativePosition", {"relativeTime": relativeTime.toString()});
    return success;
  }

  /// This method is used to get an image by the provided imageURI and returns a Uint8List(MemoryImage)
  static Future<Uint8List> getImage(
      {@required String uri, int quality, ImageDimension size}) async {
    int sizeValue = 360;
    if (size == ImageDimension.THUMBNAIL) {sizeValue = 144;}
    else if(size == ImageDimension.X_SMALL){sizeValue = 240;}
    else if(size == ImageDimension.SMALL){sizeValue = 360;}
    else if(size == ImageDimension.MEDIUM){sizeValue = 480;}
    else if(size == ImageDimension.LARGE){sizeValue = 720;}

    final Uint8List success = await _channel.invokeMethod(
        "getImage", {"uri": uri, "quality": quality, "size": sizeValue});
    return success;
  }

  /// This method is used to convert image urls provided by web api to spotify image IDs
  static String imageLinkToURi(String imageLink) {
    return "spotify:image:" + imageLink.replaceRange(0, imageLink.lastIndexOf("/") + 1, "");
  }

  /// This method is used to get the authToken
  static Future<String> getAuthToken(
      {@required String clientId, @required String redirectUrl}) async {
    final String token = await _channel.invokeMethod(
        "getAuthToken", {"clientId": clientId, "redirectUrl": redirectUrl});
    return token;
  }


}

enum ImageDimension{
  THUMBNAIL,X_SMALL,SMALL,MEDIUM,LARGE
}
