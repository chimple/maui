import 'dart:ui';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameLevel extends StatefulWidget {
  final String gameName;
  final List levelList;
  final String gameImage;
  GameLevel({Key key, this.gameName, this.levelList, this.gameImage})
      : super(key: key);
  @override
  _GameLevelState createState() => new _GameLevelState();
}

class _GameLevelState extends State<GameLevel>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {});
      });
    _controller.forward();

    _animation = Tween<double>(begin: -8.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.4,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    print("this is my animation vslur ${_animation.value}");
    return new Stack(
      children: <Widget>[
        new BackdropFilter(
          filter: new ImageFilter.blur(
              sigmaX: _animation.value, sigmaY: _animation.value),
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
        orientation == Orientation.portrait
            ? Positioned(
                left: 0.0,
                right: 0.0,
                top: orientation == Orientation.portrait
                    ? _animation.value * 300
                    : _animation.value,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    height: media.size.height * 0.40,
                    width: media.size.width * 0.1,
                    child: Stack(children: <Widget>[
                      Container(
                        child: SvgPicture.asset(
                          "assets/game/background_popup.svg",
                          fit: BoxFit.fill,
                        ),
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.all(
                              Radius.circular(30.0),
                            )),
                      ),
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/game/${widget.gameImage}",
                            fit: BoxFit.fill,
                            height: media.size.height * 0.15,
                            width: media.size.width * 0.23,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                type: MaterialType.transparency,
                                child: new Text(
                                  widget.gameName,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              height: media.size.height * 0.085,
                              width: media.size.width,
                              child: ListView(
                                padding:
                                    EdgeInsets.all(media.size.height * 0.01),
                                scrollDirection: Axis.horizontal,
                                children: widget.levelList.map((e) =>
                                      RawMaterialButton(
                                          key: ValueKey("$e"),
                                          shape: new CircleBorder(),
                                          elevation: 2.0,
                                          fillColor: widget.levelList.first == e
                                              ? Color(0XFF2a2538)
                                              : Color(0XFFe8e6e4),
                                          onPressed: () {},
                                          child: Text(
                                            "$e",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    media.size.width * 0.05,
                                                color: Colors.white),
                                          ),
                                        )
                                ).toList(growable: false),
                              )),
                        ],
                      )
                    ]),
                  ),
                ),
              )
            :

//This for landscape as there is problem in position widget

            Positioned(
                // left: media.size.width,
                right: media.size.height / 2.3,
                height: media.size.height * 0.72,
                width: media.size.width / 1.8,
                top: _animation.value * 40,
                child: Stack(children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(
                          Radius.circular(30.0),
                        )),
                    child: SvgPicture.asset(
                      "assets/game/background_popup.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/game/${widget.gameImage}",
                        fit: BoxFit.fill,
                        height: media.size.height * 0.30,
                        width: media.size.width * 0.23,
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: new Text(
                          widget.gameName,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                          height: media.size.height * 0.15,
                          width: media.size.width / 1.8,
                          child: ListView(
                            padding: EdgeInsets.all(media.size.height * 0.01),
                            scrollDirection: Axis.horizontal,
                            children: widget.levelList
                                .map((e) => RawMaterialButton(
                                      // padding: EdgeInsets.all(10.0),
                                      key: ValueKey("$e"),
                                      shape: new CircleBorder(),
                                      elevation: 2.0,
                                      fillColor: widget.levelList.first == e
                                          ? Color(0XFF2a2538)
                                          : Color(0XFFe8e6e4),
                                      onPressed: () {},
                                      child: Center(
                                        child: Text(
                                          "$e",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: media.size.width * 0.03,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                                .toList(growable: false),
                          )),
                    ],
                  )
                ]),
              )
      ],
    );
  }
}
