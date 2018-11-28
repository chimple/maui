import 'package:flutter/material.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/quack/post_comments.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  String help = "Help";

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return Container(
     
      child: FloatingActionButton(
        heroTag: "add",
        onPressed: null,
        tooltip: 'Add',
        child:Image.asset('assets/hoodie/bingo.png'),
      ),
    );
  }

  Widget draw() {
    return Container(
      child: FloatingActionButton(
        heroTag: "draw",
        onPressed:  () {
          print("hiiiiiiiiiiiiii");
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    DrawingWrapper(activityId: "dummy")),
          );
        },
        tooltip: 'draw',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget comment() {
    return Container(
      child: FloatingActionButton(
        heroTag: "comment",
        onPressed: () {
          print("hiiiiiiiiiiiiii");
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                   PostComments()),
          );
        },
        tooltip: 'comment',
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: "toggle",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: draw(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: comment(),
        ),
        toggle(),
      ],
    );
  }
}
