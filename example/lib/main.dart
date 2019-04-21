import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:spotify_playback/spotify_playback.dart';
import 'credentials.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _connectedToSpotify = false;
  Uint8List image = null;

  @override
  void initState() {
    super.initState();
    initConnector();
  }

  /// Initialize the spotify playback sdk, by calling spotifyConnect
  Future<void> initConnector() async {
    try {
      await SpotifyPlayback.spotifyConnect(
              clientId: Credentials.clientId,
              redirectUrl: Credentials.redirectUrl)
          .then((connected) {
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

  /// Add an song / playlist / album to the playback queue
  Future<void> queue(String id) async {
    try {
      await SpotifyPlayback.queue(id).then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to queue.');
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

  /// Seek to a a defined time relative to the current time
  Future<void> seekToRelativePosition() async {
    try {
      await SpotifyPlayback.seekToRelativePosition(5000).then((success) {
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
  Future<void> skipPrevious() async {
    try {
      await SpotifyPlayback.skipPrevious().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
    }
  }

  ///Play the next song
  Future<void> skipNext() async {
    try {
      await SpotifyPlayback.skipNext().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play next song.');
    }
  }

  /// Toggle shuffle
  Future<void> toggleShuffle() async {
    try {
      await SpotifyPlayback.toggleShuffle().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to toggle shuffle.');
    }
  }

  /// Toggle repeat
  Future<void> toggleRepeat() async {
    try {
      await SpotifyPlayback.toggleRepeat().then((success) {
        print(success);
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to toggle repeat.');
    }
  }

  /// Get the image by provided uri
  Future<void> getImage(String uri) async {
    try {
      await SpotifyPlayback.getImage(uri: uri, quality: 100, size: ImageDimension.LARGE).then(
          (imageReceived) {
        setState(() {
          image = imageReceived;
        });
      }, onError: (error) {
        print(error);
      });
    } on PlatformException {
      print('Failed to play.');
    }
  }

    Future<void> getAuthToken() async {
    try {
      SpotifyPlayback.getAuthToken(clientId: Credentials.clientId,redirectUrl: Credentials.redirectUrl).then((authToken){
        print(authToken);
      });

    } on PlatformException {
      print('Failed to play.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Spotify plugin example app'),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text('Connected to spotify: $_connectedToSpotify\n'),
              ),
              Wrap(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () =>
                        play("spotify:track:7zFXmv6vqI4qOt4yGf3jYZ"),
                    child: Text("Play"),
                  ),
                  RaisedButton(
                    onPressed: () => resume(),
                    child: Text("Resume"),
                  ),
                  RaisedButton(
                    onPressed: () => pause(),
                    child: Text("Pause"),
                  ),
                  RaisedButton(
                    onPressed: () =>
                        queue("spotify:track:6b6liLOZhXdOfFBFVN5KNK"),
                    child: Text("Queue"),
                  ),
                  RaisedButton(
                    onPressed: () => skipPrevious(),
                    child: Text("Prev"),
                  ),
                  RaisedButton(
                    onPressed: () => skipNext(),
                    child: Text("Next"),
                  ),
                  RaisedButton(
                    onPressed: () => toggleShuffle(),
                    child: Text("Shuffle"),
                  ),
                  RaisedButton(
                    onPressed: () => toggleRepeat(),
                    child: Text("Repeat"),
                  ),
                  RaisedButton(
                    onPressed: () => getPlaybackPosition(),
                    child: Text("Position"),
                  ),
                  RaisedButton(
                    onPressed: () => monitorPlaybackPosition(),
                    child: Text("MonitorPlaybackPosition"),
                  ),
                  RaisedButton(
                    onPressed: () => seekTo(),
                    child: Text("Seek"),
                  ),
                  RaisedButton(
                    onPressed: () => seekToRelativePosition(),
                    child: Text("Seek Relative(+5s)"),
                  ),
                  RaisedButton(
                      onPressed: () => getImage(
                            SpotifyPlayback.imageLinkToURi(
                                "https://i.scdn.co/image/3269971d34d3f17f16efc2dfa95e302cc961a36c"),
                          ),
                      child: Text("Get image")),

                  RaisedButton(
                    onPressed: () => getAuthToken(),
                    child: Text("Auth token"),
                  ),

                  (image != null)
                      ? Image.memory(
                          image,
                          height: 100,
                        )
                      : Text("Image Placeholder")
                ],
              ),
            ]),
      ),
    );
  }
}
