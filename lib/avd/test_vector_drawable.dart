import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'dart:ui' show window;
import 'dart:async' show Future;
import 'package:maui/avd/vector_drawable.dart';

class TestVectorDrawable extends StatefulWidget {
  @override
  _TestVectorDrawableState createState() {
    return new _TestVectorDrawableState();
  }
}

class _TestVectorDrawableState extends State<TestVectorDrawable> {
  final vectorDrawableXml = '''<?xml version="1.0"?>
 <vector xmlns:android="http://schemas.android.com/apk/res/android"
     android:height="64dp"
     android:width="64dp"
     android:viewportHeight="600"
     android:viewportWidth="600" >
     <group
         android:name="rotationGroup"
         android:pivotX="300.0"
         android:pivotY="300.0"
         android:rotation="45.0" >
         <path
             android:name="v"
             android:fillColor="#000000"
             android:pathData="M300,70 l 0,-70 70,70 0,0 -70,70z" />
     </group>
 </vector>''';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('VectorDrawable'),
        ),
        body: new VectorDrawable(vectorDrawableXml: vectorDrawableXml,)
    );

  }
}