package sutara.org.maui

import java.io.File
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
    bot.loadFile(File(getApplicationInfo().dataDir+"/app_flutter/testsuite.rs"))
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
