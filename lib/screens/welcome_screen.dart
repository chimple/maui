import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maui/screens/tab_home.dart';
import 'package:nima/nima_actor.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State createState() => new WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  String _animationName = "hello";
  bool paused = false;

  void _complete() {
    setState(() {
      paused = true;
      _animationName = null;
    });
    Navigator.of(context).pushReplacementNamed('/tab');
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
            child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: new AspectRatio(
                            aspectRatio: size.height > size.width ? 1.5 : 3.8,
                            child: new NimaActor("assets/quack",
                                paused: paused,
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                animation: _animationName,
                                // mixSeconds: 0.2,
                                completed: (_) => _complete()),
                          ),
                        ),
                      ])
                ])));
  }
}
