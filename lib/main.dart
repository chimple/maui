import 'package:flutter/material.dart';
import 'package:maui/app.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:flutter/services.dart';
import 'package:flores/flores.dart';

void main() {
  new Flores().start();
  runApp(new AppStateContainerController(
    child: new MauiApp(),
  ));
}
