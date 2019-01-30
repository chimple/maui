import 'dart:ui';

import 'package:flutter/material.dart';

class GameLevel extends StatefulWidget {
  String gameName;
  List<String> levelList;
  GameLevel({Key key, this.gameName, this.levelList}) : super(key: key);
  @override
  _GameLevelState createState() => new _GameLevelState();
}

class _GameLevelState extends State<GameLevel>
    with SingleTickerProviderStateMixin {
  List<String> _solvedLetters = [];
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() {
        setState(() {});
      });
    _controller.forward();

    _animation = Tween<double>(begin: -2.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.6,
          1.0,
          curve: Curves.bounceOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    print("hey this is cool");
    return new Stack(
      // alignment: Alignment.bottomCenter,
      children: <Widget>[
        new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: .0),
          child: new GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.grey[200].withOpacity(0.5),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          top: _animation.value * 400,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              // color: Colors.white,
              height: size.height > size.width
                  ? size.height * 0.45
                  : size.height * 0.70,
              width: size.width * 0.1,
              // alignment: Alignment(0.0, 0.0),
              child: Stack(children: <Widget>[
                Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(
                          Radius.circular(30.0),
                        )),
                    // color: Colors.white,
                    height: size.height,
                    width: size.width,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                        ),
                        Container(
                          height: media.size.height * 0.12,
                          width: media.size.width * 0.2,
                          decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: new BorderRadius.all(
                                Radius.circular(10.0),
                              )),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: new Text(
                            widget.gameName,
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),
                        Container(
                            height: media.size.height * 0.082,
                            width: media.size.width,
                            child: ListView(
                              //  reverse: true,
                              scrollDirection: Axis.horizontal,
                              // padding: EdgeInsets.all(20.0),
                              // itemExtent: .width,
                              children: widget.levelList
                                  .map((e) => Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Material(
                                          type: MaterialType.transparency,
                                          color: Colors.blueGrey,
                                          // borderRadius: BorderRadius.all(Radius.circular(100.0)),
                                          child: InkWell(
                                            highlightColor: Colors.green,
                                            onTap: (){
                                              Navigator.of(context).pop();
                                            },
                                            child: CircleAvatar(
                                              minRadius: 40.0,
                                              child: Center(
                                                child: Text(
                                                  "$e",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(growable: false),
                            )),
                      ],
                    ))
              ]),
            ),
          ),
        )
      ],
    );
  }
}
