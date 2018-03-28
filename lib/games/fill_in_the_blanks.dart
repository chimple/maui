import 'package:maui/components/draggable_text.dart';
import 'package:maui/components/dragbox.dart';
import 'package:flutter/material.dart';

final fillblanks = [
  new Letters(0, 'S', 'A'),
  new Letters(1, 'P', ' '),
  new Letters(2, 'T', 'P'),
  new Letters(3, 'L', ' '),
  new Letters(4, 'K', 'E'),

];


class FillInTheBlanks extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  List<Letters> items;
  FillInTheBlanks({key, this.onScore, this.onProgress, this.onEnd, this.iteration,this.items})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _FillInTheBlanksState();
}

class _FillInTheBlanksState extends State<FillInTheBlanks> {
  List<Letters> items;
  @override
  Widget build(BuildContext context) {
    return new Expanded(
           child: new GameView(fillblanks)
        );
      }

}