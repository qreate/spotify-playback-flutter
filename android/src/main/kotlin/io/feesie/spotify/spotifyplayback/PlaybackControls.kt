package io.feesie.spotify.spotifyplayback

import com.spotify.android.appremote.api.SpotifyAppRemote
import io.flutter.plugin.common.MethodChannel.Result

class PlaybackControls(val mSpotifyAppRemote: SpotifyAppRemote?) : BaseControl(mSpotifyAppRemote) {

  /**
   * Play an Spotify track by passing the Spotify track/playlist/album id
   * If the Spotify play call is successful return true
   */
  internal fun play(
    spotifyUri: String?,
    result: Result
  ) {
    if (mSpotifyAppRemote != null && spotifyUri != null) {
      mSpotifyAppRemote.playerApi.play(spotifyUri)
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("play", "error", "no SpotifyAppRemote $spotifyUri")
    }
  }

  /**
   * Pauses the currently playing spotify track, if successful return true
   */
  internal fun pause(
    result: Result
  ) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote.playerApi.pause()
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("pause", "error", "no SpotifyAppRemote")
    }
  }

  /**
   * Resumes the currently paused spotify track, if successful return true
   */
  internal fun resume(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote.playerApi.resume()
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("resume", "error", "no SpotifyAppRemote")
    }
  }

  /**
   * Add songs / playlist / albums to the queue
   */
  internal fun queue(
    spotifyUri: String?,
    result: Result
  ) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote.playerApi.queue(spotifyUri)
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("paqueueuse", "error", "no SpotifyAppRemote")
    }
  }

  /**
   * Plays the next song in the list
   */
  internal fun skipNext(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote.playerApi.skipNext()
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("next", "error", "no SpotifyAppRemote")
    }
  }

  /**
   * Plays the next song in the list
   */
  internal fun skipPrevious(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote.playerApi.skipPrevious()
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("prev", "error", "no SpotifyAppRemote")
    }
  }

  /**
   * Toggles repeat modes
   */
  internal fun toggleRepeat(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote.playerApi.toggleRepeat()
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("repeat", "error", "no SpotifyAppRemote")
    }
  }

  /**
   * Toggles shuffle modes
   */
  internal fun toggleShuffle(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote.playerApi.toggleShuffle()
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("shuffle", "error", "no SpotifyAppRemote")
    }
  }

}