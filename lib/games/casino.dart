import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const List<String> letters = const <String>[
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];
String value = 'APPLE';
  class CasinoButton extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new CasinoButtonState();    // TODO: implement createState

}
class CasinoButtonState extends State<CasinoButton> {
  @override
  Widget build(BuildContext context) {
    for(var i=0;i<5;i++)
    {
       if(value.contains(letters[i])){
       }
    }
  }

}
class Casino extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Casino({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CasinoState();
}

class _CasinoState extends State<Casino> {
  int _selectedItemIndex = 0;

  Widget _buildScrollButton() {
    final FixedExtentScrollController scrollController =
        new FixedExtentScrollController(initialItem: _selectedItemIndex);

    return new Container(
      height: 100.0,
      width: 50.0,
      child: new DefaultTextStyle(
        style: const TextStyle(
            color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.w900),
        child: new SafeArea(
          child: new CupertinoPicker(
            scrollController: scrollController,
            itemExtent: 30.0,
            backgroundColor: CupertinoColors.white,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedItemIndex = index;
              });
            },
            children: new List<Widget>.generate(letters.length, (int index) {
              return new Center(
                child: new Text(letters[index]),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Container(
        color: Colors.blue,
        child: new Column(
          children: <Widget>[
            new Container(
                height: 100.0,
                width: 200.0,
                color: Colors.pinkAccent,
                child: new Center(
                    child: new Text(
                  value,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50.0,
                      letterSpacing: 5.0,
                      color: Colors.white),
                ))),
            new Expanded(
              child: new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildScrollButton(),
                    _buildScrollButton(),
                    _buildScrollButton(),
                    _buildScrollButton(),
                    _buildScrollButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
