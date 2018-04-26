

import 'dart:async';
import 'dart:math';
import 'package:maui/components/flash_card.dart';
import 'package:flutter/material.dart';

import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/Shaker.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);
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
enum Status {Active, Visible, Disappear}
enum ShakeCell { Right, InActive, Dance, CurveRow }

class  CirclewordState extends State<Circleword> {
  int _size =3;
  List<String> _letters = ['c','t','a','s','e','i','n','g','s'];
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      double _height, _width;
    _height = constraints.maxHeight;
      _width = constraints.maxWidth;
       List<TableRow> rows = new List<TableRow>();
      var j = 0;
      for (var i = 0; i < _size; ++i) {
        List<Widget> cells = _letters
            .skip(i * _size)
            .take(_size)
            .map((e) => _buildItem(j++, e,))
            .toList();
        rows.add(new TableRow( 
          children: cells));
      }
      return new Container(
        child: new Column(

          children: <Widget>[
           new Container(
               decoration: new BoxDecoration(
                 shape: BoxShape.circle,
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
            ),
            boxShadow: [
              new BoxShadow(
                color: Colors.red,
                blurRadius: 2.0,
                spreadRadius: 1.0,
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: new Container(),
                  ),

              
               
          ],
        ),
      );
    });
  }
  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index) ,
        text: text ,
        onPress: () {}
    );}

}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress}) : super(key: key);

  final String text;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
//        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == null && widget.text != null) {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new TableCell(
        child: new Padding(
            padding: new EdgeInsets.all(3.0),


     child:new ScaleTransition(
        scale: animation,
        child: new GestureDetector(
            onLongPress: () {
              showDialog(
                  context: context,
                  child: new FractionallySizedBox(
                      heightFactor: 0.5,
                      widthFactor: 0.8,
                      child: new FlashCard(text: widget.text)));
            },
            child: new RaisedButton(
              padding: new  EdgeInsets.all(10.0),
                onPressed: () => widget.onPress(),
                shape: new RoundedRectangleBorder(
                    borderRadius:
                    const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text(_displayText,
                    style:
                    new TextStyle(color: Colors.white, fontSize: 24.0))))) )) ;
  }
}