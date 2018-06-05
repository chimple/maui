import 'dart:async';
import 'dart:math';
import 'package:maui/components/flash_card.dart';
import 'package:flutter/material.dart';

import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/Shaker.dart';
import 'package:flutter/rendering.dart';

// final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
// final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class Circleword extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;
 

  Circleword(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => new CirclewordState();
}

enum Status { Active, Visible, Disappear }
enum ShakeCell { Right, InActive, Dance, CurveRow }


class CirclewordState extends State<Circleword> {

var score=0;

String word='';
var flag=0;
String words='';
 List<Status> _statuses;
//  List<String> _letters;
 List<String> _letters1 = ['c', 't', 'a', 's', 'e', 'i', 'n', 'g', 's'];
//  List<String> _letters1 = ['c', 't', 'a', 's', 'e', ];
  List<String> wordata=['cats','acts','cast','cat','scat','act','ta',
  'st','sat','sac','at','tas','as','ats'];
  List<Widget> widgets = new List();
  List<Widget> widgets1 = new List();
  List<String> _letters;
  double dradius;
  //  _letters=_letters1;
    //  _statuses = _letters.map((a) => Status.Active).toList(growable: false);
    @override
  void initState() {
    super.initState();
  
    _initBoard();
  }
   void _initBoard()  {

    //  word='';
    // _letters=_letters1;
    // List<Widget> widgets;
    widgets.removeRange(0, widgets.length);

      // _letters1.forEach((e){_letters.add(e);});
_letters=_letters1;
print("hwllo this is data is ....$_letters");
     _statuses = _letters.map((a) => Status.Active).toList(growable: false);
   }
  
 
  
  @override
  Widget build(BuildContext context) {
    
 MediaQueryData media = MediaQuery.of(context);

 print("object....${media.size.height}......${media.size.width}");
double circleSize = media.size.height/2;
    
    
    // widgets.add(new Container(
    //     width: circleSize,
    //     height: circleSize,
    //     decoration:
    //         new BoxDecoration(color: Colors.red, shape: BoxShape.circle)));

    Offset circleCenter = new Offset(circleSize / 2, circleSize / 2);
    

    List<Offset> offsets1 = calculateOffsets(circleSize/3, circleCenter, _letters.length-1);
    print("object width is..... ${circleSize/8}");
    if(_letters.length>=9)
    {
      dradius=_letters.length-1.0+0.5;
    }
    else if(_letters.length<=5)
    {dradius=_letters.length+1.0+0.5;

    }

    // for (int i = 0; i < offsets.length; i++) {
    //   widgets.add(
    //       new PositionCircle(offsets[i], i.toString(), Colors.blue[900], 30.0));
    // }
    // offsets = calculateOffsets(1400.0, circleCenter, 7);
    // for (int i = 0; i < offsets.length; i++) {
    //   widgets.add(
    //       new PositionCircle(offsets[i], _letters[i], Colors.teal, 35.0,wordata));
    // }

   List<Offset> offsets2 = calculateOffsets(0.0, circleCenter, 1);

   print(" ......offstes is.... $offsets2");
    List<Offset> offsets=offsets1+offsets2;
    // for (int i = 0; i < offsets.length; i++) {
    //   widgets.add(
    //       new PositionCircle(offsets[i], i.toString(), Colors.teal, 35.0,wordata));
    // }

    return new LayoutBuilder(builder: (context, constraints) {
      print("this is  data");
      print(constraints.maxHeight);
      print(constraints.maxWidth);
      double _height, _width;
      _height = constraints.maxHeight;
      _width = constraints.maxWidth;
      // List<TableRow> rows = new List<TableRow>();
     
      var j = 0;
      for (var i = 0; i <offsets.length; ++i) {
         
            //  Widget l   =
              widgets.add(_buildItem(offsets[i],j, _letters[i], Colors.teal,circleSize/dradius,_statuses[j++]));
            //  widgets.add(l);
           
          
      }
      double potl=180.0;
      double landl=140.0;
     double lposition= _height>_width ? potl:landl ;
    //   _offsetmethod()
    //   {
      if(widgets.length>9){
    if(widgets.length>9)
    {
     widgets1= widgets.sublist(9,18);
      print("widgets data ....is.... $widgets1");
      // widgets1=widgets.sublist(0, 9);
      widgets.removeRange(0, widgets.length);
      // offsets.removeRange(0, offsets.length-9);
      widgets=widgets1;

      print("hello this is widgsted1sublist is .....$widgets");
     

    }
    else{
      widgets=widgets1;
     print("object widgtes is......$widgets");
      // widgets.removeRange(start, end)
      // widgets.sublist(0,9);
    }
      }
    //   }
      print("object the widgtes is.......${widgets1.length}");
       print("object the widgtes is.......${offsets.length}");
       print("object...$offsets");

      offsets=[];
      print("offsets is.....${offsets.length}");
      offsets1=[];
      print("offsets is.....$offsets1");
      offsets2=[];
      print("offsets is.....$offsets2");
      return new Container(
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
        children:[   
        new LimitedBox(
        child: new Container(
           width: circleSize,
        height: circleSize,
        decoration:
            new BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: new Stack(children: widgets)),
        ),
        new Container(
        width: 100.0,
        height: 40.0,
         
         margin: new EdgeInsets.only(left: lposition,top: 5.0),
        child: new RaisedButton(
          onPressed:()=> method(),
          
          
         
          child: new Text("submit"),
          
        ),
        ),
         new Container(
               margin: new EdgeInsets.only(bottom: 20.0) ,
               height: 40.0,
               color: Colors.white,
               child: new Text("$words",
               style:
                  new TextStyle(color: Colors.black, fontSize: 24.0))), 
    ]
    ),
      );

       
    
      
    });

    
  }

  //it calculates points on circle
  //these points are centers for small circles
  List<Offset> calculateOffsets(
      double circleRadii, Offset circleCenter, int amount) {
    double angle = 2 * pi / amount;
    double alpha = 0.0; 
    double x0 = circleCenter.dx;
    double y0 = circleCenter.dy;
    List<Offset> offsets = new List(amount);
    for (int i = 0; i < amount; i++) {
      double x = x0 + circleRadii * cos(alpha);
      double y = y0 + circleRadii * sin(alpha);
      offsets[i] = new Offset(x, y);
      print("object ..x..$x .....y...$y");
      // print("i:$i  alpha=${(alpha*180/pi).toStringAsFixed(1)}° ${offsets[i]}");
      alpha += angle;
    }
    return offsets;
  }

  method() {
    print("hello ");
    score=word.length;


    wordata.forEach((e){
      if(e.compareTo('$word')==0)

      {

setState(() {


       words="$words"+"$word"+" , "; 
         
        widget.onScore(score);
        _statuses = _letters.map((a) => Status.Active).toList(growable: false);
        });
      }
    });
    setState(() {
           _statuses = _letters.map((a) => Status.Active).toList(growable: false);
        });
     
    word='';

  }

 Widget _buildItem(Offset offset, int i, String text, MaterialColor teal, double d,Status status) {
   return new PositionCircle(
     key: new ValueKey<int>(i),
     offset:offset,
     text:text,
     teal:teal,
     d:d,
     status: status,
     onPress: () {
      if(flag==0){
        setState(() {
                   _statuses[i] = Status.Visible;
                });
        word=text;
        flag=1;
      }
      else{
          setState(() {
                   _statuses[i] = Status.Visible;
                });
       print("text inside opress is..... $text");
       print(" index....... $i");
       
       word="$word"+"$text";
       print("object... word is... $word");
      }
     }
  
   );
 }

 
}

class PositionCircle extends StatefulWidget {
  final Offset offset;
  final String text;
  final Color teal;
  final double d;
   Status status;
  final VoidCallback onPress;
// final String word;
  PositionCircle({Key key,this.offset, this.text, this.teal, this.d,this.status,this.onPress}): super(key: key);
  @override
  _PositionCircleState createState() => new _PositionCircleState();
}

class _PositionCircleState extends State<PositionCircle> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.offset;
    String word='';
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx - widget.d,
      top: position.dy - widget.d,
      width: widget.d * 2,
      height: widget.d * 2,
      child: new RawMaterialButton(
        shape: const CircleBorder(side: BorderSide.none),
        onPressed: () => widget.onPress(),
        fillColor:widget.status == Status.Visible?Colors.yellow: widget.teal,
        splashColor: Colors.yellow,
        child: new Text(widget.text,
        style:
                    new TextStyle(color: Colors.black, fontSize: 24.0)),
      ),
    );
  }

 
}