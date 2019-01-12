import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:spotify_playback/spotify_playback.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _connectedToSpotify = false;

  @override
  void initState() {
    super.initState();
    initConnector();
  }

  /// Initialize the spotify playback sdk, by calling spotifyConnect
  Future<void> initConnector() async {
    try {
      await SpotifyPlayback.spotifyConnect(clientId: "", redirectUrl: "").then(
          (connected) {
        if (!mounted) return;
        // If the method call is successful, update the state to reflect this change
        setState(() {
          _connectedToSpotify = connected;
        });
      }, onError: (error) {
        // If the method call trows an error, print the error to see what went wrong
        print(error);
      });
    } on PlatformException {
      print('Failed to connect.');
    }
  }

  /// Play an song by spotify track/album/playlist id
  Future<void> play(String id) async {
    try {
      await SpotifyPlayback.play(id).then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
    }
  }

  /// Pause the currently playing track
  Future<void> pause() async {
    try {
      await SpotifyPlayback.pause().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to pause.');
    }
  }

  /// Resume the currently paused track
  Future<void> resume() async {
    try {
      await SpotifyPlayback.resume().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to resume.');
    }
  }

  /// Gets the currently playing track's playback position
  Future<void> getPlaybackPosition() async {
    try {
      await SpotifyPlayback.getPlaybackPosition().then((position) {
        print(
            "playback position -->\nmin:${DateTime.fromMillisecondsSinceEpoch(position).minute}\nseconds:${DateTime.fromMillisecondsSinceEpoch(position).second}");
        return position;
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to resume.');
    }
  }

  /// Gets the currently playing track information
  Future<void> getCurrentlyPlayingTrack() async {
    try {
      SpotifyPlayback.getCurrentlyPlayingTrack().then((track) {
        print("track:\n$track");
      });
    } on PlatformException {
      print('Failed to resume.');
    }
  }

  /// Sets an listener on the current track's playback position
  /// Needs changes and is currently not in use
  @deprecated
  Future<void> monitorPlaybackPosition() async {
    try {
      print("Enable timer");
      SpotifyPlayback.enableTimer().listen((val) {
        print("track:\n$val");
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to resume.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Spotify plugin example app'),
        ),
        body: Column(children: <Widget>[
          new Center(
            child: new Text('Connected to spotify: $_connectedToSpotify\n'),
          ),
          new RaisedButton(
            onPressed: () => play("spotify:track:7zFXmv6vqI4qOt4yGf3jYZ"),
            child: Text("play"),
          ),
          new RaisedButton(
            onPressed: () => resume(),
            child: Text("resume"),
          ),
          new RaisedButton(
            onPressed: () => pause(),
            child: Text("pause"),
          ),
          new RaisedButton(
            onPressed: () => getPlaybackPosition(),
            child: Text("position"),
          ),
          new RaisedButton(
            onPressed: () => monitorPlaybackPosition(),
            child: Text("monitorPlaybackPosition"),
          ),
        ]),
      ),
    );
  }
}
