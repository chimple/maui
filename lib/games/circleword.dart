
import 'dart:math';
import 'dart:async';

import 'package:maui/components/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';

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
// enum ShakeCell { Right, InActive, Dance, CurveRow }


class CirclewordState extends State<Circleword> {

var score=0;

String word='';
var flag=0;
String words='';
 List<Status> _statuses;

 List<String> _letters1;
 bool _isLoading = true;
  List<String> wordata;

  
  List<Widget> widgets1 = new List();
  List<String> _letters;

  Tuple2<List<String >,String> data;
  
    @override
  void initState() {
    super.initState();
  
    _initBoard();
  }
    void _initBoard() async {
  setState(() => _isLoading = true);
    data= await fetchCirclewrdData(widget.gameCategoryId);

 print("the data is coming for cricleword ${data}");
 
     wordata=data.item1;
   
  _letters=data.item2.split('');
   

print("hwllo this is data is ....$_letters");
     _statuses = _letters.map((a) => Status.Active).toList(growable: false);

       setState(() => _isLoading = false);
   }
  
   @override
  void didUpdateWidget(Circleword oldWidget) {
    print("hello getter length getting null");
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
     
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
 MediaQueryData media = MediaQuery.of(context);
 if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
 print("object...mmmmmmannnn.${media.size.height}......${media.size.width}");


 
    return new LayoutBuilder(builder: (context, constraints) {
      double circleSize = constraints.maxHeight/2;
      double dradius;
    print("in layout builde hieght would be ...::..${constraints.maxHeight}..........$circleSize");
     print("width of layout builder is...........${constraints.maxWidth}");
    // widgets.add(new Container(
    //     width: circleSize,
    //     height: circleSize,
    //     decoration:
    //         new BoxDecoration(color: Colors.red, shape: BoxShape.circle)));
List<Widget> widgets = new List();
double hi=constraints.maxHeight/4;
    Offset circleCenter = new Offset(hi, hi);
    double csize=circleSize/3;
 print("all data sent to the method is $csize........$circleCenter");
 
    List<Offset> offsets1 = calculateOffsets(csize, circleCenter, _letters.length-1);
    print("object width is..... ${circleSize}");


    if(_letters.length>=9)
    {
      dradius=_letters.length-1.0+0.5;
    }
    else if(_letters.length<=5)
    {dradius=_letters.length+1.0+0.5;

    }
     
 

   List<Offset> offsets2 = calculateOffsets(0.0, circleCenter, 1);

   print(" ......offstes is.... $offsets2");
    List<Offset> offsets=offsets1+offsets2;
      print("this is  data");
      print(constraints.maxHeight);
      print(constraints.maxWidth);
      double _height, _width;
      _height = constraints.maxHeight;
      _width = constraints.maxWidth;
      // widgets.removeRange(0, widgets.length);
      // List<TableRow> rows = new List<TableRow>();
     print("widgets length is.....:....:${widgets.length}");
    
      var j = 0;
      // for (var i = 0; i <offsets.length; ++i) {
         
      //       //  Widget l   =
      //         widgets.add(_buildItem(offsets[i],j, _letters[i], Colors.teal,circleSize/dradius,_statuses[j++]));
              
      //       //  widgets.add(l);
           
          
      // }
      _letters.forEach((e)=>widgets.add(_buildItem(offsets[j],j, e, Colors.teal,circleSize/dradius,_statuses[j++])));
      double potl=180.0;
      double landl=140.0;
     double lposition= _height>_width ? potl:landl ;
  
      print("object the widgtes is.......${widgets}");
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

        print("value of all sent to here is in method is.......$circleRadii........$circleCenter");
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
       print("object..offsets is...:$offset");
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
  void dispose() {
    
    
    super.dispose();
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