import 'package:maui/components/draggable_text.dart';
import 'package:maui/components/dragbox.dart';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
//[[a, V], [p, X], [, p], [, l], [e, O]]


class FillInTheBlanks extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  List<Letters> items;
  FillInTheBlanks({key, this.onScore, this.onProgress, this.onEnd, this.iteration,this.gameCategoryId,this.items})
      : super(key: key);


  @override
  State<StatefulWidget> createState() => new _FillInTheBlanksState();
}

class _FillInTheBlanksState extends State<FillInTheBlanks> {
  List<Letters> fillblanks;
 // _FillInTheBlanksState(this.fillblanks);

//  [
//       new Letters(0, 'T', 'P'),
//      new Letters(1, 'L', ' '),
//      new Letters(2, 'K', 'E'),
//      new Letters(3, 'L', ' '),
//  ]
//  ;

  //List<Letters> items;
  //int count =0;
  
  List<Tuple2<String, String>> _fillData;

  void initState()
  {
    super.initState();
    _initFillBlanks();
  }
  bool _isLoading = true;
  void _initFillBlanks() async {
    setState(()=>_isLoading=true);
    _fillData = await fetchWordWithBlanksData(widget.gameCategoryId);
    int i = 0;
    fillblanks = _fillData.map((f) {
      return new Letters(i++, f.item2, f.item1);
    }).toList(growable: false);
    setState(()=>_isLoading=false);
    // String temp1 = _fillData[count].item1;
    // String temp2 = _fillData[count].item2;

//    new Letters(2, 'T', 'P'),
//    new Letters(3, 'L', ' '),
//    new Letters(4, 'K', 'E'),
//    new Letters(5, 'L', ' '),
//    new Letters(6, 'K', 'E'),
   // print("$temp1"+"$temp2");
  }
  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new Expanded(
           child: new GameView(fillblanks)
        );
      }

}