import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maui/screens/tab_home.dart';
import 'package:nima/nima_actor.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State createState() => new WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  String _animationName = "quack";
  bool paused = false;

  void _complete() {
    setState(() {
      paused = true;
      _animationName = null;
    });
    Navigator.of(context).pushNamedAndRemoveUntil('/tab', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    return Scaffold(
        body: new Container(
            decoration: new BoxDecoration(
              color: const Color(0xFF0E4476),
            ),
            child: Align(
              alignment: AlignmentDirectional.center,
              child: new AspectRatio(
                aspectRatio: 1.0,
                child: new NimaActor("assets/quack",
                    paused: paused,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: _animationName,
                    // mixSeconds: 0.2,
                    completed: (_) => _complete()),
              ),
            )));
  }
}
