import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';

class Hoodie extends StatefulWidget {
  int score;
  Hoodie(this.score);

  @override
  _HoodieState createState() {
    return new _HoodieState();
  }
}

class _HoodieState extends State<Hoodie> {
  FluttieAnimationController _happyController;
  FluttieAnimationController _sadController;
  bool _ready = false;
  int _prevScore;

  @override
  void initState() {
    super.initState();
    print("Hoodie.initState");
    prepareAnimation();
    _prevScore = widget.score;
  }

  @override
  void dispose() {
    _happyController?.dispose();
    _sadController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool happy = _prevScore <= widget.score;
    _prevScore = widget.score;
    return new IndexedStack(index: happy ? 0 : 1, children: <Widget>[
      new FluttieAnimation(
        _happyController,
//        size: new Size(200.0, 200.0),
      ),
      new FluttieAnimation(
        _sadController,
//          size: new Size(200.0, 200.0)
      )
    ]);
  }

  @override
  void didUpdateWidget(Hoodie oldWidget) {
    if (_ready) {
      if (widget.score > oldWidget.score) {
        _happyController.start();
      } else {
        _sadController.start();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  prepareAnimation() async {
    // Checks if the platform we're running on is supported by the animation plugin
    bool canBeUsed = await Fluttie.isAvailable();
    if (!canBeUsed) {
      print("Animations are not supported on this platform");
      return;
    }

    var instance = new Fluttie();

    // Load our first composition for the emoji animation
    var happyAnim = await instance.loadAnimationFromResource(
        "assets/animations/goat_sad3.json",
        bundle: DefaultAssetBundle.of(context));
    // And prepare its animation, which should loop infinitely and take 2s per
    // iteration. Instead of RepeatMode.START_OVER, we could have choosen
    // REVERSE, which would play the animation in reverse on every second iteration.
    _happyController = await instance.prepareAnimation(happyAnim,
        preferredSize: new Size(200.0, 200.0),
        duration: const Duration(seconds: 2),
        repeatCount: const RepeatCount.dontRepeat(),
        repeatMode: RepeatMode.START_OVER);

    var sadAnim = await instance.loadAnimationFromResource(
        "assets/animations/goat_sad3.json",
        bundle: DefaultAssetBundle.of(context));
    _sadController = await instance.prepareAnimation(sadAnim,
        preferredSize: new Size(200.0, 200.0),
        duration: const Duration(seconds: 2),
        repeatCount: const RepeatCount.dontRepeat(),
        repeatMode: RepeatMode.START_OVER);

    // Loading animations may take quite some time. We should check that the
    // widget is still used before updating it, it might have been removed while
    // we were loading our animations!
    if (mounted) {
      setState(() {
        _ready = true; // The animations have been loaded, we're ready
//        _controller.start(); //start our looped emoji animation
      });
    }
  }
}
