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
  String _animationName = "signup";
  AnimationController controller;
  Animation<double> animationDance;
  Duration duration;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("animation");
    controller = new AnimationController(
        duration: new Duration(seconds: 3), vsync: this);
    animationDance = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
     
      
    );
     controller.forward();
    // _myZoom();
    print("this is new ${controller.value}");
  }

  // void _myZoom() {
  //   animationDance.addStatusListener((status) {
  //     setState(() {});
  //   });
  //   controller.forward();
  // }

  @override
  void dispose() {
    // controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print("this ispben");
    final TextStyle textStyle = Theme.of(context).textTheme.display2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    // width: media.size.width,
                    decoration: BoxDecoration(
                        // color: Colors.green,
                        // borderRadius: BorderRadius.all(Radius.circular(45)
                        // )
                        ),
                    child: SvgPicture.asset(
                      "assets/category/pen.svg",
                      fit: BoxFit.contain,
                      width: media.size.width,
                      height: media.size.height,
                    ),
                  ),
                  Container(
                    width: media.size.width,
                    // decoration: BoxDecoration(
                    //     // color: Colors.green,
                    //     borderRadius: BorderRadius.all(Radius.circular(45))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: new NimaActor(
                            "assets/quack.nima",
                            fit: BoxFit.contain,
                            animation: _animationName,
                            mixSeconds: 0.1,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  // color: Colors.green,

                                  child: widget.scores == null
                                      ? Text(
                                          "15",
                                          style: new TextStyle(fontSize: 60.0),
                                        )
                                      : Text(
                                          "${widget.scores}",
                                          style: new TextStyle(fontSize: 60.0),
                                        ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: ScaleTransition(
                                  scale: animationDance,
                                  child: Stars(
                                    total: 5,
                                    show: 3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(8),

                            // color: Colors.yellow,

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                RawMaterialButton(
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  onPressed: () {},
                                  fillColor: Colors.redAccent,
                                  child: Center(
                                    child: new Icon(
                                      Icons.redeem,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                        color: Colors.redAccent,
                        width: 5.0,
                        style: BorderStyle.solid),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(30.0),
                            right: Radius.circular(30.0))),
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.dispose();
                      deactivate();
                    },
                    child: Text(
                      "Continue",
                      style: textStyle,
                    )),
              )),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
