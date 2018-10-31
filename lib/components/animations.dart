import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class Animations extends StatefulWidget {
  @override
  AnimationsState createState() {
    return new AnimationsState();
  }
}

class AnimationsState extends State<Animations> {
  List<String> emotions = ["happy", "joy", "hello", "sad", "bored"];
  int count = 0;
  String emotion;

  @override
  void initState() {
    emotion = emotions[count];
  }

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      if (count > 0) {
                        setState(() {
                          count = count - 1;
                          emotion = emotions[count];
                        });
                      } else if (count <= 0) {
                        setState(() {
                          count = 0;
                          emotion = emotions[count];
                        });
                      }
                    },
                    child: new Icon(
                      Icons.keyboard_arrow_left,
                      size: size.height * 0.08,
                      color: count == 0 ? Colors.grey : Colors.white,
                    )),
                Flexible(
                  child: Container(
                      // height: double.maxFinite,
                      // width: double.maxFinite,
                      height: size.height > size.width
                          ? size.height * 0.8
                          : size.height * 0.85,
                      width: size.height > size.width
                          ? size.width * 0.8
                          : size.width * 0.5,
                      child: new NimaActor(
                        "assets/quack",
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        animation: '$emotion',
                        mixSeconds: 0.2,
                      )),
                ),
                FlatButton(
                    onPressed: () {
                      if (count < emotions.length) {
                        setState(() {
                          count = count + 1;
                          emotion = emotions[count];
                        });
                      } else if (count >= emotions.length) {
                        setState(() {
                          count = emotions.length - 1;
                          emotion = emotions[count];
                        });
                      }
                    },
                    child: new Icon(
                      Icons.keyboard_arrow_right,
                      size: size.height * 0.08,
                      color: count == emotions.length - 1
                          ? Colors.grey
                          : Colors.white,
                    )),
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
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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
                      style: new TextStyle(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )))
              ]),
        ]);
  }
}
