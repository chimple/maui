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
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';

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
    data = await fetchRollingData(widget.gameConfig.gameCategoryId, 5);
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
      if (scrollingLetterList[random] == givenWordList[j]) {
        _selectedItemIndex = givenWordList.length - 1;
        print("Hey data shuffled");
        print("scrollingLetterList = $scrollingLetterList");
      }
      j++;
    }

    AppState state = AppStateContainer.of(context).state;
    return new Container(
      height: state.buttonHeight * 2,
      width: state.buttonWidth,
//      padding: const EdgeInsets.all(8.0),
      child: new DefaultTextStyle(
        style: const TextStyle(
             fontSize: 30.0,
             fontWeight: FontWeight.w900
             ),
        child: new SafeArea(
          child: new CasinoPicker(
            key: new ValueKey(j),
            scrollController: new CasinoScrollController(
                initialItem: _selectedItemIndex * random),
            itemExtent: 50.0,
            // backgroundColor: new Color(0xfffff8c43c),
            isRotated: widget.isRotated,
            onSelectedItemChanged: (int index) {
              
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
                        )),
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

    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / data.length;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / 5;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;

      return new Padding(
        padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
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
                              ])),
            new Expanded(
              child: new ResponsiveGridView(
                cols: data.length,
                rows: 1,
                maxAspectRatio: 1.0,
                children: data.map((s) {
                  return _buildScrollButton(context, s, scrollbuttonNumber++);
                }).toList(growable: false),
              ),
            ),
          ],
        ),
      );
    });
  }
}
