import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:maui/repos/game_data.dart';
import 'dart:async';

class Casino extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;

  Casino(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CasinoState();
}

class _CasinoState extends State<Casino> {
  int _selectedItemIndex = 0;
  List<List<String>> data;

  String givenWord = " ";
  bool _isLoading = true;
  // String wd = " ";
  var givenWordList = new List();
  int i = 0;
  int j=0;
 FixedExtentScrollController scrollController =
        new FixedExtentScrollController(initialItem: 3);
  
  @override
  void initState() {
    super.initState();
    _initletters();
  }

  void _initletters() async {
    data = await fetchRollingData(widget.gameCategoryId, 6);
  
    print("Fetched Data $data");
    for (var i = 0; i < data.length; i++) {
      givenWord += data[i][0];
      givenWordList.add(data[i][0]);
    }

    for (var i = 0; i < data.length; i++) {
      data[i].shuffle();
    }

    print("data $givenWord");
    print("===============");
    print("shuffled Data $data");

    setState(() => _isLoading = false);
   
  }

  Widget _buildScrollButton(List<String> scrollingData) {
    

    Set<String> scrollingLetter = new Set<String>.from(scrollingData);

    List<String> scrollingLetterList = new List<String>.from(scrollingLetter);
    print("scrollingLetterList[3] ${scrollingLetterList[3]}");
    if(scrollingLetterList[3]==givenWordList[j]){
      data[j].shuffle();
      j++;
      print("Hey data shuffled");

    }

    return new Container(
      height: 100.0,
      width: 50.0,
      child: new DefaultTextStyle(
        style: const TextStyle(
            color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.w900),
        child: new SafeArea(
          child: new CupertinoPicker(
            scrollController: scrollController,
            itemExtent: 35.0,
            backgroundColor: CupertinoColors.white,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedItemIndex = index;
              });

              if (givenWordList[i] == scrollingLetterList[index]) {
                if (i == givenWordList.length - 1) {
                  widget.onScore(2);
                  widget.onProgress(givenWordList.length / data.length);
                  print("index $index");
                  givenWord = " ";
                  new Future.delayed(const Duration(milliseconds: 500), () {
                    _initletters();
                    widget.onEnd();
                  });
                  print("the end");
                } else {
                  widget.onScore(2);
                  widget.onProgress(givenWordList.length / data.length);
                  print("index $index");
                }
                i++;
              }
            },
            children: new List<Widget>.generate(scrollingLetterList.length,
                (int index) {
              return new Center(
                child: new Text(scrollingLetterList[index]),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
          width: 20.0, height: 20.0, child: new CircularProgressIndicator());
    }
    return new Container(
      child: new Container(
        color: Colors.blue,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
                height: 100.0,
                width: 200.0,
                color: Colors.pinkAccent,
                child: new Center(
                    child: new Text(
                  givenWord,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50.0,
                      letterSpacing: 5.0,
                      color: Colors.white),
                ))),
            new Expanded(
              child: new Center(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: data.map((s) {
                    return _buildScrollButton(s);
                  }).toList(growable: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
