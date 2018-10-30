import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class Animations extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Animation class was called!!!");
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.keyboard_arrow_left,
                  size: size.height * 0.1,
                  color: Colors.white,
                ),
                Container(
                  height: size.height * 0.6,
                  width: size.width * 0.4,
                  child: new Center(
                      child: new NimaActor("assets/quack",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: 'happy',
                          mixSeconds: 0.2,
                          completed: (String animationName) {})),
                ),
                new Icon(
                  Icons.keyboard_arrow_right,
                  size: size.height * 0.1,
                  color: Colors.white,
                ),
              ]),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                    height: size.height * 0.08,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(12.0),
                      color: Colors.amber,
                    ),
                    child: new FlatButton(
                        child: new Text(
                          'Draw',
                          style: new TextStyle(
                              fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold),
                        ))),
                new Container(
                    height: size.height * 0.08,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(12.0),
                      color: Colors.amber,
                    ),
                    child: new FlatButton(
                        child: new Text(
                      'Post',
                      style: new TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold),
                    )))
              ]),
        ]);
  }
}
