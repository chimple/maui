package sutara.org.maui


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import sutara.org.maui.MainActivity
import android.app.Activity
import android.os.Build
import android.os.Bundle

class AutoLaunchReceiver : BroadcastReceiver() {
 
    override fun onReceive(context: Context, intent: Intent) {
        val message = "Broadcast intent detected " + intent.action
    	println("AutoLaunchReceiver onReceive called: " + message);

    	if(MainActivity.isAppLaunched()) {
			println("App is already launched ...");    		
    	} else {
    		if (Intent.ACTION_BOOT_COMPLETED.equals(intent.action) && !MainActivity.isAppLaunched()) {
				println("Boot event received ... Launching Flores");
				MainActivity.appLaunched();	
				val intent = Intent(context, MainActivity::class.java)
				intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
				intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
				context.startActivity(intent)
	        } else if(!MainActivity.isAppLaunched() && Intent.ACTION_POWER_CONNECTED.equals(intent.action))
	        {
	        	println("Power event received ... Launching Flores");				
    			MainActivity.appLaunched();    	
				val intent = Intent(context, MainActivity::class.java)
				intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
				intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
				context.startActivity(intent)    			
			}
    	}
    }
}