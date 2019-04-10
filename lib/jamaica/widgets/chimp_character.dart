import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

class ChimpCharacter extends StatefulWidget {
  String itemName;
  ChimpCharacter({Key key, this.itemName}) : super(key: key);
  @override
  _ChimpCharacterState createState() => _ChimpCharacterState();
}

class _ChimpCharacterState extends State<ChimpCharacter>
    implements FlareController {
  @override
  void initState() {
    if (widget.itemName == null) {
      setState(() {
        widget.itemName = 'R_ear';
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('item name is ${widget.itemName}');
    return new FlareActor(
      "assets/character/chimple.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: "happy",
      controller: this,
    );
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    final acceName = artboard.getNode(widget.itemName);
    acceName.collapsedVisibility = false;
    return false;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    // print('sadsasadsad');
    print('initialize');
    final hat1 = artboard.getNode('hat1');
    hat1.collapsedVisibility = true;
    final hat2 = artboard.getNode('hat2');
    hat2.collapsedVisibility = true;
    final glasses1 = artboard.getNode('glasses1');
    glasses1.collapsedVisibility = true;
    final glasses2 = artboard.getNode('glasses2');
    glasses2.collapsedVisibility = true;
    final earring1 = artboard.getNode('earring1');
    earring1.collapsedVisibility = true;
    final earring2 = artboard.getNode('earring2');
    earring2.collapsedVisibility = true;
    final tattoo1 = artboard.getNode('tattoo1');
    tattoo1.collapsedVisibility = true;
    final tattoo2 = artboard.getNode('tattoo2');
    tattoo2.collapsedVisibility = true;
    final beard1 = artboard.getNode('beard1');
    beard1.collapsedVisibility = true;
    final beard2 = artboard.getNode('beard2');
    beard2.collapsedVisibility = true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
