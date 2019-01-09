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

  Future<void> initConnector() async {
    try {
      await SpotifyPlayback.spotifyConnect(
              "0bf5d4f747074014853346a374007765", "feesie://auth")
          .then((connected) {
        if (!mounted) return;

        setState(() {
          _connectedToSpotify = connected;
        });
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to connect.');
    }
  }

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

  Future<void> getCurrentlyPlayingTrack() async {
    try {
      SpotifyPlayback.getCurrentlyPlayingTrack().then((track) {
        print("track:\n$track");
      });
    } on PlatformException {
      print('Failed to resume.');
    }
  }

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
          title: const Text('Plugin example app'),
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
