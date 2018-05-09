import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:maui/repos/game_data.dart';
import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/casino_scroll_view.dart';
import 'package:maui/components/casino_picker.dart';
import 'package:maui/components/responsive_grid_view.dart';

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
  int _selectedItemIndex;
  List<List<String>> data;

  String givenWord = " ";
  String compareWord = " ";
  bool _isLoading = true;

  var givenWordList = new List();
  var lst = new List();
  int i;
  int j;
  int count;
  // var answer = new List();
  bool _isShowingFlashCard = false;
  Set<String> finalGivenWordSet;
  List<String> finalGivenWordList;
  List<String> finalList;
  @override
  void initState() {
    super.initState();
    _initLetters();
  }

  void _initLetters() async {
    data = await fetchRollingData(widget.gameCategoryId, 6);
    print("Fetched Data $data");
    i = 0;
    j = 0;
    count = 0;

    _selectedItemIndex = 1;
    givenWord = " ";
    compareWord = " ";
    givenWordList.clear();
    lst.clear();
    print(" finalList _initLetters = $finalList");
    for (var i = 0; i < data.length; i++) {
      givenWord += data[i][0];
      givenWordList.add(data[i][0]);
    }

    finalGivenWordSet = new Set<String>.from(givenWordList);
    finalGivenWordList = new List<String>.from(finalGivenWordSet);
    finalGivenWordList.sort();

    print("givenWord $givenWord");
    print("===============");

    setState(() => _isLoading = false);
  }

  Widget _buildScrollButton(List<String> scrollingData, int buttonNumber) {
    Set<String> scrollingLetter = new Set<String>.from(scrollingData);
    List<String> scrollingLetterList = new List<String>.from(scrollingLetter);
    scrollingLetterList.sort();

    var rndm = new Random();
    var random = rndm.nextInt(5);

    print("===============");
    print("scrollingLetterList = $scrollingLetterList");
    print("scrollbuttonNumber  $buttonNumber");

    if (j < givenWordList.length) {
      print(
          "scrolling[random] ${scrollingLetterList[random]}   givenletter ${givenWordList[j]}");
      if (scrollingLetterList[random] == givenWordList[j]) {
        _selectedItemIndex = 0;
        print("Hey data shuffled");
        print("scrollingLetterList = $scrollingLetterList");
      }
      j++;
    }

    return new Container(
      // height: 100.0,
      // width: 50.0,

      padding: const EdgeInsets.all(8.0),
      child: new DefaultTextStyle(
        style: const TextStyle(
            color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.w900),
        child: new SafeArea(
          child: new CasinoPicker(
            key: new ValueKey(j),
            scrollController: new CasinoScrollController(
                initialItem: _selectedItemIndex * random),
            itemExtent: 50.0,
            backgroundColor: new Color(0xfffff8c43c),
            isRotated: widget.isRotated,
            onSelectedItemChanged: (int index) {
              // setState(() {
              //   _selectedItemIndex = index;
              // });
              print("buttonNumber  $buttonNumber is triggered");

              for (int i = 0; i < givenWordList.length; i++) {
                if (buttonNumber == i) {
                  print(
                      "index  number $index  scrollingLetterList[index] ${scrollingLetterList[index]}");
                  if (givenWordList[i] == scrollingLetterList[index]) {
                    print("Letters matched");
                    lst.add(scrollingLetterList[index]);
                    count++;
                  } else if (givenWordList[i] != scrollingLetterList[index] &&
                      lst.isNotEmpty) {
                    print("Letters are not equal");
                    if (lst.contains(givenWordList[i])) {
                      print("Letter removed");
                      lst.removeAt(i);
                    }
                  }
                }
              }
              lst.sort();
              print(" lst = $lst \n");
              print("");
              Set<String> finalSet = new Set<String>.from(lst);
              finalList = new List<String>.from(finalSet);

              print(" finalList = $finalList");

              print(" finalGivenWordList = $finalGivenWordList");
              print("count = $count");
              if (const IterableEquality()
                      .equals(finalList, finalGivenWordList) &&
                  count >= givenWordList.length) {
                widget.onScore(5);
                widget.onProgress(1.0);

                new Future.delayed(const Duration(milliseconds: 800), () {
                  setState(() {
                    _isShowingFlashCard = true;
                    lst.clear();
                  });
                });

                print("the end");
              }
            },
            children: new List<Widget>.generate(scrollingLetterList.length,
                (int index) {
              print(
                  "index inside list $index  Letter  ${scrollingLetterList[index]}");

              return new Center(
                child: new Text(scrollingLetterList[index],
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45.0,
                        letterSpacing: 5.0,
                        color: Colors.black)),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int scrollbuttonNumber = 0;
    if (_isLoading) {
      return new SizedBox(
          width: 20.0, height: 20.0, child: new CircularProgressIndicator());
    }
    if (_isShowingFlashCard) {
      return new FlashCard(
          text: givenWord,
          onChecked: () {
            widget.onEnd();
            // _initLetters();
            setState(() {
              _isShowingFlashCard = false;
            });
          });
    }

    return new Container(
      color: new Color(0xfffff7ebcb),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
              height: 200.0,
              width: 200.0,
              color: new Color(0xffff52c5ce),
              child: new Center(
                  child: new Text(
                givenWord,
                key: new Key("fruit"),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 100.0,
                    letterSpacing: 5.0,
                    color: Colors.white),
              ))),
          new Expanded(
            child: new Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(16.0))),
              child: new ResponsiveGridView(
                cols: data.length,
                rows: 1,
                maxAspectRatio: 0.7,
                children: data.map((s) {
                  return _buildScrollButton(s, scrollbuttonNumber++);
                }).toList(growable: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
