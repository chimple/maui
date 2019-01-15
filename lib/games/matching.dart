import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/state/app_state_container.dart';

class Matching extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  GameConfig gameConfig;
  Matching(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.function,
      this.gameCategoryId,
      this.gameConfig});
  @override
  _MatchingState createState() => new _MatchingState();
}

class _MatchingState extends State<Matching> {
  Map<String, String> _data = {'1': 'one', '3': '3', 'two': '2', '223': '223'};
  List<Offset> _dottedCircleOffset = [];
  Map<Offset, Offset> _joinedLinedOffset = {};
  List<String> _questionData = [],
      _answerData = [],
      _question = [],
      _answer = [];
  Offset _startOffset, _updateOffset, _offset;
  int _index1, _index2;
  bool _isUnderCircle = false;
  List<int> _joinedLineStatus = [];
  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    // final _allLetters =
    //     await fetchPairData(widget.gameConfig.gameCategoryId, 8);
    // print('all data :$_allLetters');
    _questionData.addAll(_data.keys);
    _answerData.addAll(_data.values);
    _question.addAll(_data.keys);
    _answer.addAll(_data.values);
    _question.shuffle();
    _answer.shuffle();
    for (int i = 0; i < _data.length * 2; i++) _joinedLineStatus.add(0);
  }

  void _countOffsetOfCircle(Offset o) {
    _dottedCircleOffset.add(o + Offset(12.5, 12.5));
  }

  void _onStart(Offset start) {
    print('offset on start:: $start');
    for (int i = 0; i < _dottedCircleOffset.length; i++) {
      if ((start - (_dottedCircleOffset[i])).distance < 35 &&
          _joinedLineStatus[i] != 1) {
        _index1 = i;
        print('index at stared:$i');
        if (i < _question.length) {
          print(
              'drag from left side:${_questionData.indexOf(_question[_index1])}');
        } else {
          print('drag from right side:');
        }
        _joinLine(i);
      }
    }
  }

  void _joinLine(int i) {
    _offset = _dottedCircleOffset[i];
    setState(() {
      _isUnderCircle = true;
      _startOffset = _offset;
    });
  }

  void _onUpdate(Offset offset) {
    setState(() {
      _updateOffset = offset;
    });
  }

  void _onEnd(ScaleEndDetails end) {
    if (_updateOffset != null && _startOffset != null) {
      print('offset at end:: $_updateOffset');
      for (int i = 0; i < _dottedCircleOffset.length; i++) {
        if ((_updateOffset - _dottedCircleOffset[i]).distance < 35 &&
            _joinedLineStatus[i] != 1) {
          print('index at end: $i');
          _index2 = i;
          _connectDottes();
        } else {}
      }
    }
    setState(() {
      _startOffset = null;
      _updateOffset = null;
      _offset = null;
    });
  }

  void _connectDottes() {
    if (_index1 < _question.length &&
        _index2 < _dottedCircleOffset.length &&
        _index2 >= _question.length) {
      print('true from left side');
      if (_questionData.indexOf(_question[_index1]) ==
          _answerData.indexOf(_answer[_index2 - _answer.length])) {
        print('${_answerData.indexOf(_answer[_index2 - _answer.length])}');
        setState(() {
          _joinedLinedOffset.addAll(
              {_dottedCircleOffset[_index1]: _dottedCircleOffset[_index2]});
          _joinedLineStatus[_index1] = 1;
          _joinedLineStatus[_index2] = 1;
        });
      }
    } else if (_index1 >= _question.length && _index2 < _question.length) {
      print('true from right side');
      if (_questionData.indexOf(_question[_index2]) ==
          _answerData.indexOf(_answer[_index1 - _answer.length])) {
        setState(() {
          _joinedLinedOffset.addAll(
              {_dottedCircleOffset[_index2]: _dottedCircleOffset[_index1]});
          _joinedLineStatus[_index1] = 1;
          _joinedLineStatus[_index2] = 1;
        });
      }
    } else {}
  }

  Widget _buildButton(String text, int index) {
    return UnitButton(
      text: text,
      key: Key('$index'),
    );
  }

  Widget _build(BoxConstraints constraint, int index, String s,
      AlignmentDirectional alignment) {
    return Stack(alignment: alignment, children: <Widget>[
      DottedCircle(
        keys: GlobalKey(debugLabel: index.toString()),
        height: MediaQuery.of(context).size.height - constraint.maxHeight,
        offsetOfCicle: _countOffsetOfCircle,
        constraint: constraint,
      ),
      Padding(
        padding: index < _question.length
            ? EdgeInsets.only(right: 12.5)
            : EdgeInsets.only(left: 12.5),
        child: _buildButton(s, index++),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth =
          (constraints.maxWidth - hPadding * 2) / 2; //- middle_spacing;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / 8;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;
      print('constraint Box:: $constraints');
      return Container(
        decoration: BoxDecoration(
            color: Color(0xffA52A2A),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: CustomPaint(
          foregroundPainter: DrawLine(
              dottedOffset: _joinedLinedOffset,
              startOffset: _startOffset,
              endOffset: _updateOffset),
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: (ScaleStartDetails str) {
                Offset start = (context.findRenderObject() as RenderBox)
                    .globalToLocal(str.focalPoint);
                _onStart(start);
              },
              onScaleUpdate: (ScaleUpdateDetails det) {
                Offset update = (context.findRenderObject() as RenderBox)
                    .globalToLocal(det.focalPoint);
                if (_isUnderCircle) _onUpdate(update);
              },
              onScaleEnd: _onEnd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _question.map((s) {
                      return _build(constraints, index++, s,
                          AlignmentDirectional.centerEnd);
                    }).toList(growable: false),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _answer.map((a) {
                      return _build(constraints, index++, a,
                          AlignmentDirectional.centerStart);
                    }).toList(growable: false),
                  ),
                ],
              )),
        ),
      );
    });
  }
}

class DottedCircle extends StatefulWidget {
  final Function offsetOfCicle;
  final BoxConstraints constraint;
  final double height;
  final GlobalKey keys;
  DottedCircle({this.keys, this.offsetOfCicle, this.constraint, this.height});
  @override
  DottedCircleState createState() {
    return new DottedCircleState();
  }
}

class DottedCircleState extends State<DottedCircle> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    final RenderBox renderBoxRed =
        widget.keys.currentContext.findRenderObject();
    final offset = -renderBoxRed.globalToLocal(Offset(0.0, widget.height));
    widget.offsetOfCicle(offset);
    print("POSITIONED of dotted Cirlce: $offset, ${widget.height}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(12.5)),
      height: 25,
      width: 25,
      key: widget.keys,
    );
  }
}

class DrawLine extends CustomPainter {
  final Offset startOffset;
  final Offset endOffset;
  Map<Offset, Offset> dottedOffset;
  Map<Offset, Offset> points;

  DrawLine({this.endOffset, this.startOffset, this.dottedOffset, this.points}) {
    start = startOffset;
    end = endOffset;
  }
  Paint _paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = 6.0
    ..strokeCap = StrokeCap.round
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 4.0);
  Paint _pain1 = new Paint()
    ..color = Colors.white
    ..strokeWidth = 8.0
    ..strokeCap = StrokeCap.round
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 1.0);
  Offset start, end;
  @override
  void paint(Canvas canvas, Size size) {
    if (startOffset != null && endOffset != null) {
      canvas.drawLine(startOffset, endOffset, _pain1);
    }

    if (dottedOffset != null) {
      for (int i = 0; i < dottedOffset.length; i++)
        canvas.drawLine(dottedOffset.keys.elementAt(i),
            dottedOffset.values.elementAt(i), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
