import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

class ChimpCharacter extends StatelessWidget implements FlareController {
  ChimpCharacter({Key key, this.itemNames}) : super(key: key);
  final List<String> itemNames;

  String temp;

  @override
  Widget build(BuildContext context) {
    return FlareActor(
      'assets/character/chimp_ik.flr',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: 'walking',
      controller: this,
    );
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (itemNames != null) {
      temp = itemNames.last.substring(0, 3);
      // print('object is $itemNames');
      for (var i = 0; i < itemNames.length; i++) {
        if (itemNames[i].startsWith(temp)) {
          itemNames[i] = itemNames.last;
        }
      }

      itemNames.toSet().forEach((String item) {
        final ActorNode acceName = artboard.getNode(item);
        acceName.collapsedVisibility = false;
      });
      // itemNames.clear();
    }

    return false;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {}

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  ValueNotifier<bool> isActive;
}
