package io.feesie.spotify.spotifyplayback

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors

class GetImageHandler(var image: Bitmap? , var result: MethodChannel.Result) {

    companion object {
        @JvmStatic
        private val executor = Executors.newFixedThreadPool(5)
    }

    fun handle() {
        executor.execute {
            try {
                result.success(compressImage(image))
            } catch (e: Exception) {
                result.success(null)
            }
        }
    }

    private fun compressImage(image:Bitmap?): ByteArray? {
        val stream = ByteArrayOutputStream()
        image!!.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val byteArray = stream.toByteArray()
        image.recycle()
        return byteArray

    }

}