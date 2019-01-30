import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class MoveContainer extends StatefulWidget {
  final int coinCount;
  final int index;
  final AnimationController animationController;
  final double duration;

  MoveContainer(
      {Key key,
      this.coinCount,
      this.index,
      this.animationController,
      this.duration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MyMoveContainer();
  }
}

class _MyMoveContainer extends State<MoveContainer>
    with TickerProviderStateMixin {
  GlobalKey _globalKey = new GlobalKey();
  AnimationController _controller;
  Animation<Offset> _offset;
  Offset begin = Offset(0.0, 0.0);
  Offset end = Offset(750.0, 1800.0);
  Offset local;
  var countOpacity = 1.0;
  var extraSize = 0.0;
  double start;
  double ending;
  

  @override
  void initState() {
    super.initState();
    start = (widget.duration * widget.index)*3.toDouble();
    ending =( start + widget.duration)*1100;
    Offset endOffset = Offset(ending,0.0);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    print("start and end iss     $start     ,,,,, .... $ending");
    _offset = Tween<Offset>(begin: begin / 100, end: -(end+endOffset) / 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          start,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _offset.addListener(() {
      setState(() {
        // begin = Offset(1000.0+500, 1600);
        extraSize =
            extraSize < 30 ? extraSize : extraSize - _controller.value / 3;
        // countOpacity =
        //     countOpacity < 0.31 ? 0.0 : 1.0 - _controller.value * 0.7;
        // widget.coinCount =
        //     countOpacity < 0.32 ? widget.coinCount + 3 : widget.coinCount;
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // print('height and width is $extraSize');
    // print('opcityyyyyyyyyyyy is $countOpacity');
    // print('coinnnnnnnnnnnnnnnnnnn is ${widget.coinCount}');

    return SlideTransition(
      position: _offset,
      child: Opacity(
        opacity: countOpacity < 0.31 ? 0.0 : countOpacity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: height * .1 + extraSize,
              width: width * .1 + extraSize,
              child: FlareActor(
                "assets/coin.flr",
                animation: "coin",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
