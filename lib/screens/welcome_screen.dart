import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maui/screens/tab_home.dart';
import 'package:nima/nima_actor.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State createState() => new WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  bool delayed;
  String _animationName = "hello";

  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 6200), () {
      Navigator.of(context).pushReplacementNamed('/tab');
      setState(() {
        delayed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;

    // TODO: implement build
    return (delayed == true)
        ? new TabHome()
        : new Scaffold(
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
                                aspectRatio:
                                    size.height > size.width ? 1.5 : 3.8,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0, right: 40.0),
                                  child: new NimaActor(
                                    "assets/quack",
                                    alignment: Alignment.center,
                                    fit: BoxFit.scaleDown,
                                    animation: _animationName,
                                    mixSeconds: 0.2,
                                    completed: (String animationName) {
                                      setState(() {
                                        // Return to idle.
                                        _animationName = "idle";
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ])
                    ])));
  }
}
