@ECHO OFF
:: Copyright 2012 The Android Open Source Project
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::      http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

PATH=%PATH%;"%SYSTEMROOT%\System32"
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

echo Press any key to exit...
pause >nul
exit
