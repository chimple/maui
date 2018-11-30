package sutara.org.maui

import java.io.File
import java.io.InputStream
import java.io.OutputStream
import java.io.FileOutputStream
import android.os.Bundle
import android.speech.tts.TextToSpeech
import android.content.Intent
import java.util.Locale

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import com.rivescript.Config
import com.rivescript.RiveScript
import org.chimple.flores.db.AppDatabase
import org.chimple.flores.multicast.MulticastManager
import org.chimple.flores.manager.BluetoothManager
import org.chimple.flores.application.P2PContext



class MainActivity(): FlutterActivity(),TextToSpeech.OnInitListener {
  private val CHANNEL = "org.sutara.maui/rivescript"
  private var tts: TextToSpeech? = null  


  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    println("onCreate")
    GeneratedPluginRegistrant.registerWith(this)
    tts = TextToSpeech(this, this)
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
        println("RiveScript: " + reply)
        result.success(reply)
      } else if(call.method == "speak") {
        tts!!.speak(call.argument("text"), TextToSpeech.QUEUE_FLUSH, null,"")
      } else {
        result.notImplemented()
      }
    }
    P2PContext.getInstance().initialize(this);



  }

  override fun onInit(status: Int) {
    println("onInit")
    if (status == TextToSpeech.SUCCESS) {
      // set US English as language for tts
      val result = tts!!.setLanguage(Locale.US)

      if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
        println("TTS The Language specified is not supported!")
      }

    } else {
      println("TTS Initilization Failed!")
    }

  }

  override fun onResume() {
    super.onResume()
    println("onResume")
    val intent = Intent()
    intent.setClassName("org.chimple.bali", "org.chimple.bali.service.TollBroadcastReceiver")
    intent.putExtra("onResume", "sutara.org.maui")
    sendBroadcast(intent)
  }

  override fun onPause() {
    super.onPause()
    println("onPause")
    val intent = Intent()
    intent.setClassName("org.chimple.bali", "org.chimple.bali.service.TollBroadcastReceiver")
    intent.putExtra("onPause", "sutara.org.maui")
    sendBroadcast(intent)
  }

  public override fun onDestroy() {
    println("onDestroy")
    P2PContext.getInstance().onCleanUp();
    MulticastManager.getInstance(this).onCleanUp()
    BluetoothManager.getInstance(this).onCleanUp()

    // Shutdown TTS
    if (tts != null) {
      tts!!.stop()
      tts!!.shutdown()
    }
    super.onDestroy()
  }


  companion object {

        private var appLaunched: Boolean = false;
        
        fun appLaunched() {
          appLaunched = true;
        }

        fun isAppLaunched(): Boolean {
          return appLaunched;
        }
    }
}
