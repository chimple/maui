import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/jamaica/widgets/stars.dart';
import 'package:nima/nima_actor.dart';

class GameScore extends StatefulWidget {
  final int scores;

  const GameScore({Key key, this.scores}) : super(key: key);

  @override
  _GameScoreState createState() => new _GameScoreState();
}

class _GameScoreState extends State<GameScore> with TickerProviderStateMixin {
  String _animationName = "waving";
  int _starcount = 1;
  AnimationController controller;
  Animation<double> animationDance;
  Duration duration;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("animation");
    print("scores ${widget.scores}");
    if (widget.scores != null && widget.scores <= 10) {
      setState(() {
        _animationName = "failure";
        _starcount = 3;
      });
    } else {
      setState(() {
        _animationName = "joy";
        _starcount = 5;
      });
    }
    controller = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);
    animationDance = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    controller.forward();
    // _myZoom();
    print("this is new ${controller.value}");
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print("this ispben");
    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    return Scaffold(
      backgroundColor: Colors.white24,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      // color: Colors.teal,
                      child: FlareActor("assets/character/chimp_ik.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          animation: _animationName),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: widget.scores == null
                              ? Text(
                                  "10",
                                  style: new TextStyle(
                                      fontSize: 60.0,
                                      color: Colors.orangeAccent),
                                )
                              : Text(
                                  "${widget.scores}",
                                  style: new TextStyle(
                                      fontSize: 60.0,
                                      color: Colors.orangeAccent),
                                ),
                        ),
                        Container(
                          width: media.size.width / 2,
                          child: ScaleTransition(
                            scale: animationDance,
                            child: Stars(
                              total: 5,
                              show: _starcount,
                            ),
                          ),
                        ),
                        RawMaterialButton(
                          padding: EdgeInsets.all(8.0),
                          shape: new CircleBorder(),
                          elevation: 2.0,
                          onPressed: () {},
                          fillColor: Colors.white,
                          child: Center(
                            child: new Icon(
                              Icons.redeem,
                              size: 70.0,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            "REWARD",
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.white),
                          ),
                        ),
                        Text(
                          "OPENED",
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              flex: 8,
            ),
            Expanded(
              child: Center(
                  child: Container(
                decoration: new BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(30.0),
                        right: Radius.circular(30.0))),
                child: OutlineButton(
                    highlightedBorderColor: Colors.red,
                    textColor: Colors.white,
                    borderSide: BorderSide(
                        color: Colors.white,
                        width: 5.0,
                        style: BorderStyle.solid),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(30.0),
                            right: Radius.circular(30.0))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Continue",
                      style: textStyle,
                    )),
              )),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
