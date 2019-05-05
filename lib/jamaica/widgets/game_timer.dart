import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';

class GameTimer extends StatefulWidget {
  int time;
  Function(bool) timeEndCallback;
  final OnGameUpdate onGameUpdate;
  Function(String) timeCallback;
  GameTimer(
      {Key key,
      this.time,
      this.timeCallback,
      this.onGameUpdate,
      this.timeEndCallback})
      : super(key: key);
  @override
  GameTimerState createState() => GameTimerState();
}

class GameTimerState extends State<GameTimer> with TickerProviderStateMixin {
  AnimationController animationController;

  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}${(duration.inSeconds % 60)}';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: widget.time));
    animationController.reverse(
        from:
            animationController.value == 0.0 ? 1.0 : animationController.value);
    animationController.addStatusListener((status) {
      if (animationController.value == 0.0) {
        print("the values iss....");
        setState(() {
          widget.timeEndCallback(true);
        });
      }
    });
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return CustomPaint(
                painter: TimerPainter(
                    animation: animationController,
                    backgroundColor: Colors.white,
                    time: timerString,
                    color: Theme.of(context).accentColor),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;
  final String time;

  TimerPainter({this.animation, this.backgroundColor, this.color, this.time})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(0.0, size.height / 2);
    final end = Offset(size.width, size.height / 2);
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
    paint.color = Colors.blue;
    double progress = (1.0 - animation.value) * end.dx;
    canvas.drawLine(start, Offset(end.dx - progress, end.dy), paint);
    paint.color = Colors.orange;

    canvas.drawCircle(Offset(end.dx - progress, end.dy), 5.0, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value;
  }
}
