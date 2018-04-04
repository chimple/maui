import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/flip_animator.dart';

class Memory extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;

  Memory({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.gameCategoryId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new MemoryState();
}

enum Status {Hidden, Visible}

class MemoryState extends State<Memory> {
  int _size = 4;
  List<String> _allLetters = [];
  List<String> _shuffledLetters = [];
  List<String> _letters;
  List<Status> _statuses;
  Map<String,String> _data;
  bool _isLoading = true;
  var _matched = 0;
  var _progressCnt = 1;
  var _pressedTile ;
  var _pressedTileIndex ;
  var cnt = 0;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(()=>_isLoading=true);
    _data = await fetchPairData(widget.gameCategoryId , 8);
    print("Rajesh-Data-initBoardCall: ${_data}");

    _allLetters = [];
    _data.forEach((k,v){
      _allLetters.add(k);
      _allLetters.add(v);
    });
    print("Rajesh-Data-after-Mapping: ${_allLetters}");

    _size = min(4, sqrt(_allLetters.length).floor());
    _shuffledLetters = [];
    for (var i = 0; i < _allLetters.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _allLetters.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
    }
    print("Rajesh-Data-after-Shuffling: ${_shuffledLetters}");
    _letters = _shuffledLetters.sublist(0, _size * _size);
    _statuses = _letters.map((a)=>Status.Hidden).toList(growable: false);
    setState(()=>_isLoading=false);
  }

  @override
  void didUpdateWidget(Memory oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      print("Rajesh-Data-didUpdateWidget${_allLetters}");
    }
  }

  Widget _buildItem(int index, String text , Status status) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
       onPress: () {       
          print("Pressed Index: ${index}");
          print("Pressed Text: ${text}");
           
          if(_pressedTileIndex == index || cnt>2)   
           return;
             
          cnt++;
       
          setState((){
            _statuses[index] = Status.Visible;
          }); 

        print("Pressed Statuses1: ${_statuses}");
           
          if(cnt == 2)
          {
            if(_pressedTile == text)
            {
               new Future.delayed(const Duration(milliseconds: 250), () {
                setState((){
                _letters[_pressedTileIndex] = '';
                _letters[index] = '';
                _pressedTileIndex = -1;
                _pressedTile = null;
                cnt = 0;
                });
             });   

                _matched++;
               widget.onScore(2);
               widget.onProgress((_progressCnt) / (_allLetters.length/2));
               _progressCnt++;

               print("Rajesh-Matched${_matched}");
               if(_matched == 8) {
                 _matched = 0;
                  new Future.delayed(const Duration(milliseconds: 250), () {
                    print("Rajesh Game-End");
                    widget.onEnd();
                });
               }
               print("Pressed Statuses2: ${_statuses}"); 
               print("Matched");
            }
            else
            {
              new Future.delayed(const Duration(milliseconds: 250), () {
                setState((){   
                _statuses[_pressedTileIndex] = Status.Hidden;
                _statuses[index] = Status.Hidden;
                 _pressedTileIndex = -1;
                _pressedTile = null;
                 cnt = 0;
                });
              });
                
              print("Pressed Statuses3: ${_statuses}"); 
              print("Unmatched"); 
            }  
            print("Pressed Statuses4: ${_statuses}");
            return;
          }    
           _pressedTileIndex = index;
          _pressedTile = text; 
         
        });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    if(_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    List<TableRow> rows = new List<TableRow>();
    var j = 0;
    for (var i = 0; i < _size; ++i) {
      List<Widget> cells = _letters
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j, e, _statuses[j++]))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    return new Table(children: rows);
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.status, this.onPress}) : super(key: key);

  final String text;
  Status status;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  AnimationController flipController;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    flipController = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (widget.text == null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          } 
        }
      });
    controller.forward().then((f){flipController.reverse();});
    
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == '' && widget.text != '') {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    if(oldWidget.status != widget.status) {
      if(widget.status == Status.Visible) {
        flipController.forward();
      } else {
        flipController.reverse();
      }
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new TableCell(
        child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new FlipAnimator(controller: flipController, front: new ScaleTransition(
                scale: animation,
                child: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8.0))),
                    child: new Text(_displayText,
                        style: new TextStyle(color: Colors.white, fontSize: 24.0)))),
                back: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8.0))),
                    child: new Text(_displayText, style: new TextStyle(color: Colors.teal, fontSize: 24.0) )))));

  }
}
