import 'dart:math';
import 'dart:async';
import 'package:maui/components/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/Shaker.dart';
import 'package:flutter/rendering.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/gameaudio.dart';
import '../components/responsive_grid_view.dart';

class Circleword extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Circleword(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => new CirclewordState();
}

enum Status { Active, Visible, Disappear }
enum ShakeCell { Right, InActive, Dance, CurveRow }
enum Status1 { Active, Visible, Disappear }
enum ShakeCell1 { Right, InActive, Dance, CurveRow }

class CirclewordState extends State<Circleword> {
  var score = 0;

  String word = '';
  var flag = 0;
  String words = '';
  List<ShakeCell> _shakecell;
  List<ShakeCell1> _shakecell1;
  List<Status> _statuses;
  List<Status1> _statuses1;
  List<String> _solvedLetters = [];
  List<String> _letters1;
  bool _isLoading = true;
  List<String> wordata;
  List<int> indexstore = [];

  List<Widget> widgets1 = new List();
  List<String> _letters;

  Tuple2<List<String>, String> data;

  @override
  void initState() {
    super.initState();

    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    data = await fetchCirclewrdData(widget.gameCategoryId);

    print("the data is coming for cricleword ${data}");

    wordata = data.item1;

    _letters = data.item2.split('');

    print("hwllo this is data is ....$_letters");
    _statuses = _letters.map((a) => Status.Active).toList(growable: false);
    _shakecell =
        _letters.map((e) => ShakeCell.InActive).toList(growable: false);
    setState(() => _isLoading = false);
    _shakecell1 =
        _letters.map((e) => ShakeCell1.InActive).toList(growable: false);
    setState(() => _isLoading = false);
    _statuses1 = _letters.map((a) => Status1.Active).toList(growable: false);
  }

  @override
  void didUpdateWidget(Circleword oldWidget) {
    print("object...iterartion in connect dots");
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  @override
  Widget build(BuildContext context) {
    var rand = new Random();
    var startNum = rand.nextInt(max(1, 10));

    print("random number generated in dart.... upto 10...::$startNum");
    MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    var j = 0;
    var k = 0;

    return new LayoutBuilder(builder: (context, constraints) {
      double circleSize = constraints.maxHeight / 2;
      double dradius;
      print(
          "in layout builde hieght would be ...::..${constraints.maxHeight}..........$circleSize");
      print("width of layout builder is...........${constraints.maxWidth}");

      List<Widget> widgets = new List();
      double hi = constraints.maxHeight / 4;
      Offset circleCenter = new Offset(hi, hi);
      double csize = circleSize / 3;
      print("all data sent to the method is $csize........$circleCenter");

      List<Offset> offsets1 =
          calculateOffsets(csize, circleCenter, _letters.length - 1);
      print("object width is..... ${circleSize}");

      if (_letters.length >= 9) {
        dradius = _letters.length - 1.0 + 0.5;
      } else if (_letters.length >= 5) {
        dradius = _letters.length + 1.0 + 0.5;
      }
      var textsizeis = (circleSize / dradius) / 3;
      List<Offset> offsets2 = calculateOffsets(0.0, circleCenter, 1);

      print(" ......offstes is.... $offsets2");
      List<Offset> offsets = offsets1 + offsets2;
      print("this is  data");
      print(constraints.maxHeight);
      print(constraints.maxWidth);
      double _height, _width;
      _height = constraints.maxHeight;
      _width = constraints.maxWidth;

      print("widgets length is.....:....:${widgets.length}");

      _letters.forEach((e) => widgets.add(_buildItem(offsets[j], j, e,
          Colors.teal, circleSize / dradius, _statuses[j], _shakecell[j++])));
      double potl = 180.0;
      double landl = 140.0;
      double subwidthp = (media.size.width / 2) * .4;
      double subwidthl = (media.size.width / 2) * .25;

      double lposition = _height > _width ? potl : landl;
      double sizeofsub = _height > _width ? subwidthp : subwidthl;

      //  final hPadding = pow(constraints.maxWidth / 150.0, 2);
      //   final vPadding = pow(constraints.maxHeight / 150.0, 2);

      //   double maxWidth = (constraints.maxWidth - hPadding * 2) ;
      //   double maxHeight = (constraints.maxHeight - vPadding * 2) ;

      //   final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      //   maxWidth -= buttonPadding * 2;
      //   maxHeight -= buttonPadding * 2;
      //   UnitButton.saveButtonSize(context, 10, maxWidth, maxHeight);
      //   AppState state = AppStateContainer.of(context).state;

      print(".........solved letters is....$_solvedLetters");
      return new Container(
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              new Center(
                child: new Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: new BoxDecoration(
                        color: Color(0xFF7592BC), shape: BoxShape.circle),
                    child: new Stack(children: widgets)),
              ),
              new Center(
                child: new Container(
                  width: sizeofsub,
                  height: (media.size.height / 2) * .1,
                  margin: new EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: new RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(8.0))),
                    onPressed: () => method(),
                    child: new Text("submit"),
                  ),
                ),
              ),
              // new Container(
              //     margin: new EdgeInsets.only(bottom: 20.0),
              //     height: 40.0,
              //     color: Colors.white,
              //     child: new Text("$words",
              //         style:
              //             new TextStyle(color: Colors.black, fontSize: 25.0))),

              new ResponsiveGridView(
                rows: 3,
                cols: 3,
                maxAspectRatio: 1.0,
                children: _solvedLetters
                    .map((e) => new Padding(
                        padding: EdgeInsets.all(6.0),
                        child:
                            _buildItem1(k, e, _shakecell1[k], _statuses1[k++])))
                    .toList(growable: false),
              )
            ]),
      );
    });
  }

  //it calculates points on circle
  //these points are centers for small circles
  List<Offset> calculateOffsets(
      double circleRadii, Offset circleCenter, int amount) {
    print(
        "value of all sent to here is in method is.......$circleRadii........$circleCenter");
    double angle = 2 * pi / amount;
    double alpha = 0.0;
    double x0 = circleCenter.dx;
    double y0 = circleCenter.dy;
    List<Offset> offsets = new List(amount);
    for (int i = 0; i < amount; i++) {
      double x = x0 + circleRadii * cos(alpha);
      double y = y0 + circleRadii * sin(alpha);
      offsets[i] = new Offset(x, y);
      print("object ..x..$x .....y...$y");
      // print("i:$i  alpha=${(alpha*180/pi).toStringAsFixed(1)}° ${offsets[i]}");
      alpha += angle;
    }
    return offsets;
  }

  method() {
    var mflag = 0;
    print("hello ");
    score = word.length;
    print(" all indexs value is $indexstore");
    wordata.forEach((e) {
      if (e.compareTo('$word') == 0) {
        mflag = 1;
        setState(() {
          wordata.remove(e);
          _solvedLetters.add(word);
          print("object.........solved letters are..::$_solvedLetters");
          word = '';
          // words = "$words" + "$word" + " , ";

          indexstore = [];
          widget.onScore(score);
          if (_solvedLetters.length == _letters.length) {
            setState(() {
              new Future.delayed(const Duration(milliseconds: 250), () {
                // indexstore =[];

                _solvedLetters.removeRange(0, _solvedLetters.length);
                widget.onEnd();
              });
            });
          }
          _statuses =
              _letters.map((a) => Status.Active).toList(growable: false);
          _shakecell =
              _letters.map((a) => ShakeCell.InActive).toList(growable: false);
        });
      }
    });
    if (mflag == 0) {
      indexstore.forEach((e) {
        setState(() {
          _shakecell[e] = ShakeCell.Right;
        });
      });
      _solvedLetters.forEach((e) {
        if (e.compareTo('$word') == 0) {
          setState(() {
            var i = _solvedLetters.indexOf(word);
            _shakecell1[i] = ShakeCell1.Right;

            _statuses1[i] = Status1.Visible;
          });
        }
      });

      print("shanlke cells of tile is $_shakecell");
      new Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          indexstore = [];
          _shakecell =
              _letters.map((a) => ShakeCell.InActive).toList(growable: false);
          _statuses =
              _letters.map((a) => Status.Active).toList(growable: false);
          _shakecell1 =
              _letters.map((a) => ShakeCell1.InActive).toList(growable: false);
          _statuses1 =
              _letters.map((a) => Status1.Active).toList(growable: false);
        });
      });

      word = '';
    }
  }

  Widget _buildItem(Offset offset, int i, String text, MaterialColor teal,
      double d, Status status, ShakeCell tile) {
    return new PositionCircle(
        key: new ValueKey<int>(i),
        offset: offset,
        text: text,
        teal: teal,
        d: d,
        status: status,
        tile: tile,
        onPress: () {
          print("object..offsets is...:$offset");

          if (status == Status.Active) {
            if (flag == 0) {
              setState(() {
                indexstore.add(i);
                _statuses[i] = Status.Visible;
                //  _shakecell[i]=ShakeCell.Right;
              });
              word = text;
              flag = 1;
            } else {
              setState(() {
                indexstore.add(i);
                _statuses[i] = Status.Visible;
                // _shakecell[i]=ShakeCell.Right;
              });
              print("text inside opress is..... $text");
              print(" index....... $i");

              word = "$word" + "$text";
              print("object... word is... $word");
            }
          } else if (indexstore.last == i) {
            setState(() {
              _statuses[i] = Status.Active;

              word = word.replaceRange(word.length - 1, word.length, '');
              indexstore.removeLast();
            });
          }
        });
  }

  _buildItem1(int index, String text, ShakeCell1 tile, Status1 status) {
    print("the text off the solvedltters is....$text");
    return new MyButton(
      key: new ValueKey<int>(index),
      index: index,
      text: text,
      tile: tile,
      status: status,
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton({
    Key key,
    this.text,
    this.index,
    this.tile,
    this.status,
  }) : super(key: key);

  final String text;
  int index;
  Status1 status;
  ShakeCell1 tile;
//     final Offset offset;
//  final DraggableCanceledCallback onCancel;
//   final DragTargetWillAccept onwill;
//   final VoidCallback onStart;
//   final int code;
//   final bool vflag;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  // AnimationController controller, controller1;
  // Animation<double> animation, animation1;
  String _displayText;
  String newtext = '';
  var f = 0;
  var i = 0;
  AnimationController controller, controller1;
  Animation<double> animationRight, animation, animationWrong, animationDance;
  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    // position = widget.offset;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 20), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (!widget.text.isEmpty) {
            controller.forward();
          }
        }
      });
    controller.forward();
    animationWrong = new Tween(begin: -1.0, end: 1.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animationWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    MediaQueryData media = MediaQuery.of(context);
    int _color = 0xFF5F9EA0;

    //  if (widget.tile==ShakeCell.Right) {
    //   _color = 0xFFff0000; // red
    // }

    return new ScaleTransition(
        scale: animation,
        child: new Shake(
          animation:
              widget.tile == ShakeCell1.Right ? animationWrong : animationRight,
          child: new Container(
            margin: EdgeInsets.only(top: 5.0),
            height: (media.size.height / 2) * .15,
            width: (media.size.width / 2) * .4,
            child: new RaisedButton(
                onPressed: () => {},
                color: widget.status == Status1.Visible
                    ? new Color(0xFFffffff)
                    : Theme.of(context).primaryColor,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0))),
                child: new Text("${widget.text}",
                    key: new Key(widget.index.toString() + "but"),
                    style: new TextStyle(color: Colors.black, fontSize: 14.0))),
          ),
        ));
  }
}

class PositionCircle extends StatefulWidget {
  final Offset offset;
  final String text;
  final Color teal;
  final double d;
  Status status;
  ShakeCell tile;
  final VoidCallback onPress;
// final String word;
  PositionCircle(
      {Key key,
      this.offset,
      this.text,
      this.teal,
      this.d,
      this.status,
      this.tile,
      this.onPress})
      : super(key: key);
  @override
  _PositionCircleState createState() => new _PositionCircleState();
}

class _PositionCircleState extends State<PositionCircle>
    with TickerProviderStateMixin {
  Offset position = Offset(0.0, 0.0);
  AnimationController controller, controller1;
  Animation<double> animationRight, animation, animationWrong, animationDance;
  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    position = widget.offset;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 20), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (!widget.text.isEmpty) {
            controller.forward();
          }
        }
      });
    controller.forward();
    animationWrong = new Tween(begin: -1.0, end: 1.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animationWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void didUpdateWidget(PositionCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    position = widget.offset;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx - widget.d,
      top: position.dy - widget.d,
      width: widget.d * 2,
      height: widget.d * 2,
      child: new Shake(
        animation:
            widget.tile == ShakeCell.Right ? animationWrong : animationRight,
        child: new RawMaterialButton(
          shape: const CircleBorder(side: BorderSide.none),
          elevation: widget.status == Status.Visible ? 10.0 : 0.0,
          onPressed: () => widget.onPress(),
          fillColor: widget.status == Status.Visible
              ? Colors.white
              : Theme.of(context).primaryColor,
          splashColor: Colors.yellow,
          child: new Text(widget.text,
              style: new TextStyle(color: Colors.black, fontSize: 24.0)),
        ),
      ),
    );
  }
}
