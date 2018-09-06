import 'package:flutter/material.dart';
import 'package:maui/app.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() async {
  print('main');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('deviceId') == null) {
    prefs.setString('deviceId', Uuid().v4());
  }
  runApp(new AppStateContainer(
    child: new MauiApp(),
  ));
}
