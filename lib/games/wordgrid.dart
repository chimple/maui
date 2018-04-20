import 'dart:async';
import 'dart:math';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';

class Wordgrid extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Wordgrid(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new WordgridState();
}

class WordgridState extends State<Wordgrid> {
  int _size = 4;
  Tuple2<List<String>, List<String>> data;
  List<String> _others = [
    'q',
    'w',
    'j',
    'q',
    'w',
    'j',
    'q',
    'w',
    'j',
    'w',
    'j'
  ];
  var _currentIndex = 0;
  List<String> _shuffledLetters = [];
  List<String> _letters = ['A', 'P', 'P', 'L', 'E'];
  List<int> _indexarray = [];
  List<int> _flags = [];
  List<int> _colorflags = [];
  bool _isLoading = true;
  var rng = new Random();
  var j=0;
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    _currentIndex = 0;
    setState(() => _isLoading = true);
   data = await fetchWordData(widget.gameCategoryId,3,2);
    // for (int i = 0; i < _size * _size; i++) {
    //   _shuffledLetters[i]=null;
    // }
    print('daataa ${data.item1} ');
    print('daataa2  ${data.item2} ');

    print('arrr 777 $_shuffledLetters');
    _shuffledLetters.addAll(_letters);
    _shuffledLetters.addAll(_others);
    
 // Iterable _number4=_indexarray.reversed;
   //   print('hi 444 $_indexarray');
 //   _shuffledLetters.shuffle();
    _flags.length = 0;
    _colorflags.length=0;
    while (_flags.length <= _shuffledLetters.length) _flags.add(0);
    while (_colorflags.length <= _shuffledLetters.length) _colorflags.add(0);

    // print('flag array $_flags');
    setState(() => _isLoading = false);
  
  }
  // @override
  // void didUpdateWidget(Wordgrid oldWidget) {
  //   print(oldWidget.iteration);
  //   print(widget.iteration);
  //   if (widget.iteration != oldWidget.iteration) {
  //     _initBoard();
  //   }
  // }

  Widget _buildItem(int index, String text, int flag,int colorflag) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        flag: flag,
        colorflag:colorflag,
        onPress: () {
          if(colorflag==0){
          if (index == _currentIndex) {
            setState(() {
              _currentIndex++;
              _colorflags[index] = 1;
            });
            widget.onScore(1);
            widget.onProgress(_currentIndex / _letters.length);
            if (_currentIndex >= _letters.length) {
              new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd();
                widget.onEnd();
              });
            }
          } else {
            setState(() {
              _flags[index] = 1;
              _colorflags[index]=1;
            });
            new Future.delayed(const Duration(milliseconds: 550), () {
              setState(() {
                _flags[index] = 0;
                _colorflags[index]=0;

              });
            });
          }}
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    int j = 0;
    return new ResponsiveGridView(
      rows: _size,
      cols: _size,
      children: _shuffledLetters
          .map((e) => _buildItem(j, e, _flags[j],_colorflags[j++]))
          .toList(growable: false),
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress, this.flag,this.colorflag}) : super(key: key);

  final String text;
  final VoidCallback onPress;
  final int flag;
  final int colorflag;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
     controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
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
       animation1 = new Tween(begin: -5.0, end: 5.0).animate(controller1);
    _myAnim();
    controller.forward();
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
    return new ScaleTransition(
        scale: animation,
        child:new Shake(
          animation:widget.flag==1?animation1:animation,
          child:new ScaleTransition(
            scale:animation,
        child: new RaisedButton(
            onPressed: () => widget.onPress(),
            color: widget.colorflag == 1 ? Colors.red : Colors.blue,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(8.0))),
            child: new Text(_displayText,
                style: new TextStyle(color: Colors.white, fontSize: 24.0))))));
  }
}
