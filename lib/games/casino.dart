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
import 'package:maui/state/button_state_container.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/gameaudio.dart';

class Casino extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Casino(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
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
  List<String> lst = [];
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
    data = await fetchRollingData(widget.gameConfig.gameCategoryId, 6);
    print("Fetched Data $data");
    i = 0;
    j = 0;
    count = 0;

    _selectedItemIndex = 1;
    givenWord = " ";
    compareWord = " ";
    givenWordList.clear();
    lst.clear();
    print(" finalList inside  _initLetters = $finalList");
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

  @override
  void didUpdateWidget(Casino oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iteration != widget.iteration) {
      givenWordList.clear();
      _initLetters();
    }
  }

  Widget _buildScrollButton(
      BuildContext context, List<String> scrollingData, int buttonNumber) {
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
      if (givenWordList[j] == scrollingLetterList[random]) {
        _selectedItemIndex = scrollingLetterList.length - 1;
        if (scrollingLetterList[random] == 'a' ||
            scrollingLetterList[random] == 'A') {
          print("The letter is A");
          // var temp = scrollingLetterList[givenWordList.length - 1];
          scrollingLetterList[scrollingLetterList.length - 1] =
              scrollingLetterList[random];
          scrollingLetterList.removeAt(0);
        }

        print("Hey data shuffled");

        print("scrollingLetterList = $scrollingLetterList");
      }
      j++;
      print("j = $j");
    }

    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    return new Container(
      height: buttonConfig.height * 2,
      width: buttonConfig.width,
      child: new CasinoPicker(
        diameterRatio: 1.0,
        key: new ValueKey(j),
        scrollController: new CasinoScrollController(
            initialItem: _selectedItemIndex * random),
        itemExtent: 100.0,
        backgroundColor: new Color(0xFF734052),
        // backgroundColor: Colors.white,
        // isRotated: widget.isRotated,
        onSelectedItemChanged: (int index) {
          print("buttonNumber  $buttonNumber is triggered");

          for (int i = 0; i < givenWordList.length; i++) {
            if (buttonNumber == i) {
              print(
                  "index  number $index  scrollingLetterList[index] ${scrollingLetterList[index]}");

              if (givenWordList[i] == scrollingLetterList[index]) {
                print("Letters matched");

                // new Future.delayed(const Duration(milliseconds: 50), () {
                //   print("inside delay");
                // });
                lst.add(scrollingLetterList[index]);
                count++;
              } else if (givenWordList[i] != scrollingLetterList[index] &&
                  lst.isNotEmpty) {
                print("Letters are not equal");
                if (lst.contains(givenWordList[i]) && buttonNumber == i) {
                  print("Letter removed");
                  lst.remove(givenWordList[i]);
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
        },
        children:
            new List<Widget>.generate(scrollingLetterList.length, (int index) {
          print(
              "index inside list $index  Letter  ${scrollingLetterList[index]}");

          return new Center(
            child: new Text(scrollingLetterList[index],
                style: new TextStyle(
                  color: new Color(0xFFD64C60),
                  fontWeight: FontWeight.bold,
                  fontSize: 45.0,
                  letterSpacing: 5.0,
                )),
          );
        }),
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

    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / data.length;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / 5;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      if (_isShowingFlashCard) {
        return FractionallySizedBox(
          widthFactor:
              constraints.maxHeight > constraints.maxWidth ? 0.9 : 0.65,
          heightFactor:
              constraints.maxHeight > constraints.maxWidth ? 0.9 : 0.9,
          child: new FlashCard(
              text: givenWord,
              onChecked: () {
                widget.onEnd();
                // _initLetters();
                setState(() {
                  _isShowingFlashCard = false;
                });
              }),
        );
      }
      return new Column(
        // direction: Axis.vertical,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Expanded(
              flex: 1,
              child: new Material(
                color: Theme.of(context).accentColor,
                child: ResponsiveGridView(
                    rows: 1,
                    cols: data.length,
                    children:
                        widget.gameConfig.questionUnitMode == UnitMode.text
                            ? givenWordList
                                .map((e) => Padding(
                                    padding: EdgeInsets.all(buttonPadding),
                                    child: UnitButton(
                                      text: e,
                                    )))
                                .toList(growable: false)
                            : <Widget>[
                                UnitButton(
                                  maxWidth: maxHeight,
                                  maxHeight: maxHeight,
                                  text: givenWord.trim(),
                                  unitMode: widget.gameConfig.questionUnitMode,
                                )
                              ]),
              )),
          new Expanded(
            flex: 2,
            child: new ResponsiveGridView(
              cols: data.length,
              rows: 1,
              maxAspectRatio: 0.7,
              children: data.map((s) {
                return _buildScrollButton(context, s, scrollbuttonNumber++);
              }).toList(growable: false),
            ),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  width: maxHeight,
                  height: maxHeight,
                  // decoration: new BoxDecoration(
                  //   borderRadius: new BorderRadius.circular(20.0),
                  //   border: new Border.all(
                  //     width: 6.0,
                  //     color: new Color(0xFFD64C60),
                  //   ),
                  // ),
                  child: new RaisedButton(
                    onPressed: () {
                      if (const IterableEquality()
                              .equals(finalList, finalGivenWordList) &&
                          count >= givenWordList.length) {
                        new Future.delayed(const Duration(milliseconds: 1000),
                            () {
                          widget.onScore(5);
                          widget.onProgress(1.0);
                          j = 0;
                          count = 0;
                        });

                        new Future.delayed(const Duration(milliseconds: 800),
                            () {
                          setState(() {
                            _isShowingFlashCard = true;
                            lst.clear();
                          });
                        });

                        print("the end");
                      }
                    },
                    color: new Color(0xFF734052),
                    child: new Icon(Icons.check_box,
                        size: maxHeight * 0.7, color: new Color(0xFFD64C60)),
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8.0))),
                  ),
                ),
              ))
        ],
      );
    });
  }
}
