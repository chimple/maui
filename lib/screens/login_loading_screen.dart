import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class LoginLoadingScreen extends StatefulWidget {
  @override
  _LoginLoadingScreenState createState() => _LoginLoadingScreenState();
}

class _LoginLoadingScreenState extends State<LoginLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlareActor(
          "assets/loading_screen/chimp_loading.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: 'loading',
        ),
      ],
    );
  }
}
