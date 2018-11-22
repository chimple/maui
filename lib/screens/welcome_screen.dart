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
  
  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 6200), (){
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
    return (delayed == true ) ? new TabHome() : new Scaffold(
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
                          aspectRatio: size.height > size.width ? 1.5 : 3.8,
                          child: new NimaActor(
                              "assets/quack",
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              animation: 'welcome with hello',
                              mixSeconds: 0.2,
                            ),),
                ])])));
  }
}
