package io.feesie.spotify.playback

import android.util.Log
import com.spotify.android.appremote.api.ConnectionParams
import com.spotify.android.appremote.api.Connector
import com.spotify.android.appremote.api.SpotifyAppRemote
import com.spotify.protocol.types.PlayerState
import com.spotify.protocol.types.Track
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler

class SpotifyPlaybackPlugin(private var registrar: PluginRegistry.Registrar) : MethodCallHandler,
    StreamHandler {

  private var mSpotifyAppRemote: SpotifyAppRemote? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "spotify_playback")
      channel.setMethodCallHandler(SpotifyPlaybackPlugin(registrar))
      val eventChannel = EventChannel(registrar.messenger(), "spotify_playback_status")
      eventChannel.setStreamHandler(SpotifyPlaybackPlugin(registrar))
    }
  }

  override fun onMethodCall(
    call: MethodCall,
    result: Result
  ) {
    if (call.method == ("connectSpotify")) {
      spotifyConnect(call.argument("clientId"), call.argument("redirectUrl"), result)
    } else if (call.method == "playSpotify") {
      play(call.argument("id"), result)
    } else if (call.method == ("pauseSpotify")) {
      pause(result)
    } else if (call.method == ("resumeSpotify")) {
      resume(result)
    } else if (call.method == ("playbackPositionSpotify")) {
      getPlaybackPosition(result)
    }
  }

  override fun onListen(
    p0: Any?,
    eventSink: EventSink
  ) {
    onPlaybackPosition(eventSink)
  }

  override fun onCancel(p0: Any?) {
    TODO(
        "not implemented"
    ) //To change body of created functions use File | Settings | File Templates.
  }

  fun spotifyConnect(
    clientId: String?,
    redirectUrl: String?,
    result: Result
  ) {
    if (clientId != null && redirectUrl != null) {
      val connectionParams = ConnectionParams.Builder(clientId)
          .setRedirectUri(redirectUrl)
          .showAuthView(true)
          .build()


      SpotifyAppRemote.CONNECTOR.connect(registrar.context(), connectionParams,
          object : Connector.ConnectionListener {

            override fun onConnected(spotifyAppRemote: SpotifyAppRemote) {
              mSpotifyAppRemote = spotifyAppRemote
              Log.d("MainActivity", "Connected! Yay!")
              result.success(true)
            }

            override fun onFailure(throwable: Throwable) {
              result.error("connect", "error", throwable)
              // Something went wrong when attempting to connect! Handle errors here
            }
          })
    }
  }

  private fun play(
    spotifyUrl: String?,
    result: Result
  ) {
    if (mSpotifyAppRemote != null && spotifyUrl != null) {
      mSpotifyAppRemote!!.playerApi.play(spotifyUrl)
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("play", "error", "no SpotifyAppRemote")
    }
  }

  private fun pause(
    result: Result
  ) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote!!.playerApi.pause()
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("pause", "error", "no SpotifyAppRemote")
    }
  }

  private fun resume(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote!!.playerApi.resume()
          .setResultCallback {
            result.success(true)
          }
    } else {
      result.error("resume", "error", "no SpotifyAppRemote")
    }
  }

  private fun getPlaybackPosition(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote!!.playerApi.subscribeToPlayerState()
          .setEventCallback { playerState: PlayerState? ->
            val position = playerState!!.playbackPosition
            result.success(position)
          }
    }
  }

  private fun connected() {
    // Then we will write some more code here.
    mSpotifyAppRemote!!.playerApi
        .subscribeToPlayerState()
        .setEventCallback { playerState ->
          val track: Track = playerState!!.track
        };

  }

  private fun onPlaybackPosition(
    events: EventChannel.EventSink
  ) {
    print("adding listener")
    mSpotifyAppRemote!!.playerApi.subscribeToPlayerState()
        .setEventCallback { playerState: PlayerState? ->
          val position = playerState!!.playbackPosition
          events.success(position)
        }
  }

}
