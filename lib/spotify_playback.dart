import 'dart:async';

import 'package:flutter/services.dart';

class SpotifyPlayback {
  static const MethodChannel _channel = const MethodChannel('spotify_playback');
  static const EventChannel _status_channel =
      const EventChannel('spotify_playback_status');

  static Future<bool> spotifyConnect(
      String clientId, String redirectUrl) async {
    final bool connected = await _channel.invokeMethod(
        "connectSpotify", {"clientId": clientId, "redirectUrl": redirectUrl});
    return connected;
  }

  static Future<bool> play(String id) async {
    final bool success = await _channel.invokeMethod("playSpotify", {"id": id});
    return success;
  }

  static Future<bool> pause() async {
    final bool paused = await _channel.invokeMethod("pauseSpotify");
    return paused;
  }

  static Future<bool> resume() async {
    final bool resumed = await _channel.invokeMethod("resumeSpotify");
    return resumed;
  }

  static Future<int> getPlaybackPosition() async {
    final int position = await _channel.invokeMethod("playbackPositionSpotify");
    return position;
  }

  static Future<bool> isConnected() async {
    final bool connected = await _channel.invokeMethod("isConnected");
    return connected;
  }

  static Future<String> getCurrentlyPlayingTrack() async {
    final String track =
        await _channel.invokeMethod("getCurrentlyPlayingTrack");
    return track;
  }

  static Stream enableTimer() {
    return _status_channel.receiveBroadcastStream(
        {"clientId": "clientId", "redirectUrl": "redirectUrl"});
  }
}
