import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  int index;

  _ChoiceDetail({this.choice, this.reaction = Reaction.success, this.index});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, reaction: $reaction, index: $index)';
}

class ReflexGame extends StatefulWidget {
  final List<String> allLetters;

  const ReflexGame({Key key, this.allLetters}) : super(key: key);

  @override
  _ReflexGameState createState() => _ReflexGameState();
}

class _ReflexGameState extends State<ReflexGame> {
  var _currentIndex = 0;
  int _size = 4;
  List<String> _solvedLetters = [];
  List<String> _letters;
  List<String> _shuffledLetters = [];
  int _maxSize = 4;

  @override
  void initState() {
    super.initState();
    _size = min(_maxSize, sqrt(widget.allLetters.length).floor());
    _shuffledLetters = [];
    print('nys data ${widget.allLetters}');
    for (var i = 0; i < widget.allLetters.length; i += _size * _size) {
      _shuffledLetters.addAll(
          widget.allLetters.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
    }
    _letters = _shuffledLetters.sublist(0, _size * _size);
    _solvedLetters = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
            flex: 3,
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext ctxt, int index) {
                return Column(
                  children: <Widget>[
                    Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.blue,
                        child: Center(
                          child: Text(_solvedLetters[index]),
                        ))
                  ],
                );
              },
              itemCount: _solvedLetters.length,
            )),
        Flexible(
          flex: 7,
          child: BentoBox(
            calculateLayout: BentoBox.calculateVerticalLayout,
            axis: Axis.vertical,
            dragConfig: DragConfig.fixed,
            cols: _size,
            rows: _size,
            children: _letters
                .map((c) => c != null ? _buildItem(c) : Container())
                .toList(growable: false),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(String text) {
    return CuteButton(
        child: Center(
          child: Text(text),
        ),
        key: Key(text),
        onPressed: () {
          print('_buildItem.onPress');
          if (text == widget.allLetters[_currentIndex]) {
            setState(() {
              _letters[_letters.indexOf(text)] =
                  _size * _size + _currentIndex < widget.allLetters.length
                      ? _shuffledLetters[_size * _size + _currentIndex]
                      : null;
              _currentIndex++;
            });
            new Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                _solvedLetters.insert(0, text);
//                widget.onEnd(toJsonMap(), false);
              });
            });
            if (_currentIndex >= widget.allLetters.length) {
              new Future.delayed(const Duration(milliseconds: 250), () {
                // widget.onEnd(toJsonMap(), true);
              });
            }
            return Reaction.success;
          } else {
            return Reaction.failure;
            // wrong tap
          }
        });
  }
}
