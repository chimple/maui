import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/cute_button.dart';

class _ChoiceDetail {
  Reaction reaction;
  String question;
  String answer;
  bool appear;
  int index = 0;
  _ChoiceDetail({
    this.reaction = Reaction.success,
    this.appear,
    this.index,
  });
  @override
  String toString() =>
      '_ChoiceDetail(question: $question, appear: $appear , reaction: $reaction)';
}

class Matching extends StatefulWidget {
  final OnGameUpdate onGameUpdate;
  Matching({Key key, this.title, this.onGameUpdate}) : super(key: key);

  final String title;

  @override
  _MatchingState createState() => _MatchingState();
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
  List<int> _joinedLineStatus = [];
  int flag = 0,
      _index1,
      _index2,
      _count = 0,
      _complete = 0,
      _score = 0,
      _max = 0;
  bool _isUnderCircle = false, _connectStatus = false;
  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    _questionData.addAll(_data.keys);
    _answerData.addAll(_data.values);
    _question.addAll(_data.keys);
    _answer.addAll(_data.values);
    _max = _question.length * 2;
    _count = _question.length;
    _question.shuffle();
    _answer.shuffle();
    for (int i = 0; i < _data.length * 2; i++) _joinedLineStatus.add(0);
  }

  void _countOffsetOfCircle(Offset o) {
    _dottedCircleOffset.add(o + Offset(12.5, 12.5));
  }

  void _onStart(Offset start) {
    for (int i = 0; i < _dottedCircleOffset.length; i++) {
      if ((start - (_dottedCircleOffset[i])).distance < 35 &&
          _joinedLineStatus[i] != 1) {
        _index1 = i;
        if (i < _question.length) {
        } else {}
        _joinLine(i);
      }
    }
  }

  void _joinLine(int i) {
    // if (_joinedLineIndex != null) if (!_joinedLineIndex.contains(i))
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
      for (int i = 0; i < _dottedCircleOffset.length; i++) {
        if ((_updateOffset - _dottedCircleOffset[i]).distance < 35 &&
            _joinedLineStatus[i] != 1) {
          // print('index at end: $i');
          _index2 = i;
          _connectDottes();
        } else {
          setState(() {
            _connectStatus = true;
          });
        }
      }

      setState(() {
        _startOffset = null;
        _updateOffset = null;
        _offset = null;
        _isUnderCircle = false;
      });
    }
  }

  void _connectDottes() {
    if (_index1 < _question.length &&
        _index2 < _dottedCircleOffset.length &&
        _index2 >= _question.length) {
      // print('true from left side');
      if (_questionData.indexOf(_question[_index1]) ==
          _answerData.indexOf(_answer[_index2 - _answer.length])) {
        // print('${_answerData.indexOf(_answer[_index2 - _answer.length])}');
        setState(() {
          _joinedLinedOffset.addAll(
              {_dottedCircleOffset[_index1]: _dottedCircleOffset[_index2]});
          _joinedLineStatus[_index1] = 1;
          _joinedLineStatus[_index2] = 1;
        });

        _complete++;
      }
    } else if (_index1 >= _question.length && _index2 < _question.length) {
      // print('true from right side');
      if (_questionData.indexOf(_question[_index2]) ==
          _answerData.indexOf(_answer[_index1 - _answer.length])) {
        setState(() {
          _joinedLinedOffset.addAll(
              {_dottedCircleOffset[_index2]: _dottedCircleOffset[_index1]});
          _joinedLineStatus[_index1] = 1;
          _joinedLineStatus[_index2] = 1;
        });
      }

      _complete++;
    } else {
      setState(() {
        _connectStatus = true;
      });
    }
    _score += 2;
    widget.onGameUpdate(max: _max, score: _score, gameOver: false, star: true);
    if (_complete == _count) {
      print('game over');
      widget.onGameUpdate(max: _max, score: _score, gameOver: true, star: true);
    }
  }

  Widget _buildButton(String text, int index) {
    return CommonButton(
      text: text,
      key: Key('$index'),
    );
  }

  Widget _build(BoxConstraints constraint, int index, String s,
      AlignmentDirectional alignment) {
    return Stack(alignment: alignment, children: <Widget>[
      DottedCircle(
        height: (MediaQuery.of(context).size.height - constraint.maxHeight),
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
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: LayoutBuilder(builder: (context, constraint) {
              return Container(
                key: Key('match_the_dotts'),
                decoration: BoxDecoration(
                    color: Color(0xffA52A2A),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: CustomPaint(
                  foregroundPainter: DrawLine(
                      dottedOffset: _joinedLinedOffset,
                      connectStatus: _connectStatus,
                      startOffset: _startOffset,
                      endOffset: _updateOffset),
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onScaleStart: (ScaleStartDetails s) {
                        Offset start = (context.findRenderObject() as RenderBox)
                            .globalToLocal(s.focalPoint);
                        _onStart(start);
                      },
                      onScaleUpdate: (ScaleUpdateDetails d) {
                        Offset update =
                            (context.findRenderObject() as RenderBox)
                                .globalToLocal(d.focalPoint);
                        if (_isUnderCircle) _onUpdate(update);
                      },
                      onScaleEnd: _onEnd,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _question.map((s) {
                              return _build(constraint, index++, s,
                                  AlignmentDirectional.centerEnd);
                            }).toList(growable: false),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _answer.map((a) {
                              return _build(constraint, index++, a,
                                  AlignmentDirectional.centerStart);
                            }).toList(growable: false),
                          ),
                        ],
                      )),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class DrawLine extends CustomPainter {
  final Offset startOffset;
  final Offset endOffset;
  Map<Offset, Offset> dottedOffset;
  Map<Offset, Offset> points;
  final bool connectStatus;
  DrawLine(
      {this.endOffset,
      this.startOffset,
      this.dottedOffset,
      this.points,
      this.connectStatus}) {
    start = startOffset;
    end = endOffset;
  }
  Paint _paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = 6.0
    ..strokeCap = StrokeCap.round
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 4.0);
  Paint _paint1 = new Paint()
    ..color = Colors.white
    ..strokeWidth = 8.0
    ..strokeCap = StrokeCap.round
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 1.0);
  Offset start, end;
  @override
  void paint(Canvas canvas, Size size) {
    if (startOffset != null && endOffset != null) {
      canvas.drawLine(startOffset, endOffset, _paint1);
      canvas.drawCircle(startOffset, 10, _paint);
      canvas.drawCircle(endOffset, 10, _paint);
    }

    if (dottedOffset != null) {
      for (int i = 0; i < dottedOffset.length; i++)
        canvas.drawLine(dottedOffset.keys.elementAt(i),
            dottedOffset.values.elementAt(i), _paint);
    }
  }

  @override
  void addListener(listener) {
    super.addListener(listener);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CommonButton extends StatelessWidget {
  final String text;
  final Key key;
  CommonButton({this.text, this.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Colors.white54),
          boxShadow: [
            BoxShadow(
                blurRadius: 0.0, color: Colors.white54, offset: Offset(1, 4))
          ],
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 100.0,
      width: 100.0,
      child: Center(
          child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20),
      )),
    );
  }
}

class DottedCircle extends StatefulWidget {
  final GlobalKey key;
  final Function offsetOfCicle;
  final BoxConstraints constraint;
  final double height;
  DottedCircle({this.key, this.offsetOfCicle, this.constraint, this.height});
  @override
  DottedCircleState createState() {
    return new DottedCircleState();
  }
}

class DottedCircleState extends State<DottedCircle> {
  GlobalKey _globalKey = GlobalKey();
  List<Offset> _offsetOffAllDottedCircle = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(_) {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    Offset offset = -renderBoxRed.globalToLocal(Offset(0.0, widget.height));
    _offsetOffAllDottedCircle.add(offset);
    widget.offsetOfCicle(offset);
    // print("POSITION of dotted Cirlce: $offset, ");
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(12.5)),
      height: 25,
      width: 25,
      key: _globalKey,
    );
  }
}
