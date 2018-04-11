import 'package:flutter/material.dart';
import 'package:maui/app.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:flutter/rendering.dart';

void main() {
    debugPaintSizeEnabled = true;
    runApp(new AppStateContainerController(child: new MauiApp(),));
}
