package io.feesie.spotify.spotifyplayback

import com.spotify.android.appremote.api.SpotifyAppRemote
import io.flutter.plugin.common.MethodChannel.Result

class SeekControls(val mSpotifyAppRemote: SpotifyAppRemote?) : BaseControl(mSpotifyAppRemote) {
  /**
   * Seek To a specified time in the song playing
   */
  internal fun seekTo(
    time: String?,
    result: Result
  ) {
    if (mSpotifyAppRemote != null && time != null) {
      mSpotifyAppRemote.playerApi.seekTo(time.toLong())
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("seekTo", "error", "no SpotifyAppRemote")
    }
  }

  /**
   * Seek To relative position
   */
  internal fun seekToRelativePosition(
    relativeTime: String?,
    result: Result
  ) {
    if (mSpotifyAppRemote != null && relativeTime != null) {
      mSpotifyAppRemote.playerApi.seekToRelativePosition(relativeTime.toLong())
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("seekTo", "error", "no SpotifyAppRemote")
    }
  }
}