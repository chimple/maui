import 'dart:async';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/drop_box.dart';

class _ChoiceDetail {
  int choice;
  Reaction reaction;
  int index;
  bool appear;

  _ChoiceDetail(
      {this.choice,
      this.appear = true,
      this.reaction = Reaction.success,
      this.index});

  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, appear: $appear, reaction: $reaction)';
}

class ClockGame extends StatefulWidget {
  final int hour;
  final int minute;

  final BuiltList<int> choices;
  final OnGameUpdate onGameUpdate;

  const ClockGame(
      {Key key, this.choices, this.hour, this.minute, this.onGameUpdate})
      : super(key: key);

  @override
  ClockGameState createState() => ClockGameState();
}

class ClockGameState extends State<ClockGame> {
  List<_ChoiceDetail> choiceDetails;
  bool hourAppear = false;
  bool minuteAppear = false;
  int complete;
  int _score = 0;
  int _count = 0;

  @override
  void initState() {
    super.initState();

    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(choice: c))
        .toList(growable: false);
    complete = 2;
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Column(
      children: <Widget>[
        Flexible(flex: 3, child: clockFun()),
        Flexible(
          flex: 4,
          child: BentoBox(
            dragConfig: DragConfig.draggableBounceBack,
            qCols: 3,
            qRows: 1,
            qChildren: <Widget>[
              hourAppear
                  ? CuteButton(
                      key: Key((i++).toString()),
                      child: Center(child: Text('${widget.hour}')),
                    )
                  : DropBox(
                      key: Key((i++).toString()),
                      onWillAccept: (data) => true,
                      onAccept: (data) => setState(() {
                            print('This is dropping $data ,');
                            if (data == widget.hour.toString()) {
                              _score += 2;
                              print(' $_score');
                              print("this is my data ${data.length}");
                              print("this is my _score in match $_score");
                              hourAppear = true;
                              choiceDetails
                                  .firstWhere((c) => c.choice == widget.hour)
                                  .appear = false;
                              if (--complete == 0) {
                                // widget.onGameUpdate(_score);
                                widget.onGameUpdate(
                                    score: _score,
                                    max: 4,
                                    gameOver: true,
                                    star: true);
                                print('Game is over');
                              }
                            } else {
                              _score--;
                              _count++;
                              print(' $_score');
                              if (_count >= 2) {
                                widget.onGameUpdate(
                                    score: _score,
                                    max: 4,
                                    gameOver: true,
                                    star: false);
                                print('Game lose');
                              } else {
                                widget.onGameUpdate(
                                    score: _score,
                                    max: 4,
                                    gameOver: false,
                                    star: false);
                              }
                            }
                          }),
                    ),
              Center(
                child: Text(':', style: TextStyle(fontSize: 50.0)),
                key: UniqueKey(),
              ),
              minuteAppear
                  ? CuteButton(
                      key: Key((i++).toString()),
                      child: Center(child: Text('${widget.minute}')),
                    )
                  : DropBox(
                      key: Key((i++).toString()),
                      onWillAccept: (data) => true,
                      onAccept: (data) => setState(() {
                            print('This is dropping $data ,');
                            if (data == widget.minute.toString()) {
                              _score += 2;
                              print(' $_score');
                              print("this is my data ${data.length}");
                              print("this is my _score in match $_score");
                              minuteAppear = true;
                              choiceDetails
                                  .firstWhere((c) => c.choice == widget.minute)
                                  .appear = false;
                              if (--complete == 0) {
                                // widget.onGameUpdate(_score);
                                widget.onGameUpdate(
                                    score: _score,
                                    max: 4,
                                    gameOver: true,
                                    star: true);
                                print('Game is over');
                              }
                            } else {
                              _score--;
                              _count++;
                              print(' $_score');
                              if (_count >= 2) {
                                widget.onGameUpdate(
                                    score: _score,
                                    max: 4,
                                    gameOver: true,
                                    star: false);
                              } else
                                widget.onGameUpdate(
                                    score: _score,
                                    max: 4,
                                    gameOver: false,
                                    star: false);
                            }
                          }),
                    ),
            ],
            cols: 4,
            rows: 1,
            children: choiceDetails
                .map((c) => c.appear
                    ? CuteButton(
                        key: Key('${c.choice}'),
                        child: Center(child: Text('${c.choice}')),
                      )
                    : Container())
                .toList(growable: false),
          ),
        )
      ],
    );
  }

  Widget clockFun() {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size media = MediaQuery.of(context).size;
    return new Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: orientation == Orientation.portrait
                ? media.width / 2
                : media.width / 5,
            width: orientation == Orientation.portrait
                ? media.width / 2
                : media.width / 5,
            child: new Clock(
              circleColor: Colors.red,
              hours: widget.hour,
              minutes: widget.minute,
            ),
          ),
        ],
      ),
    );
  }
}

class Clock extends StatefulWidget {
  final Color circleColor;

  final int hours;
  final int minutes;
  final Duration updateDuration;

  Clock(
      {this.circleColor = Colors.black,
      this.hours,
      this.minutes,
      this.updateDuration = const Duration(
        milliseconds: 5,
      )});

  @override
  State<StatefulWidget> createState() {
    return _Clock();
  }
}

class _Clock extends State<Clock> {
  DateTime dateTime;
  String hours;
  String minutes;
  Timer _timer;
  int tempHour;
  int tempMinute;

  @override
  void initState() {
    super.initState();
    hours = (widget.hours < 10) ? '0${widget.hours}' : '${widget.hours}';
    minutes =
        (widget.minutes < 10) ? '0${widget.minutes}' : '${widget.minutes}';

    dateTime = DateTime.parse("1969-07-20 $hours:$minutes:00");

    tempHour = widget.hours == 0 ? 10 : widget.hours - 2;
    tempMinute = widget.minutes;
    this._timer = new Timer.periodic(widget.updateDuration, setTime);
  }

  void setTime(Timer timer) {
    tempMinute++;
    if (tempMinute > 59) {
      tempMinute = 0;
      tempHour++;
      if (tempHour > 11) {
        tempHour = 0;
      }
    }

    if (tempHour == widget.hours && tempMinute == widget.minutes) {
      _timer.cancel();
    }

    print(tempMinute);
    setState(() {
      hours = (tempHour < 10) ? '0$tempHour' : '$tempHour';
      minutes = (tempMinute < 10) ? '0$tempMinute' : '$tempMinute';
      dateTime = DateTime.parse("1969-07-20 $hours:$minutes:00");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(aspectRatio: 1.0, child: buildClockCircle(context));
  }

  Container buildClockCircle(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: widget.circleColor,
      ),
      child: new ClockFace(
        dateTime: dateTime,
      ),
    );
  }
}

class ClockFace extends StatelessWidget {
  final DateTime dateTime;

  ClockFace({this.dateTime});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new AspectRatio(
        aspectRatio: 1.0,
        child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Stack(
            children: <Widget>[
              new Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(10.0),
                child: new CustomPaint(
                  painter: new ClockDialPainter(context: context),
                ),
              ),
              new Center(
                child: new Container(
                  width: 15.0,
                  height: 15.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),
              new ClockHands(
                dateTime: dateTime,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClockDialPainter extends CustomPainter {
  final hourTickMarkLength = 10.0;
  final minuteTickMarkLength = 5.0;

  final hourTickMarkWidth = 3.0;
  final minuteTickMarkWidth = 1.5;

  final Paint tickPaint;
  final TextPainter textPainter;
  // final TextStyle textStyle;

  BuildContext context;

  ClockDialPainter({
    this.context,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ) {
    tickPaint.color = Colors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle = 2 * pi / 60;
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);
    for (var i = 0; i < 60; i++) {
      tickMarkLength = i % 5 == 0 ? hourTickMarkLength : minuteTickMarkLength;

      tickPaint.strokeWidth =
          i % 5 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      i % 5 == 0
          ? canvas.drawLine(new Offset(0.0, -radius),
              new Offset(0.0, -radius + tickMarkLength), tickPaint)
          : null;

      if (i % 5 == 0) {
        canvas.save();
        canvas.translate(0.0, -radius + 20.0);

        textPainter.text = new TextSpan(
          text: '${i == 0 ? 12 : i ~/ 5}',
          style: Theme.of(context).textTheme.headline,
        );

        canvas.rotate(-angle * i);

        textPainter.layout();

        textPainter.paint(canvas,
            new Offset(-(textPainter.width / 2), -(textPainter.height / 2)));

        canvas.restore();
      }

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ClockHands extends StatelessWidget {
  final DateTime dateTime;

  ClockHands({
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: new Stack(fit: StackFit.expand, children: <Widget>[
              new CustomPaint(
                painter: new HourHandPainter(
                  hours: dateTime.hour,
                  minutes: dateTime.minute,
                ),
              ),
              new CustomPaint(
                painter: new MinuteHandPainter(
                    minutes: dateTime.minute, seconds: dateTime.second),
              ),
            ])));
  }
}

class MinuteHandPainter extends CustomPainter {
  final Paint minuteHandPaint;
  int minutes;
  int seconds;

  MinuteHandPainter({this.minutes, this.seconds})
      : minuteHandPaint = new Paint() {
    minuteHandPaint.color = const Color(0xFF333333);
    minuteHandPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(2 * pi * ((this.minutes + (this.seconds / 60)) / 60));

    Path path = new Path();
    path.moveTo(-1.5, -radius - 10.0);
    path.lineTo(-5.0, -radius / 1.8);
    path.lineTo(-2.0, 10.0);
    path.lineTo(2.0, 10.0);
    path.lineTo(5.0, -radius / 1.8);
    path.lineTo(1.5, -radius - 10.0);
    path.close();

    canvas.drawPath(path, minuteHandPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(MinuteHandPainter oldDelegate) {
    return true;
  }
}

class SecondHandPainter extends CustomPainter {
  final Paint secondHandPaint;
  final Paint secondHandPointsPaint;

  int seconds;

  SecondHandPainter({this.seconds})
      : secondHandPaint = new Paint(),
        secondHandPointsPaint = new Paint() {
    secondHandPaint.color = Colors.red;
    secondHandPaint.style = PaintingStyle.stroke;
    secondHandPaint.strokeWidth = 2.0;

    secondHandPointsPaint.color = Colors.red;
    secondHandPointsPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(2 * pi * this.seconds / 60);

    Path path1 = new Path();
    Path path2 = new Path();
    path1.moveTo(0.0, -radius);
    path1.lineTo(0.0, radius / 4);

    path2.addOval(
        new Rect.fromCircle(radius: 7.0, center: new Offset(0.0, -radius)));
    path2.addOval(
        new Rect.fromCircle(radius: 5.0, center: new Offset(0.0, 0.0)));

    canvas.drawPath(path1, secondHandPaint);
    canvas.drawPath(path2, secondHandPointsPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(SecondHandPainter oldDelegate) {
    return this.seconds != oldDelegate.seconds;
  }
}

class HourHandPainter extends CustomPainter {
  final Paint hourHandPaint;
  int hours;
  int minutes;

  HourHandPainter({
    this.hours,
    this.minutes,
  }) : hourHandPaint = new Paint() {
    hourHandPaint.color = Colors.black87;
    hourHandPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(this.hours >= 12
        ? 2 * pi * ((this.hours - 12) / 12 + (this.minutes / 720))
        : 2 * pi * ((this.hours / 12) + (this.minutes / 720)));

    Path path = new Path();

    path.moveTo(-1.0, -radius + radius / 4);
    path.lineTo(-5.0, -radius + radius / 2);
    path.lineTo(-2.0, 0.0);
    path.lineTo(2.0, 0.0);
    path.lineTo(5.0, -radius + radius / 2);
    path.lineTo(1.0, -radius + radius / 4);
    path.close();

    canvas.drawPath(path, hourHandPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HourHandPainter oldDelegate) {
    return true;
  }
}
