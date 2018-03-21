
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
//import 'dart:ui' show window;



class Memory extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Memory({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new MemoryState();
}

class MemoryState extends State<Memory> with TickerProviderStateMixin {
  final List<String> _allLetters = [
    'A',
    'A',
    'B',
    'B',
    'C',
    'C',
    'D',
    'D',
    'E',
    'E',
    'F',
    'F',
    'G',
    'G',
    'H',
    'H'
  ];
  final int _size = 4;
  var _currentIndex = 0;
  var _pressedTile ;
  var _pressedTileIndex ;
  var cnt = 0;
  List<String> _shuffledLetters = [];
  List<String> _letters;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _allLetters.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _allLetters.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
    }
    print(_shuffledLetters);
    _letters = _shuffledLetters.sublist(0, _size * _size);
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key:new ValueKey<int>(index),
        text: text,
        onPress: () {
          cnt++;
          print("Pressed Index: ${index}");
          print("Pressed Text: ${text}");

          setState((){
            
             });

          if(_pressedTileIndex == index)
            return;

          if(cnt == 2)
          {
            if(_pressedTile == text)
            {
               setState((){
               _letters[_pressedTileIndex] = '';
               _letters[index] = '';
               });

               print("Matched");
            }
             
            else
            {
              print("Unmatched"); 
            }  

            _pressedTileIndex = -1;
            _pressedTile = null;
            cnt = 0;
            return;

          }    

          _pressedTileIndex = index;
          _pressedTile = text; 
            
        });
  }

  @override
  Widget build(BuildContext context) {
    print("MemoryState.build");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    List<TableRow> rows = new List<TableRow>();
    var j = 0;
    for (var i = 0; i < _size; ++i) {
      List<Widget> cells = _letters
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j++, e))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    return new Table(children: rows);
  }
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
    controller = new AnimationController(duration: new Duration(milliseconds: 1000), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (!widget.text.isEmpty) {
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
      
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new TableCell(
        child:new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new ScaleTransition(
                scale: animation,
                child:new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding:new  EdgeInsets.all(8.0),
                    color: Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius:new BorderRadius.all(new Radius.circular(8.0))),
                    child: new Text(_displayText,
                        style:
                           new TextStyle(color: Colors.white, fontSize: 24.0))))));;
  }
}

	
