import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';

class Hoodie extends StatefulWidget {
  @override
  _HoodieState createState() {
    return new _HoodieState();
  }

}

class _HoodieState extends State<Hoodie> {
  FluttieAnimationController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    prepareAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new FluttieAnimation(_controller);
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
    var anim = await instance.loadAnimationFromResource(
        "assets/animations/koala_happy.json",
        bundle: DefaultAssetBundle.of(context)
    );
    // And prepare its animation, which should loop infinitely and take 2s per
    // iteration. Instead of RepeatMode.START_OVER, we could have choosen
    // REVERSE, which would play the animation in reverse on every second iteration.
    _controller = await instance.prepareAnimation(anim,
        duration: const Duration(seconds: 2),
        repeatCount: const RepeatCount.infinite(), repeatMode: RepeatMode.START_OVER);


    // Loading animations may take quite some time. We should check that the
    // widget is still used before updating it, it might have been removed while
    // we were loading our animations!
    if (mounted) {
      setState(() {
        _ready = true; // The animations have been loaded, we're ready
        _controller.start(); //start our looped emoji animation
      });
    }
  }
}