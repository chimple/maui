import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';

class Fillnumber extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Fillnumber(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new MyFillnumberState();
}

enum Status { Active, Visible, Disappear }
enum Bgstatus { BgActive, BgVisible }

class MyFillnumberState extends State<Fillnumber> {
  List<Offset> _points = [];
  var sum = 0,
      Ansum = 0,
      ia = 0,
      center = 0,
      center2 = 0,
      R = 1,
      L = 1,
      val = 0,
      i = 0,
      k = 0,
      ans = 0,
      num1 = 0,
      count = 0,
      Ansr = 0,
      x = 0,
      z=3,
      count1 = 0;

  List<String> num3 = [];
  final int _size = 4;
  static int size = 4;
  var T = size;
  var B = size;
  List<List<int>> _allLetters;
  List<int> _shuffledLetters = [];
  List<int> _copyVal = [];

  List _Index = [];
  List _num2 = [];
  List _center = [];
  List<int> _letters;
  String ssum = '';
  List<Status> _statuses;
  List<Bgstatus> _Bgstatus;

  bool _isLoading = true;

  List _val2 = [];
  var c = 0;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _allLetters = await fetchFillNumberData(widget.gameCategoryId, _size);

    print("shanthus data is $_allLetters");

    _allLetters.forEach((e) {
      e.forEach((v) {
        _copyVal.add(v);
      });
    });

    for (var i = 0; i < _copyVal.length; i += _size * _size) {
      _shuffledLetters
          .addAll(_copyVal.skip(i).take(_size * _size).toList(growable: true));
    }
    _Bgstatus = _copyVal.map((a) => Bgstatus.BgActive).toList(growable: false);
    _statuses = _copyVal.map((a) => Status.Active).toList(growable: false);

    print("data in _shuffledLetters of shanthu $_shuffledLetters");
    _letters = _shuffledLetters.sublist(0, _size * _size);

    setState(() => _isLoading = false);
    _val2 = _shuffledLetters.sublist(0, 4);
    for (num e in _val2) {
      Ansum += e;
    }
    Ansr = Ansum;
    _val2.removeRange(0, _val2.length);
  }

  @override
  void didUpdateWidget(Fillnumber oldWidget) {
    print(" some dada is not able to get it $oldWidget.iteration");
    print("some of old widget is $widget.iteration");
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      print("Rajesh-Data-didUpdateWidget${_allLetters}");
    }
  }

  Widget _buildItem(int index, int text, Status status, Bgstatus bgstatus) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        bgstatus: bgstatus,
        onPress: () {
          num1 = text;
          if (status == Status.Active) {
            if (sum == 0) {
              setState(() {
                ssum = '$text';
                print('qwer $ssum');
              });

              val = index;
              setState(() {
                _statuses[index] = Status.Visible;
                _Bgstatus[index] = Bgstatus.BgVisible;
              });
              print('helo this is in status os the values stored n $_statuses');


              print("hello this repeating one value once level is completed $ssum");

              _center.add(index);
              _Index.add(index);
              sum = sum + text;
              if (sum == Ansr) {
                ssum = '$ssum' + '=$sum';
                new Future.delayed(const Duration(milliseconds: 250), () {
                  widget.onScore(1);
                  widget.onProgress((count1 + 2) / 6.5);
                  count1++;
                  for (var i = 0; i < _Index.length; i++) {
                    _letters[_Index[i]] = null;
                  }

                  sum = 0;
                  center = 0;
                  _center.removeRange(0, _center.length);
                  print('helo this is sum when resetting in it value $sum');
                  print(
                      'helo this is sum when resetting in it value $_letters');
                  _letters.forEach((e) {
                    if (e == null) {
                      count = count + 1;
                    }
                  });
                  ssum = '';
                  _letters.removeWhere((value) => value == null);
                  for (var i = 0; i < count; i++) {
                    _letters.add(null);
                  }
                  print("thhhiiiiiiisssss isss shanthuuuu$_val2");

                  _val2.removeRange(0, _val2.length);

                  Ansum = 0;
                  _val2 = _letters.sublist(0, z);
                  z++;
                  print("thhhiiiiiiisssss isss shanthuuuuiiiiiiii$_val2");
                  _val2.forEach((e) {
                    if (e == null) {}
                  });
                  print("my calling onennd value is $k");
                  _val2.removeWhere((value) => value == null);
                  k = _val2.length;

                  print("thid is the vlaue of length is valu$k");
                  for (num e in _val2) {
                    Ansum += e;
                  }
                  print("thhhiiiiiiisssss isss shanthuuuu$_val2");
                  Ansr = Ansum;

                  count = 0;
                  _statuses = _copyVal
                      .map((a) => Status.Active)
                      .toList(growable: false);
                  _Bgstatus = _copyVal
                      .map((a) => Bgstatus.BgActive)
                      .toList(growable: false);
                  _Index.removeRange(0, _Index.length);
                  _num2.removeRange(0, _num2.length);
                });
                k = _letters[4];
                print("helllo this letters$k");
                if (_letters[4] == null) {
                  setState(() {
                    k = 0;
                    Ansr = 0;
                    ssum = '';
                    _letters.removeRange(0, _letters.length);
                  });
                  new Future.delayed(const Duration(milliseconds: 250), () {
                    print("Rajesh Game-End");
                    widget.onEnd();
                  });
                }

                _val2.removeRange(0, _val2.length);
              }
              print('helo this is num on clicked value of sum $sum');
              print('helo this is num on clicked index value $index');
            }
            _center.forEach((e) {
              center = e;
              if (center == _size ||
                  center == _size + _size ||
                  center == _size + _size + _size) {
                x = center;
              }
              if ((index == center + R ||
                  index == center + B ||
                  (index == center - L && x != center) ||
                  index == center - T)) {
                setState(() {
                  ssum = '$ssum' + '+' + '$text';
                  _statuses[index] = Status.Visible;
                  _Bgstatus[index] = Bgstatus.BgVisible;
                });

                print('qwer nniiikkkiilll $ssum');
                print(
                    'helo this is in status os the values stored n $_statuses');
                print(
                    'helo this is num on clicked value of sum in if condiyion $sum');

                _center.add(index);
                _Index.add(index);

                print('helo this is num on clicked value $text');
                sum = sum + text;
                print('helo this is sum value $sum');

                if (sum != 0) {
                  print('helo this is ur value $text');
                  setState(() {
                    print('helo this is sum value $sum');
                    if (sum == Ansr) {
                      ssum = '$ssum' + '=$sum';
                      new Future.delayed(const Duration(milliseconds: 250), () {
                        widget.onScore(1);
                        widget.onProgress((count1 + 2) / 6.5);
                        count1++;
                        for (var i = 0; i < _Index.length; i++) {
                          _letters[_Index[i]] = null;
                        }

                        sum = 0;
                        center = 0;
                        _center.removeRange(0, _center.length);
                        print(
                            'helo this is sum when resetting in it value $sum');
                        print(
                            'helo this is sum when resetting in it value $_letters');
                        _letters.forEach((e) {
                          if (e == null) {
                            count = count + 1;
                          }
                        });
                        ssum = '';
                        _letters.removeWhere((value) => value == null);
                        for (var i = 0; i < count; i++) {
                          _letters.add(null);
                        }
                        print("thhhiiiiiiisssss isss shanthuuuu$_val2");

                        _val2.removeRange(0, _val2.length);

                        Ansum = 0;
                        _val2 = _letters.sublist(0, z);
                        z++;
                        print("thhhiiiiiiisssss isss shanthuuuuiiiiiiii$_val2");
                        _val2.forEach((e) {
                          if (e == null) {}
                        });
                        print("my calling onennd value is $k");
                        _val2.removeWhere((value) => value == null);
                        k = _val2.length;

                        print("thid is the vlaue of length is valu$k");
                        for (num e in _val2) {
                          Ansum += e;
                        }
                        print("thhhiiiiiiisssss isss shanthuuuu$_val2");
                        Ansr = Ansum;

                        count = 0;
                        _statuses = _copyVal
                            .map((a) => Status.Active)
                            .toList(growable: false);
                        _Bgstatus = _copyVal
                            .map((a) => Bgstatus.BgActive)
                            .toList(growable: false);
                        _Index.removeRange(0, _Index.length);
                        _num2.removeRange(0, _num2.length);
                      });
                      k = _letters[4];
                      print("helllo this letters$k");
                      if (_letters[z] == null) {
                        setState(() {
                        print("its reload time ");
                          k = 0;
                          Ansr = 0;
                          ssum = '';
                          sum = 0;
                          _Index.removeRange(0, _Index.length);
                          _letters.removeRange(0, _letters.length);
                            _center.removeRange(0, _center.length);
                        });
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                          print("Rajesh Game-End");
                          widget.onEnd();
                        });
                      }

                      _val2.removeRange(0, _val2.length);
                    }
                  });
                }
              }
            });
          } else {
            setState(() {
              sum = 0;
              _statuses =
                  _copyVal.map((a) => Status.Active).toList(growable: false);
              _Bgstatus = _copyVal
                  .map((a) => Bgstatus.BgActive)
                  .toList(growable: false);
              _Index.removeRange(0, _Index.length);
              _num2.removeRange(0, _num2.length);
              _center.removeRange(0, _center.length);

              center = 0;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");

    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new LayoutBuilder(builder: (context, constraints) {
      var j = 0;

      return new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
                color: Colors.orange,
                height: 50.0,
                width: 50.0,
                padding: const EdgeInsets.all(10.0),
                child: new Center(
                    child: new Text("$Ansr",
                        style: new TextStyle(
                            color: Colors.black, fontSize: 25.0)))),
            new Container(
                color: Colors.orange,
                height: 40.0,
                child: new Center(
                    child: new Text("$ssum",
                        style: new TextStyle(
                            color: Colors.black, fontSize: 30.0)))),
            new Expanded(
                child: new ResponsiveGridView(
                  padding: new EdgeInsets.all(0.0),
              rows: _size,
              cols: _size,
              maxAspectRatio: 1.0,
              children: _letters
                  .map((e) => _buildItem(j, e, _statuses[j], _Bgstatus[j++]))
                  .toList(growable: false),
            )),
          ],
        ),
      );
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.status, this.bgstatus, this.onPress})
      : super(key: key);

  final int text;
  Status status;
  Bgstatus bgstatus;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  int _displayText;
  

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (!widget.text.isNaN) {
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

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");

    return new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(.0),
        ),
        child: new ScaleTransition(
          scale: animation,
          child: new GestureDetector(

              child: new RaisedButton(
                  onPressed: () => widget.onPress(),
       
                  color: widget.status == Status.Visible
                      ? Colors.yellow
                      : Colors.teal,
                  shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0))),
                  child: new Text("$_displayText",
                      style:
                          new TextStyle(color: Colors.black, fontSize: 24.0)))      ),
        ));
  }
}