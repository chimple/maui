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
  List<String> accessories = [
    'hat1',
    'hat2',
    'hat3',
    'hat4',
    'hat5',
    'hat6',
    'hat7',
    'hat8',
    'hat9',
    'hat10',
    'neck1',
    'neck2',
    'neck3',
    'neck4',
    'neck5',
    'neck6',
    'neck7',
    'neck8',
    'neck9',
    'neck10',
    'hat11',
    'head1',
    'head2',
    'head3',
    'head4',
    'head5',
    'head6',
    'head7',
    'head8',
    'head9',
    'head10',
    'glasses1',
    'glasses2',
    'glasses3',
    'glasses4',
    'glasses5',
    'glasses6',
    'glasses7',
    'glasses8',
    'glasses9',
    'glasses10',
    'flag1',
    'flag2',
    'flag3',
    'flag4',
    'flag5',
    'flag6',
    'flag7',
    'flag8',
    'flag9',
    'flag10',
    'brac1',
    'brac2',
    'brac3',
    'brac4',
    'brac5',
    'brac6',
    'brac7',
    'brac8',
    'brac9',
    'brac10',
    'antenna1',
    'antenna2',
    'antenna3',
    'antenna4',
    'antenna5',
    'antenna6',
    'antenna7',
    'antenna8',
    'antenna9',
    'antenna10',
  ];
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
    return FlareActor(
      "assets/character/chimp_ik.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: "walking",
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
    for (var i = 0; i < accessories.length; i++) {
      final s = artboard.getNode(accessories[i]);
      s.collapsedVisibility = true;
    }
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  ValueNotifier<bool> isActive;
}
