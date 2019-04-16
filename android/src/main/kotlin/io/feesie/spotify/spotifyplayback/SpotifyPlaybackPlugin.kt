package io.feesie.spotify.playback

import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.os.Parcel
import android.util.Log
import com.spotify.android.appremote.api.ConnectionParams
import com.spotify.android.appremote.api.Connector
import com.spotify.android.appremote.api.SpotifyAppRemote
import com.spotify.protocol.types.PlayerState
import com.spotify.protocol.types.Track
import io.feesie.spotify.spotifyplayback.ImageHandler
import io.feesie.spotify.spotifyplayback.PlaybackControls
import io.feesie.spotify.spotifyplayback.SeekControls
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlin.concurrent.fixedRateTimer

import com.spotify.sdk.android.authentication.AuthenticationClient;
import com.spotify.sdk.android.authentication.AuthenticationHandler
import com.spotify.sdk.android.authentication.AuthenticationRequest;
import com.spotify.sdk.android.authentication.AuthenticationResponse;



class SpotifyPlaybackPlugin(private var registrar: PluginRegistry.Registrar) : MethodCallHandler,
    StreamHandler {

  // The SpotifyAppRemote global reference
  private var mSpotifyAppRemote: SpotifyAppRemote? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {

      // Register the spotify playback method channel to call the methods from dart
      val channel = MethodChannel(registrar.messenger(), "spotify_playback")
      channel.setMethodCallHandler(SpotifyPlaybackPlugin(registrar))

      // Register the spotify playback status event channel to set listeners from dart
      val eventChannel = EventChannel(registrar.messenger(), "spotify_playback_status")
      eventChannel.setStreamHandler(SpotifyPlaybackPlugin(registrar))
    }
  }

  /**
   * When an method call is method to the spotify_playback methodChannel
   * It will be handled here, and the correct function will be called
   */
  override fun onMethodCall(
    call: MethodCall,
    result: Result
  ) {
    val playbackControls = PlaybackControls(mSpotifyAppRemote = mSpotifyAppRemote)
    val seekControls = SeekControls(mSpotifyAppRemote = mSpotifyAppRemote)
    val imageHandler = ImageHandler(mSpotifyAppRemote = mSpotifyAppRemote)
    when {
      call.method == "connectSpotify" -> spotifyConnect(
          call.argument("clientId"), call.argument("redirectUrl"), result
      )
      call.method == "playSpotify" -> playbackControls.play(
          spotifyUri = call.argument("id"), result = result
      )
      call.method == "pauseSpotify" -> playbackControls.pause(result = result)
      call.method == "resumeSpotify" -> playbackControls.resume(result = result)
      call.method == "queue" -> playbackControls.queue(
          spotifyUri = call.argument("id"), result = result
      )
      call.method == "playbackPositionSpotify" -> getPlaybackPosition(result)
      call.method == "isConnected" -> connected(result)
      call.method == "getCurrentlyPlayingTrack" -> getCurrentlyPlayingTrack(result = result)
      call.method == "skipNext" -> playbackControls.skipNext(result = result)
      call.method == "skipPrevious" -> playbackControls.skipPrevious(result = result)
      call.method == "seekTo" -> seekControls.seekTo(time = call.argument("time"), result = result)
      call.method == "seekToRelativePosition" -> seekControls.seekToRelativePosition(
          relativeTime = call.argument("relativeTime"), result = result
      )
      call.method == "toggleRepeat" -> playbackControls.toggleRepeat(result = result)
      call.method == "toggleShuffle" -> playbackControls.toggleShuffle(result = result)
      call.method == "getImage" -> imageHandler.getImage(
          uri = call.argument("uri"), result = result, quality = call.argument("quality"),
          size = call.argument("size")
      )
      call.method == "getAuthToken" -> getAuthToken(
              clientId = call.argument("clientId"),
              redirectUrl = call.argument("redirectUrl"),
              result = result)
    }
  }

    //THIS SHOULD ONLY BE CALLED ONCE
    private fun getAuthToken(clientId: String?,
                     redirectUrl: String?,
                     result: Result){

try {
    AuthenticationClient.openLoginActivity(
            registrar.activity(), 1337,
            AuthenticationRequest.Builder(clientId,AuthenticationResponse.Type.TOKEN,redirectUrl)
                    .setScopes(arrayOf("user-modify-playback-state")).build())
}catch (err:Throwable){
    Log.v("getAuthTOkenError",err.message)
}
    registrar.addActivityResultListener { requestCode, resultCode, intent ->
        if (requestCode == 1337){
            result.success(AuthenticationClient.getResponse(resultCode,intent).accessToken)
        }
        true
    }
    }



  /**
   * The onlisten for the eventChannel is still in active development
   * This eventChannel onListen is used to inform the application about changes to the
   * current playback state such as play/pause actions and track changes
   */
  override fun onListen(
    arguments: Any,
    eventSink: EventSink
  ) {
    val clientId = ""
    val redirectUrl = ""

    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote!!.playerApi.subscribeToPlayerState()
          .setEventCallback { playerState: PlayerState? ->
            val position = playerState!!.playbackPosition
            eventSink.success(position)
          }
    } else {
      val connectionParams = ConnectionParams.Builder(clientId)
          .setRedirectUri(redirectUrl)
          .showAuthView(true)
          .build()

      SpotifyAppRemote.connect(registrar.context(), connectionParams,
          object : Connector.ConnectionListener {
            override fun onConnected(spotifyAppRemote: SpotifyAppRemote) {
              mSpotifyAppRemote = spotifyAppRemote
              fixedRateTimer("default", false, 0L, 1000) {

                spotifyAppRemote.playerApi.subscribeToPlayerState()
                    .setEventCallback { playerState: PlayerState? ->
                      val track: Track = playerState!!.track
                      val trackDuration = track.duration
                      if (trackDuration > playerState.playbackPosition) {
                        eventSink.success(playerState.playbackPosition)
                      }
                    }
              }
            }

            override fun onFailure(throwable: Throwable) {
              // Something went wrong when attempting to connect! Handle errors here
              eventSink.error("connect", "error", throwable)
            }
          })
    }

  }

  override fun onCancel(p0: Any?) {

  }

  /**
   * Initializes the Spotify sdk, by passing the clientId and redirectUrl
   * If successful returns true, else returns the error the sdk threw
   */
  private fun spotifyConnect(
    clientId: String?,
    redirectUrl: String?,
    result: Result
  ) {
    if (clientId != null && redirectUrl != null) {

      val connectionParams = ConnectionParams.Builder(clientId)
          .setRedirectUri(redirectUrl)
          .showAuthView(true)
          .build()

      SpotifyAppRemote.connect(registrar.context(), connectionParams,
          object : Connector.ConnectionListener {
            override fun onConnected(spotifyAppRemote: SpotifyAppRemote) {
              mSpotifyAppRemote = spotifyAppRemote
              result.success(true)
            }

            override fun onFailure(throwable: Throwable) {
              result.error("connect", "error", throwable)
            }
          })
    }
  }

  /**
   * Get the currently playing tracks position, if successful returns the position
   */
  private fun getPlaybackPosition(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote!!.playerApi.subscribeToPlayerState()
          .setEventCallback { playerState: PlayerState? ->
            val position = playerState!!.playbackPosition
            result.success(position)
          }
    }
  }


  /**
   * Get if the spotify sdk is connected, if so return true
   */
  private fun connected(result: Result) {
    return if (mSpotifyAppRemote != null) {
      result.success(mSpotifyAppRemote!!.isConnected)
    } else {
      result.success(false)
    }
  }

  /**
   * Gets the currently playing track information and returns it as an Json string
   */
  private fun getCurrentlyPlayingTrack(result: Result) {
    if (mSpotifyAppRemote != null) {
      mSpotifyAppRemote!!.playerApi.subscribeToPlayerState()
          .setEventCallback { playerState: PlayerState? ->
            val track: Track = playerState!!.track
            result.success(track)

          }
    } else {
      result.error("error", "no mSpotifyAppRemote", "is null")

    }
  }

  @Deprecated(message = "The function is not stable and should not be used")
  private fun onPlaybackPosition(
    events: EventChannel.EventSink
  ) {
    print("adding listener")
    if (mSpotifyAppRemote != null) {

      events.success("adding listener")

      mSpotifyAppRemote!!.playerApi.subscribeToPlayerState()
          .setEventCallback { playerState: PlayerState? ->
            val track: Track = playerState!!.track
            Log.d("MainActivity", track.name + " by " + track.artist.name)

            val position = playerState.playbackPosition
            events.success(position)
          }
    } else {
      events.error("error", "no mSpotifyAppRemote", "is null")
    }
  }

}
