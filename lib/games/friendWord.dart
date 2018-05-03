//import 'dart:async';
//import 'package:flutter/material.dart';
//import 'package:maui/components/flash_card.dart';
//import 'package:maui/repos/game_data.dart';
//import 'package:maui/components/responsive_grid_view.dart';
//import 'dart:math';
//import 'package:maui/components/shaker.dart';
//
//class FriendWord extends StatefulWidget {
//  Function onScore;
//  Function onProgress;
//  Function onEnd;
//  int iteration;
//  int gameCategoryId;
//  bool isRotated;
//
//  FriendWord(
//      {key,
//        this.onScore,
//        this.onProgress,
//        this.onEnd,
//        this.iteration,
//        this.gameCategoryId,
//        this.isRotated = false})
//      : super(key: key);
//
//  @override
//  State<StatefulWidget> createState() => new FriendWordState();
//}
//
//class FriendWordState extends State<FriendWord> with SingleTickerProviderStateMixin {
//  int _size =4;
//  List<String> _letters = ['a','b','c','d','a','b','c','d','a','b','c','d','a','b','c','d'];
//  @override
//  Widget build(BuildContext context) {
//    return new LayoutBuilder(builder: (context, constraints) {
//      var j = 0;
//      return new Container(
//        child: new Column(
//          children: <Widget>[
//            new Container(
//                color: Colors.orange,
//                height: 100.0,
//                width: 100.0,
//                child: new Center(
//                    child: new Text("Text",
//                        key: new Key('question'),
//                        style: new TextStyle(
//                            color: Colors.black, fontSize: 30.0)))),
//            new Expanded(
//                child: new ResponsiveGridView(
//                  rows: _size,
//                  cols: _size,
//                  children: _letters
//                      .map((e) => _buildItem(
//                      j++, e))
//                      .toList(growable: false),
//                )),
//          ],
//        ),
//      );
//    });
//  }
//  Widget _buildItem(int index, String text) {
//    return new MyButton(
//        key: new ValueKey<int>(index) ,
//        text: text ,
//        onPress: () {}
//    );}
//
//}
//
//class MyButton extends StatefulWidget {
//  MyButton({Key key, this.text, this.onPress}) : super(key: key);
//
//  final String text;
//  final VoidCallback onPress;
//
//  @override
//  _MyButtonState createState() => new _MyButtonState();
//}
//
//class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
//  AnimationController controller;
//  Animation<double> animation;
//  String _displayText;
//
//  initState() {
//    super.initState();
//    print("_MyButtonState.initState: ${widget.text}");
//    _displayText = widget.text;
//    controller = new AnimationController(
//        duration: new Duration(milliseconds: 250), vsync: this);
//    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
//      ..addStatusListener((state) {
////        print("$state:${animation.value}");
//        if (state == AnimationStatus.dismissed) {
//          print('dismissed');
//          if (widget.text != null) {
//            setState(() => _displayText = widget.text);
//            controller.forward();
//          }
//        }
//      });
//    controller.forward();
//  }
//
//  @override
//  void didUpdateWidget(MyButton oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (oldWidget.text == null && widget.text != null) {
//      _displayText = widget.text;
//      controller.forward();
//    } else if (oldWidget.text != widget.text) {
//      controller.reverse();
//    }
//    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    print("_MyButtonState.build");
//    return new ScaleTransition(
//        scale: animation,
//        child: new GestureDetector(
//            onLongPress: () {
//              showDialog(
//                  context: context,
//                  child: new FractionallySizedBox(
//                      heightFactor: 0.5,
//                      widthFactor: 0.8,
//                      child: new FlashCard(text: widget.text)));
//            },
//            child: new RaisedButton(
//                onPressed: () => widget.onPress(),
//                shape: new RoundedRectangleBorder(
//                    borderRadius:
//                    const BorderRadius.all(const Radius.circular(8.0))),
//                child: new Text(_displayText,
//                    style:
//                    new TextStyle(color: Colors.white, fontSize: 24.0)))));
//  }
//}


import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';

class FriendWord extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;
  FriendWord(
      {key,
        this.onScore,
        this.onProgress,
        this.onEnd,
        this.iteration,
        this.isRotated = false,
        this.gameCategoryId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new FriendWordState();
}

class FriendWordState extends State<FriendWord> {
  var flag1 = 0;
  var correct = 0;
  var keys = 0;
  List<String> data = ['' , '' , '' , '' , '' , '' , '' , '' , ''];
  List<String> _rightwords = [];
  List<String> dragData = ['c' , 'a' , 't' , 'r'];
  List<String> _letters = new List();
  List<String> _data2 = new List();
  List<int> _data3 = new List();
  List<int> _flag = new List();
  List<String> _data1 = new List();
  List _sortletters = [];
  bool _isLoading = true;
  String img , dragdata;
  int _rows , _cols , code , dindex , dcode;
  int len , _rightlen , _rightcols;
  List<String> arr = new List<String>();
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
//    List<String> arr = new List<String>();
    for(var i=0;i<99;i++)
    {
      arr.add("a");
      print({"this is an array":arr});
    }
    _flag.length = data.length + dragData.length +1;
    for (var i = 0; i < _flag.length; i++) {
      _flag[i] = 0;
    }
    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index , String text) {
    return new MyButton(
        key: new ValueKey<int>(index) ,
        index: index ,
        text: text ,
        color1: 1 ,
        onAccepted: (dcindex) {
             print('dataa $dcindex');

        } ,
//        flag: flag ,
        code: code ,
        isRotated: widget.isRotated ,
        img: img ,
        keys: keys++);
  }


  @override
  Widget build(BuildContext context) {
  print("this is my array $arr");
    var j = 0, h = 0, k = 100;
    var rwidth,rheight;
      //  print(constraints.maxHeight);
      return new Container(
          color: Colors.purple[300],
          child: new Column(
            // portrait mode
            children: <Widget>[
              new Flexible(
                flex: 4,
                child: new ResponsiveGridView(
                  rows: 9,
                  cols: 9,
                  maxAspectRatio: 1.0,
                  children: arr
                      .map((e) => _buildItem(j++, e))
                      .toList(growable: false),
                ),
              ),
              new Flexible(
                flex: 4,
                child: new ResponsiveGridView(
                  rows: 2,
                  cols: 2,
                  maxAspectRatio:1.0,
                  children: dragData
                      .map((e) => _buildItem(k++, e))
                      .toList(growable: false),
                ),
              ),
            ],
          )
      );

    }
}
class MyButton extends StatefulWidget {
  MyButton(
      { Key key,
        this.index,
        this.text,
        this.color1,
        this.flag,
        this.onAccepted,
        this.code,
        this.isRotated,
        this.img,
        this.keys}): super(key: key);
  final index;
  final int color1;
  final int flag;
  final int code;
  final bool isRotated;
  final String text;
  final String img;
  final DragTargetAccept onAccepted;
  final keys;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String _displayText;
  String newtext='';
  var f = 0;
  var i = 0;
  initState() {
    super.initState();
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation =
    new CurvedAnimation(parent: controller, curve: Curves.decelerate)
      ..addStatusListener((state) {});
    controller.forward();
    animation1 = new Tween(begin: -5.0, end: 5.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }
  @override
  void dispose() {
    controller1.dispose();
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    if (widget.index < 100 && widget.color1 != 0) {
      return new ScaleTransition(
        scale: animation,
        child: new Shake(
            animation: widget.flag == 1 ? animation1 : animation,
            child: new ScaleTransition(
                scale: animation,
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.yellow[500],
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(8.0)),
                  ),
                  child: new DragTarget(
                    onAccept: (String data) => widget.onAccepted(data),
                    builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                        ) {
                      return new Container(
                        decoration: new BoxDecoration(
                          color: widget.flag == 1
                              ? Colors.redAccent
                              : Colors.yellow[500],
                          borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0)),
                          image:widget.img!=null
                              ? new DecorationImage(
                              image: new AssetImage(widget.img),
                              fit: BoxFit.contain)
                              : null,
                        ),
                        child: new Center(
                          child: new Text(widget.text,
                              key: new Key('A ${widget.keys}'),
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 24.0)),
                        ),
                      );
                    },
                  ),
                ))),
      );
    } else if (widget.index >= 100 && (widget.text==''|| widget.text.length==2)) {
      if(widget.text==''){newtext='';}
      else{newtext=widget.text[0];}
      return new ScaleTransition(
          scale: animation,
          child: new Container(
            decoration: new BoxDecoration(
              color: widget.text==''?Colors.purple[300]:Colors.grey[300],
              borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            ),
            child: new Center(
              child: new Text(newtext,
                  style: new TextStyle(color: Colors.black, fontSize: 24.0)),
            ),
          ));
    } else if (widget.index >= 100) {
      return new Draggable(
        data: '${widget.index}'+'_'+'${widget.code}',
        child: new ScaleTransition(
            scale: animation,
            child: new Container(
              decoration: new BoxDecoration(
                color: widget.color1 == 1
                    ? Colors.yellow[500]
                    : Colors.purple[300],
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              ),
              child: new Center(
                child: new Text(_displayText,
                    key: new Key('B${widget.keys}'),
                    style: new TextStyle(color: Colors.black, fontSize: 24.0)),
              ),
            )),
        //  childWhenDragging: new Container(),
        feedback:new Container(
          height: media.orientation==Orientation.portrait?media.size.height*.05:media.size.height*.1,
          width: media.orientation==Orientation.portrait?media.size.width*.14:media.size.width*.08,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              color: Colors.yellow[400]),
          child: new Center(
            child: new Transform.rotate(
              angle: widget.isRotated==true?
              media.orientation==Orientation.portrait?3.14:0.0:0.0,
              alignment: Alignment.center,
              child: new Text(
                widget.text,
                style: new TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 26.0,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return new ScaleTransition(
          scale: animation,
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.purple[500],
              borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            ),
            child: new Center(
              child: new Text(_displayText,
                  style: new TextStyle(color: Colors.black, fontSize: 24.0)),
            ),
          ));
    }
  }
}
