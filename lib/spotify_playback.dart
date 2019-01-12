import 'dart:async';

import 'package:flutter/services.dart';

class SpotifyPlayback {
  /// Spotify playback method channel
  /// The method channel is used to call methods and wait for an response
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

  /// The getPlaybackPosition method is used to get the current tracks playback position
  static Future<int> getPlaybackPosition() async {
    final int position = await _channel.invokeMethod("playbackPositionSpotify");
    return position;
  }

  /// The is connected method is used to check if
  /// the spotify player is correctly Initialized
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
}
