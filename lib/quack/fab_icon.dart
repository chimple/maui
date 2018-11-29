import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/components/videoplayer.dart';
import 'package:maui/quack/post_comments.dart';
import 'package:maui/state/app_state_container.dart';

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
  // Animation<Color> _buttonColor;
  // Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.fastOutSlowIn;
  double _fabHeight = 56.0;
  String extStorageDir;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    // _buttonColor = ColorTween(
    //   begin: Colors.blue,
    //   end: Colors.red,
    // ).animate(CurvedAnimation(
    //   parent: _animationController,
    //   curve: Interval(
    //     0.00,
    //     1.00,
    //     curve: Curves.linear,
    //   ),
    // ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.49,
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
        onPressed: () {
          videoPlayButton(context);
          animate();
        },
        tooltip: 'Add',
        child: Image.asset('assets/action/Help.png'),
      ),
    );
  }

  Widget draw() {
    return Container(
      child: FloatingActionButton(
        heroTag: "draw",
        onPressed: () {
          animate();
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    DrawingWrapper(activityId: "dummy")),
          );
        },
        tooltip: 'draw',
        child: Image.asset('assets/action/drawing.png'),
      ),
    );
  }

  Widget comment() {
    return Container(
      child: FloatingActionButton(
        heroTag: "comment",
        onPressed: () {
          setState(() {
            animate();
            Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => PostComments()),
            );
          });
        },
        tooltip: 'comment',
        child: Image.asset('assets/action/post.png'),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
          heroTag: "toggle",
          // backgroundColor: _buttonColor.value,
          onPressed: animate,
          tooltip: 'Toggle',
          child: isOpened == false
              ? Image.asset('assets/action/Quack_button.png')
              : Image.asset('assets/action/Cross.png')),
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

  void videoPlayButton(BuildContext context) {
    final name = "assets/demo_video/bingo.mp4";
    File file = File(AppStateContainer.of(context).extStorageDir + name);
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new VideoApp(file: file)));
  }
}
