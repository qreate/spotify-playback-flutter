package io.feesie.spotify.spotifyplayback

import android.graphics.Bitmap
import com.spotify.android.appremote.api.SpotifyAppRemote
import com.spotify.protocol.types.Image
import com.spotify.protocol.types.Image.Dimension
import com.spotify.protocol.types.ImageUri
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream

class ImageHandler(val mSpotifyAppRemote: SpotifyAppRemote?) : BaseControl(mSpotifyAppRemote) {
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
            val stream = ByteArrayOutputStream()
            bitmap!!.compress(Bitmap.CompressFormat.JPEG, (quality ?: 100), stream)
            val byteArray = stream.toByteArray()
            bitmap.recycle()
            result.success(byteArray)
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