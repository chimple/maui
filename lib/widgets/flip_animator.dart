import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:math';

enum FlipDirection {
  VERTICAL,
  HORIZONTAL,
}

class FlipAnimator extends StatefulWidget {
  final Widget front;
  final Widget back;
  final FlipDirection direction;
  final AnimationController controller;

  const FlipAnimator(
      {Key key,
      @required this.front,
      @required this.back,
      this.direction = FlipDirection.HORIZONTAL,
      this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FlipAnimatorState();
  }
}

class _FlipAnimatorState extends State<FlipAnimator>
    with SingleTickerProviderStateMixin {
  Animation<double> _frontRotation;
  Animation<double> _backRotation;

  bool isFront = true;

  @override
  void initState() {
    super.initState();

    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(widget.controller);

    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _AnimationCard(
          animation: _frontRotation,
          child: widget.front,
          direction: widget.direction,
        ),
        _AnimationCard(
          animation: _backRotation,
          child: widget.back,
          direction: widget.direction,
        ),
      ],
    );
  }
}

class _AnimationCard extends StatelessWidget {
  _AnimationCard({this.child, this.animation, this.direction});

  final Widget child;
  final Animation<double> animation;
  final FlipDirection direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        if (direction == FlipDirection.VERTICAL) {
          transform.rotateX(animation.value);
        } else {
          transform.rotateY(animation.value);
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

class AnimatedFlip extends StatefulWidget {
  final Widget front;
  final Widget back;
  final FlipDirection direction;
  final bool isOpen;

  const AnimatedFlip(
      {Key key, this.front, this.back, this.direction, this.isOpen})
      : super(key: key);

  @override
  _AnimatedFlipState createState() => _AnimatedFlipState();
}

class _AnimatedFlipState extends State<AnimatedFlip>
    with TickerProviderStateMixin {
  AnimationController flipController;

  @override
  void initState() {
    super.initState();
    flipController = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
  }

  @override
  void didUpdateWidget(AnimatedFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) flipController.reverse();
    if (!widget.isOpen && oldWidget.isOpen) flipController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FlipAnimator(
      front: widget.front,
      back: widget.back,
      direction: widget.direction,
      controller: flipController,
    );
  }
}
