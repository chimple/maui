import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:maui/repos/game_data.dart';
import 'dart:async';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/casino_scroll_view.dart';
import 'package:maui/components/casino_picker.dart';

class Casino extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Casino(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CasinoState();
}

class _CasinoState extends State<Casino> {
  final int _selectedItemIndex = 3;
  List<List<String>> data;

  String givenWord = " ";
  bool _isLoading = true;
  // String wd = " ";
  var givenWordList = new List();
  int i = 0;
  int j = 0;
  bool _isShowingFlashCard = false;

  @override
  void initState() {
    super.initState();
    _initLetters();
  }

  void _initLetters() async {
    data = await fetchRollingData(widget.gameCategoryId, 6);
    print("Fetched Data $data");
    givenWord = '';
    givenWordList = [];
    for (var i = 0; i < data.length; i++) {
      givenWord += data[i][0];
      givenWordList.add(data[i][0]);
    }

    for (var i = 0; i < data.length; i++) {
      data[i].shuffle();
    }

    print("word $givenWord");
    print("===============");
    // print("shuffled Data $data");

    setState(() => _isLoading = false);
  }

  Widget _buildScrollButton(List<String> scrollingData) {
    Set<String> scrollingLetter = new Set<String>.from(scrollingData);
    List<String> scrollingLetterList = new List<String>.from(scrollingLetter);

    if (j < givenWordList.length) {
      print(
          "scrolling[$_selectedItemIndex] ${scrollingLetterList[_selectedItemIndex]}   givenletter ${givenWordList[j]}");
      if (givenWordList[j]==scrollingLetterList[_selectedItemIndex] ) {
        data[j].shuffle();
        print("Hey data shuffled");
      }
      j++;
    }

    return new Container(
      height: 100.0,
      width: 50.0,
      child: new DefaultTextStyle(
        style: const TextStyle(
            color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.w900),
        child: new SafeArea(
          child: new CasinoPicker(
            scrollController: new CasinoScrollController(initialItem: 3),
            itemExtent: 35.0,
            backgroundColor: new Color(0xfffff8c43c),
            isRotated: widget.isRotated,
            onSelectedItemChanged: (int index) {
              // setState(() {
              //   _selectedItemIndex = index;
              //   print("_selectedItemIndex  $_selectedItemIndex ");
              // });
              print("index $index");
              if (givenWordList[i] == scrollingLetterList[index]) {
                if (i == givenWordList.length - 1) {
                  widget.onScore(2);
                  widget.onProgress(1.0);
                  print("correct index $index");

                  new Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
                      _isShowingFlashCard = true;
                    });
                  });
                  print("the end");
                } else {
                  // widget.onProgress(1.0);
                  print("correct index $index");
                }
                i++;
                print("i= $i");
              }
            },
            children: new List<Widget>.generate(scrollingLetterList.length,
                (int index) {
              return new Center(
                child: new Text(
                  scrollingLetterList[index],
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      letterSpacing: 5.0,
                      color: Colors.black),
                ),
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
    if (_isShowingFlashCard) {
      return new FlashCard(
          text: givenWord,
          onChecked: () {
            _initLetters();
            widget.onEnd();
            setState(() {
              _isShowingFlashCard = false;
            });
          });
    }
    return new Container(
      child: new Container(
        color: new Color(0xfffff7ebcb),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              child: new Container(
                  height: 100.0,
                  width: 200.0,
                  color: new Color(0xffff52c5ce),
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
            ),
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
