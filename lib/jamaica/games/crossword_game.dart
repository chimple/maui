import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/drop_box.dart';
import 'package:maui/models/crossword_data.dart';
import 'package:tuple/tuple.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  bool appear;
  String image;

  _ChoiceDetail(
      {this.choice,
      this.appear = true,
      this.image = '',
      this.reaction = Reaction.success});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, appear: $appear, image: $image, reaction: $reaction)';
}

class CrosswordGame extends StatefulWidget {
  final BuiltList<ImageData> images;
  final BuiltList<BuiltList<String>> data;
  final OnGameOver onGameOver;

  const CrosswordGame({
    Key key,
    this.images,
    this.data,
    this.onGameOver,
  }) : super(key: key);

  @override
  _CrosswordGameState createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<CrosswordGame> {
  List<_ChoiceDetail> choiceDetails = [];
  List<_ChoiceDetail> crossword = [];
  List<String> choices = [];
  List<int> letterIndex = [];
  List<int> imageIndex = [];

  int rows;
  int cols;
  int complete, score = 0;

  @override
  void initState() {
    super.initState();
    cols = widget.data.length;
    rows = widget.data[0].length;

    List<String> letters = [];
    widget.data.forEach((e) {
      e.forEach((v) {
        letters.add(v);
      });
    });

    for (var n = 0; n < widget.images.length; n++) {
      imageIndex.add(widget.images[n].x * rows + widget.images[n].y);
    }
    var len = imageIndex.length + 1;
    if (len > 14) {
      len = 14;
    }
    var rng = new Random();
    var f = 0;
    for (var t = 0; t < letters.length; t++) {
      f = 0;
      for (var j = 0; j < imageIndex.length; j++) {
        if (t == imageIndex[j]) {
          f = 1;
        }
      }
      if (letters[t] != '' && f != 1) {
        if (rng.nextInt(2) == 1) {
          choices.add(letters[t]);
          letterIndex.add(t);
        }
      }
      if (t == letters.length - 1) {
        if (choices.length != len) {
          t = 0;
          choices = [];
          letterIndex = [];
        }
      }
    }
    choices.shuffle();

    choiceDetails =
        choices.map((c) => _ChoiceDetail(choice: c)).toList(growable: false);

    complete = letterIndex.length;

    for (int p = 0; p < letters.length; p++) {
      crossword.add(_ChoiceDetail(
          choice: letters[p],
          appear: letterIndex.contains(p) ? false : true,
          image: imageIndex.contains(p)
              ? widget.images[imageIndex.indexOf(p)].image
              : ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    int i = 0, k = 0;
    return BentoBox(
      rows: cols > choiceDetails.length ? 1 : 2,
      cols: cols > choiceDetails.length ? choiceDetails.length : cols - 1,
      children: choiceDetails
          .map((c) => c.appear
              ? CuteButton(
                  key: Key((k++).toString()),
                  child: Center(child: Text(c.choice)),
                )
              : Container(key: Key((k++).toString())))
          .toList(growable: false),
      qRows: rows,
      qCols: cols,
      qChildren: crossword
          .map((f) => f.choice == ''
              ? Container(
                  key: Key('A' + (i++).toString()),
                  decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                )
              : Stack(
                  key: Key('A' + (i++).toString()),
                  children: [
                    f.image != ''
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            child: Center(child: Image.asset(f.image)))
                        : Container(),
                    !f.appear
                        ? DropBox(
                            onWillAccept: (data) =>
                                choiceDetails[int.parse(data)].choice ==
                                f.choice,
                            onAccept: (data) => setState(() {
                                  score++;
                                  if (--complete == 0) widget.onGameOver(score);
                                  f.appear = true;
                                  choiceDetails[int.parse(data)].appear = false;
                                }),
                          )
                        : f.image != ''
                            ? Center(child: Text(f.choice))
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.0))),
                                child: Center(child: Text(f.choice)))
                  ],
                ))
          .toList(growable: false),
      dragConfig: DragConfig.draggableBounceBack,
    );
  }
}
