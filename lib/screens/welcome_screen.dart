import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State createState() => new WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {  

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    // TODO: implement build
    return new Scaffold(
        backgroundColor: Colors.purple,
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            new Container(
              width: size.width * 0.8,
              child: new RaisedButton(
              shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(16.0))),
              child: new AspectRatio(
                  aspectRatio: 2.0,
                  child: new SvgPicture.asset(
                    "assets/team animals.svg",
                    allowDrawingOutsideViewBox: false,
                  )),
            ),
            ),
            new Text(
              "Maui",
              style: new TextStyle(
                fontSize: 36.0,
                color: Colors.amber,
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(35.0),
              child: new RaisedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(16.0))),
                child: new Text(
                  "Sign Up",
                  style: new TextStyle(fontSize: 48.0, color: Colors.amber),
                ),
              ),
            ),
          ]),
        ));
  }
}
