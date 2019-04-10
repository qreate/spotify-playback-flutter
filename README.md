# spotify_playback

[![CircleCI](https://circleci.com/gh/qreate/spotify-playback-flutter/tree/master.svg?style=svg)](https://circleci.com/gh/qreate/spotify-playback-flutter/tree/master) [![](https://img.shields.io/badge/pub-v0.0.7-brightgreen.svg)](https://pub.dartlang.org/packages/spotify_playback) [![](https://img.shields.io/badge/licence-MIT-blue.svg)](https://github.com/Joran-Dob/spotify-playback-flutter/blob/master/LICENSE.md)


Spotify Playback Plugin.

**No iOS Implementation yet, WIP..**

## Features
* Play (track / album / playlist)
* Resume / pause
* Queue
* Playback position
* Seek
* Seek to relative position
* Play Next
* Play Previous
* Repeat 
* Shuffle 

## Installation
**`IMPORTANT:` Make sure you have the Spotify app installed and that you are logged in or your test device!**

First, add `spotify_playback` as a dependency in your `pubspec.yaml` file. 

Afterwards, download the Spotify Android SDK [here](https://github.com/spotify/android-sdk/releases/tag/v0.6.1-appremote_v1.1.0-auth) and move the spotify-app-remote-release-x.x.x.aar file to `android/app/libs/` in your project.

Then initialize the spotify playback sdk like this 

```dart
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
``` 

After this you can use all the available methods

## Available methods 
| Method        | description           | parameters  |
| ------------- |:-------------:| -----:|
| spotifyConnect      | Initilizes the spotify playback sdk | clientId, redirectUrl |
| play      | Play's an spotify track, album or playlist | spotify uri |
| pause      | Pause's the currently playing track      |    |
| resume |  Resumes the currently paused track      |     |
| queue |  Adds an track / playlist / album to the queue     |   spotify uri  |
| skipNext      | Play's the next track | |
| skipPrevious      | Play's the previous track |  |
| seekTo |  Seeks to the passed time     |  time(mS)   |
|seekToRelativePosition|Seeks to relative position|+-time(mS)|
| toggleShuffle | Toggle shuffle options    |     |
| toggleShuffle | Toggle Repeat options    |     |
| getPlaybackPosition | Get's the current tracks playback position       |    |
| getImage | Gets a Uint8List encoded image(memoryImage)       |  imageUri  |
| imageLinkToURi | Takes an image url and returns image uri(for get image)    |  imageLink  |

## Example

Demonstrates how to use the spotify_playback plugin.

See the [example documentation](example/README.md) for more information.


## Function examples
### GetImage   
```dart
//You can provide an image uri
SpotifyPlayback.getImage("spotify:image:3269971d34d3f17f16efc2dfa95e302cc961a36c");

//Or you can provide an url returned webAPI
SpotifyPlayback.getImage(SpotifyPlayback.imageLinkToURi("https://i.scdn.co/image/3269971d34d3f17f16efc2dfa95e302cc961a36c"));

//Theese both return a Uint8List encoded image.
//You can then use the Image.memory() to display the image
Image.memory(yourUint8ListImageHere)

```

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## Special Thanks
 - Alexander Méhes | [BMXsanko](https://github.com/BMXsanko)

## Contributing

Feel free to contribute by opening issues and/or pull requests. Your feedback is very welcome!

## License

MIT License

Copyright (c) [2019] [Joran Dob]
Copyright (c) [2019] [QREATE]
