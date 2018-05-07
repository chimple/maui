package sutara.org.maui

import java.io.File
import java.io.InputStream
import java.io.OutputStream
import java.io.FileOutputStream
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import com.rivescript.Config
import com.rivescript.RiveScript


class MainActivity(): FlutterActivity() {
  private val CHANNEL = "org.sutara.maui/rivescript"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    println("RiveScript")
    val bot = RiveScript()
    var rsFile = File(filesDir.toString()+"/testsuite.rs")
    if(!rsFile.exists()) {
      val afile = assets.open("testsuite.rs")
      var inStream: InputStream? = null

      inStream = afile
      val outStream = openFileOutput("testsuite.rs", 0)
      val buffer = ByteArray(1024)
      var length = inStream.read(buffer)
      while (length > 0 )
      {
        outStream.write(buffer, 0, length)
        length = inStream.read(buffer)
      }
      inStream.close()
      outStream.close()
      rsFile = File(filesDir.toString()+"/testsuite.rs")
    }

    bot.loadFile(rsFile)
    bot.sortReplies()

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "getReply") {
        val reply = bot.reply("user", call.argument("query"))
        println("RiveScript: "+reply)
        result.success(reply)
      } else {
        result.notImplemented()
      }
    }
  }
}
