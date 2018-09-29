import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'stagger_animation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:maui/components/signin_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State createState() => new WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;

  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    // TODO: implement build
    return new Scaffold(
        body: new Container(
            decoration: new BoxDecoration(
              color: Colors.purple,
            ),
            child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new AspectRatio(
                          aspectRatio: 2.5,
                          child: new SvgPicture.asset(
                            "assets/team animals.svg",
                            allowDrawingOutsideViewBox: false,
                          )),
                      new Text(
                        "Maui",
                        style: new TextStyle(
                          fontSize: 72.0,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  animationStatus == 0
                      ? new Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: new InkWell(
                              onTap: () {
                                setState(() {
                                  animationStatus = 1;
                                });
                                _playAnimation();
                              },
                              child: new SignIn()),
                        )
                      : new StaggerAnimation(
                          buttonController: _loginButtonController.view),
                ])));
  }
}
