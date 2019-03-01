import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:spotify_playback/spotify_playback.dart';
import 'dart:convert';

void main() => runApp( MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() =>  _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _connectedToSpotify = false;
  Uint8List image;

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

 /// Seek to a defined time in a song
  Future<void> seekTo() async {
    try {
      await SpotifyPlayback.seekTo(20000).then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
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

  /// Play the previous song
  Future<void> playPrev() async {
    try {
      await SpotifyPlayback.playPrev().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
    }
  }

//Play the next song
 Future<void> playNext() async {
    try {
      await SpotifyPlayback.playNext().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
    }
  }

  /// Play the previous song
  Future<void> toggleShuffle() async {
    try {
      await SpotifyPlayback.toggleShuffle().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
    }
  }

//Play the next song
 Future<void> toggleRepeat() async {
    try {
      await SpotifyPlayback.toggleRepeat().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
    }
  }

  //Play the next song
 Future<void> getImage() async {
    try {
      await SpotifyPlayback.getImage("spotify:image:8488e30949e687f92b23f69d696faa42f1b50207").then((success) {
        print(success);
       setState(() {
          image = success;
       });
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  Scaffold(
        appBar:  AppBar(
          title: const Text('Spotify plugin example app'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
           Center(
            child:  Text('Connected to spotify: $_connectedToSpotify\n'),
          ),
          Wrap(
            children: <Widget>[
               RaisedButton(
                onPressed: () => play("spotify:track:7zFXmv6vqI4qOt4yGf3jYZ"),
                child: Text("play"),
              ),
               RaisedButton(
                onPressed: () => resume(),
                child: Text("resume"),
              ),
               RaisedButton(
                onPressed: () => pause(),
                child: Text("pause"),
              ),  RaisedButton(
                onPressed: () => playPrev(),
                child: Text("Prev"),
              ),
               RaisedButton(
                onPressed: () => playNext(),
                child: Text("Next"),
              ),RaisedButton(
                onPressed: () => toggleShuffle(),
                child: Text("Shuffle"),
              ),RaisedButton(
                onPressed: () => toggleRepeat(),
                child: Text("Repeat"),
              ),RaisedButton(
                onPressed: () => getImage(),
                child: Text("Get Image"),
              ),
              
              
               RaisedButton(
            onPressed: () => getPlaybackPosition(),
            child: Text("position"),
          ),
           RaisedButton(
            onPressed: () => monitorPlaybackPosition(),
            child: Text("monitorPlaybackPosition"),
          ),
          RaisedButton(onPressed: ()=>seekTo(),child: Text("Seek"),)
            ],
          ),
          image != null?Image.memory(image,height: 100,width: 100,):Text("Image")


        ]),
      ),
    );
  }
}
