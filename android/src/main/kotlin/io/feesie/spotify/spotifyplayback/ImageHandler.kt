package io.feesie.spotify.spotifyplayback

import android.graphics.Bitmap
import com.spotify.android.appremote.api.SpotifyAppRemote
import com.spotify.protocol.types.Image.Dimension
import com.spotify.protocol.types.ImageUri
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors

class ImageHandler(val mSpotifyAppRemote: SpotifyAppRemote?) : BaseControl(mSpotifyAppRemote) {
  companion object {
    @JvmStatic
    private val executor = Executors.newFixedThreadPool(5)
  }

  private fun compressImage(
    image: Bitmap?,
    quality: Int?
  ): ByteArray? {
    val stream = ByteArrayOutputStream()
    image!!.compress(Bitmap.CompressFormat.PNG, quality?:100, stream)
    val byteArray = stream.toByteArray()
    image.recycle()
    return byteArray

  }

  /**
   * Gets the image as a Uint8List for flutter
   */
  internal fun getImage(
    uri: String?,
    quality: Int?,
    size: Int?,
    result: Result
  ) {
    if (mSpotifyAppRemote != null && uri != null) {
      mSpotifyAppRemote.imagesApi
          .getImage(ImageUri(uri), getImageSize(size = size))
          .setResultCallback { bitmap: Bitmap? ->
            executor.execute {
              try {
                result.success(compressImage(image = bitmap, quality = quality))
              } catch (e: Exception) {
                result.success(null)
              }
            }
          }
    } else {
      result.error("getImage", "error", "no SpotifyAppRemote")
    }
  }

  private fun getImageSize(size: Int?): Dimension {
    var dimension = Dimension.SMALL
    if (size == 144) dimension = Dimension.THUMBNAIL
    if (size == 240) dimension = Dimension.X_SMALL
    if (size == 360) dimension = Dimension.SMALL
    if (size == 480) dimension = Dimension.MEDIUM
    if (size == 720) dimension = Dimension.LARGE
    return dimension
  }
}