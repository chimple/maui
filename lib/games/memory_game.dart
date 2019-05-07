import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';
import 'package:maui/widgets/flip_animator.dart';

class _ChoiceDetail {
  String choice;
  int list;
  int index;
  Reaction reaction;
  _Status status;
  _ChoiceDetail(
      {this.choice,
      this.list,
      this.index,
      this.reaction = Reaction.success,
      this.status = _Status.opened});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, type: $list, index: $index, reaction: $reaction, status: $status)';
}

enum _Status { closed, opened, escaping, escaped }

class MemoryGame extends StatefulWidget {
  final BuiltList<String> first;
  final BuiltList<String> second;
  final OnGameUpdate onGameUpdate;

  const MemoryGame({Key key, this.first, this.second, this.onGameUpdate})
      : super(key: key);

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<_ChoiceDetail> choiceDetails;
  _ChoiceDetail openedChoice;
  int _score = 0, _max = 0, _count = 0, _complete = 0;
  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.first
        .map((c) => _ChoiceDetail(choice: c, list: 1, index: i++))
        .toList();
    i = 0;
    choiceDetails.addAll(widget.second
        .map((c) => _ChoiceDetail(choice: c, list: 2, index: i++)));
    choiceDetails.shuffle();
    _max = choiceDetails.length * 2;
    _complete = widget.first.length;
    print(_max);
    print(_complete);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        choiceDetails.forEach((c) => c.status = _Status.closed);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      rows: 2,
      cols: widget.first.length,
      children: choiceDetails
          .map((c) => (c.status == _Status.closed || c.status == _Status.opened)
              ? GestureDetector(
                  key: Key('${c.list}_${c.index}'),
                  onTap: () => setState(() {
                        if (c.status == _Status.opened) {
                          c.status = _Status.closed;
                          openedChoice = null;
                        } else {
                          if (openedChoice == null) {
                            openedChoice = c;
                            c.status = _Status.opened;
                          } else {
                            if (openedChoice.index == c.index) {
                              Future.delayed(
                                Duration(milliseconds: 1000),
                                () => setState(() {
                                      openedChoice.status = _Status.escaping;
                                      c.status = _Status.escaping;
                                    }),
                              );
                              Future.delayed(
                                Duration(milliseconds: 2000),
                                () => setState(() {
                                      openedChoice.status = _Status.escaped;
                                      c.status = _Status.escaped;
                                      openedChoice = null;
                                    }),
                              );
                              _score += 2;
                              widget.onGameUpdate(
                                  max: _max,
                                  score: _score,
                                  gameOver: false,
                                  star: true);
                              _count++;
                              print(_count);
                              if (_complete == _count) {
                                print('game over');
                                widget.onGameUpdate(
                                    max: _max,
                                    score: _score,
                                    gameOver: true,
                                    star: true);
                                _count++;
                              }
                            } else {
                              Future.delayed(
                                Duration(milliseconds: 1000),
                                () => setState(() {
                                      openedChoice.status = _Status.closed;
                                      c.status = _Status.closed;
                                      openedChoice = null;
                                    }),
                              );
                              _score -= (_score != 0 ? 1 : 0);
                              widget.onGameUpdate(
                                  max: _max,
                                  score: _score,
                                  gameOver: false,
                                  star: true);
                            }
                            c.status = _Status.opened;
                          }
                        }
                      }),
                  child: AnimatedFlip(
                    back: Container(
                      decoration: BoxDecoration(
                      color: Colors.amber,
                        border: Border.all(
                          color: Colors.red,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    front: Container(
                      decoration: BoxDecoration(
                      color: Colors.white,
                        border: Border.all(
                          color: Colors.red,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text(c.choice)),
                    ),
                    direction: FlipDirection.HORIZONTAL,
                    isOpen: c.status == _Status.opened,
                  ),
                )
              : Container())
          .toList(growable: false),
      frontChildren: choiceDetails
          .where((c) => c.status == _Status.escaping)
          .map((c) => CuteButton(
                key: Key('${c.list}_${c.index}'),
                child: Center(child: Text(c.choice)),
              ))
          .toList(growable: false),
    );
  }
}
