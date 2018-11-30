import 'package:flutter/material.dart';
import 'package:maui/loca.dart';

class SignIn extends StatelessWidget {
  SignIn();
  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: 320.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: const Color.fromRGBO(247, 64, 106, 1.0),
        borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: new Text(
        Loca.of(context).signIn,
        style: new TextStyle(
          color: Colors.amber,
          fontSize: 36.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    ));
  }
}

