#!/bin/sh

adb shell settings put global ntp_server 192.168.0.1
adb install adbjoinwifi.apk
adb shell am start -n com.steinwurf.adbjoinwifi/.MainActivity -e ssid XPRIZE
adb install bali.apk
adb shell pm grant org.chimple.bali android.permission.WRITE_EXTERNAL_STORAGE
adb shell am start -n "org.chimple.bali/org.chimple.bali.launcher.LauncherScreen"
adb shell cmd package set-home-activity  "org.chimple.bali/org.chimple.bali.launcher.LauncherScreen"
adb install goa.apk
adb install maui.apk
adb shell pm grant sutara.org.maui android.permission.CAMERA
adb shell pm grant sutara.org.maui android.permission.WRITE_EXTERNAL_STORAGE
adb shell pm grant sutara.org.maui android.permission.RECORD_AUDIO
adb shell pm grant sutara.org.maui android.permission.READ_PHONE_STATE
adb push maui_assets/assets/ /storage/emulated/0/
adb shell am start -n "org.chimple.bali/org.chimple.bali.launcher.LauncherScreen"
