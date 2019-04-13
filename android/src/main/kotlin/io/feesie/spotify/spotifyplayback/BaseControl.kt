package io.feesie.spotify.spotifyplayback

import com.spotify.android.appremote.api.SpotifyAppRemote

open class BaseControl(mSpotifyAppRemote: SpotifyAppRemote?) {
  init {
    if (mSpotifyAppRemote == null) {
      print("Spotify app remote is not initialize please call connectSpotify first")
    }
  }
}