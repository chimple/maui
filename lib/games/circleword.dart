

import 'dart:async';
import 'dart:math';
import 'package:maui/components/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/repos/lesson_unit_repo.dart';

import '../db/entity/lesson_unit.dart';
import '../repos/game_data.dart';



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
enum Status {Active, Visible, Disappear}
enum ShakeCell { Right, InActive, Dance, CurveRow }

class  CirclewordState extends State<Circleword> {
  int _size =3;
  String ssum = '';
  var count=0;
  int state = 1;
  List<ShakeCell> _ShakeCells = [];
  List<Status> _statuses;
  List<String> _letters= [];
 List<String> _letters4= [];
  List<String> _letters5= [];
   List<String> _letters6= [];
    List<String> _letters7= [];
     List<String> _letters8= [];
      List<String> _letters9= [];
 List<String> _letters10= [];

   List<String>  _worddata=[];
   List<String> _letters2 =[];
    List<String> _letters3 =[];
      var flag1=0;
    // ['acts','cast','cats','cat','scat','act','ta','st','sat','sac','at','tas','as','ats'];
 List<LessonUnit> lessonUnits;

  Tuple2<List<List<String >>,String> data;
 String dssum = '';

  get color => null;

 @override
  void initState() {
    super.initState();
    _initBoard();
  }
  void _initBoard() async {

    data = await  fetchCirclewrdData(widget.gameCategoryId);
 _statuses = _letters.map((a)=>Status.Active).toList(growable: false);
 


 print("the data is coming for cricleword ${data.item1[0]}");
  data.item1[0].forEach((e){_worddata.add(e); });
  print("data is coming in worddata2 $_worddata");
   for(var i=0; i<_worddata.length;i++)
   {
     _letters2.add(_worddata[i]);
  break;
   }
   print("the letters data is in it $_letters2");
   print("the data is ${_letters2}");
  //  _letters2.forEach((e){ _letters3.add(e);});
   
   _letters=_letters2[0].split('') ;
   _letters4=_letters.sublist(1,2);
   _letters5=_letters.sublist(2,3);
   _letters6=_letters.sublist(3,4);
   _letters7=_letters.sublist(4,5);
   _letters8=_letters.sublist(5,6);
   _letters9=_letters.sublist(6,7);

   print(" the data is$_letters4 ");
   print("data is 222 $_letters");
  _statuses = _letters.map((a)=>Status.Active).toList(growable: false);
 _ShakeCells=_worddata.map((a)=>ShakeCell.InActive).toList(growable: false);
  List<TableRow> rows = new List<TableRow>();
      var j = 0;
      // for (var i = 0; i < _size; ++i) {
      //   List<Widget> cells = _letters
      //       .skip(i)
      //       .take(1)
      //       .map((e) => _buildItem(j, e, _statuses[j],_ShakeCells[j++]))
      //       .toList();
      //   rows.add(new TableRow( 
      //     children: cells));
      // }

  }
 @override
  void didUpdateWidget(Circleword  oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      double _height, _width;
    _height = constraints.maxHeight;
      _width = constraints.maxWidth;
     
       List<TableRow> rows = new List<TableRow>();
      var j = 0;
      // for (var i = 0; i < _size; ++i) {
      //   List<Widget> cells = _letters
      //       .skip(i * _size)
      //       .take(_size)
      //       .map((e) => _buildItem(j, e, _statuses[j],_ShakeCells[j++]))
      //       .toList();
      //   rows.add(new TableRow( 
      //     children: cells));
      //     print("rows is ${rows[0]}");
      // }
      
      Color _myColor = Colors.teal;
    
      return new Container(
        child: new Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          //  new Container(
          //           width: 60.0,
          //           height: 40.0,
          //           color: Colors.teal,
          //           child: new Text(" value"),
          //         ),
          new Expanded(
          child:  new Container(
          //  width: _width+_width,
            height: _height,
            width: _width,
             
               alignment: Alignment.center,
     
                decoration: new BoxDecoration(
                  color: Colors.white,
                    border: new Border.all(
                        ),  
                    shape: BoxShape.circle),
                  
                     
             child: new Stack(
              
               children: <Widget>[
      //            new Container(
      //              height: _height*0.7,
      //            width: _width*0.5,
      //               child: new Center(
                
      //         // padding: new  EdgeInsets.all(0.03*_width ),
      //      child:new  Container(  
      //       //  child: new Padding(
      //       //    padding: new  EdgeInsets.all(0.03*_width ),
      // child: new Table(children: rows),
      //                 // )
      //                 ) 
      //                  ),
      //            )
      
             new Align(
            // alignment: Alignment.center,
            alignment: const Alignment(0.0, 0.0),
              child: new RaisedButton(
              color:_statuses[0] == Status.Active ? Colors.teal : Colors.yellow,
              padding: new  EdgeInsets.all(15.0),
                 onPressed:() { 
                   print("dsata osssssssss $_statuses"); 
                 
                  print("dsata opppsssssssss $_statuses"); 
                    if(_statuses[0]==Status.Active){setState(() {
                     flag1=1;
                    
                // if (_myColor  == Colors.teal) {
                  
                //  _myColor  = Colors.orange;
                // }
                // else {
                
                //   _myColor = Colors.teal;
                // }
                   
                 });
                   method1(_letters[0],color);
                    setState(() { _statuses[0] = Status.Visible;});
                 }
                 },
                 
                 
       
                 
                  shape: new CircleBorder(
                  
                    
                  ),
                          
                  child: new Text("${_letters[0]}")
                    )
          ),
              new Align(
            // alignment: Alignment.center,
            alignment: const Alignment(0.35, 0.25),
              child: new RaisedButton(
              color:_statuses[1] == Status.Active ? Colors.teal : Colors.yellow,
              padding: new  EdgeInsets.all(15.0),
                 onPressed:() { 
                   print("dsata osssssssss $_statuses"); 
                 
                  print("dsata opppsssssssss $_statuses"); 
                    if(_statuses[1]==Status.Active){setState(() {
                     flag1=1;
                    
                // if (_myColor  == Colors.teal) {
                  
                //  _myColor  = Colors.orange;
                // }
                // else {
                
                //   _myColor = Colors.teal;
                // }
                   
                 });
                   method1(_letters[1],color);
                    setState(() { _statuses[1] = Status.Visible;});
                 }
                 },
                 
                 
       
                 
                  shape: new CircleBorder(
                  
                    
                  ),
                          
                  child: new Text("${_letters[1]}")
                    )
          ),
            new Align(
            // alignment: Alignment.center,
            alignment: const Alignment(-0.3, 0.0),
            child: new RaisedButton(
              color:_statuses[2] == Status.Active ? Colors.teal : Colors.yellow,
              padding: new  EdgeInsets.all(15.0),
                 onPressed:() { 
                   print("dsata osssssssss $_statuses"); 
                 
                  print("dsata opppsssssssss $_statuses"); 
                    if(_statuses[2]==Status.Active){setState(() {
                     flag1=1;
                    
                // if (_myColor  == Colors.teal) {
                  
                //  _myColor  = Colors.orange;
                // }
                // else {
                
                //   _myColor = Colors.teal;
                // }
                   
                 });
                   method1(_letters[2],color);
                    setState(() { _statuses[2] = Status.Visible;});
                 }
                 },
                 
                 
       
                 
                  shape: new CircleBorder(
                  
                    
                  ),
                          
                  child: new Text("${_letters[2]}")
                    )
          ),
            new Align(
            // alignment: Alignment.center,
            alignment: const Alignment(-0.031, 0.28),
              child: new RaisedButton(
              color:_statuses[3] == Status.Active ? Colors.teal : Colors.yellow,
              padding: new  EdgeInsets.all(15.0),
                 onPressed:() { 
                   print("dsata osssssssss $_statuses"); 
                 
                  print("dsata opppsssssssss $_statuses"); 
                    if(_statuses[3]==Status.Active){setState(() {
                     flag1=1;
                    
                // if (_myColor  == Colors.teal) {
                  
                //  _myColor  = Colors.orange;
                // }
                // else {
                
                //   _myColor = Colors.teal;
                // }
                   
                 });
                   method1(_letters[3],color);
                    setState(() { _statuses[3] = Status.Visible;});
                 }
                 },
                 
                 
       
                 
                  shape: new CircleBorder(
                  
                    
                  ),
                          
                  child: new Text("${_letters[3]}")
                    )
          ),
            new Align(
            // alignment: Alignment.centerLeft,
            alignment: const Alignment(1.0, 0.03),
            child: new RaisedButton(
              color:_statuses[4] == Status.Active ? Colors.teal : Colors.yellow,
              padding: new  EdgeInsets.all(15.0),
                 onPressed:() { 
                   print("dsata osssssssss $_statuses"); 
                 
                  print("dsata opppsssssssss $_statuses"); 
                    if(_statuses[4]==Status.Active){setState(() {
                     flag1=1;
                    
                // if (_myColor  == Colors.teal) {
                  
                //  _myColor  = Colors.orange;
                // }
                // else {
                
                //   _myColor = Colors.teal;
                // }
                   
                 });
                   method1(_letters[4],color);
                    setState(() { _statuses[4] = Status.Visible;});
                 }
                 },
                 
                 
       
                 
                  shape: new CircleBorder(
                  
                    
                  ),
                          
                  child: new Text("${_letters[4]}")
                    )
         ),
            new Align(
            // alignment: Alignment.center,
            alignment: const Alignment(0.25, -0.54),
            child: new RaisedButton(
              color:_statuses[5] == Status.Active ? Colors.teal : Colors.yellow,
              padding: new  EdgeInsets.all(15.0),
                 onPressed:() { 
                   print("dsata osssssssss $_statuses"); 
                 
                  print("dsata opppsssssssss $_statuses"); 
                    if(_statuses[5]==Status.Active){setState(() {
                     flag1=1;
                    
                // if (_myColor  == Colors.teal) {
                  
                //  _myColor  = Colors.orange;
                // }
                // else {
                
                //   _myColor = Colors.teal;
                // }
                   
                 });
                   method1(_letters[5],color);
                    setState(() { _statuses[5] = Status.Visible;});
                 }
                 },
                 
                 
       
                 
                  shape: new CircleBorder(
                  
                    
                  ),
                          
                  child: new Text("${_letters[5]}")
                    )
          ),
            new Align(
            // alignment: Alignment.center,
            alignment: const Alignment(-0.20, -0.515),
             child: new RaisedButton(
              color:_statuses[6] == Status.Active ? Colors.teal : Colors.yellow,
              padding: new  EdgeInsets.all(15.0),
                 onPressed:() { 
                   print("dsata osssssssss $_statuses"); 
                 
                  print("dsata opppsssssssss $_statuses"); 
                    if(_statuses[6]==Status.Active){setState(() {
                     flag1=1;
                    
                // if (_myColor  == Colors.teal) {
                  
                //  _myColor  = Colors.orange;
                // }
                // else {
                
                //   _myColor = Colors.teal;
                // }
                   
                 });
                   method1(_letters[6],color);
                    setState(() { _statuses[6] = Status.Visible;});
                 }
                 },
                 
                 
       
                 
                  shape: new CircleBorder(
                  
                    
                  ),
                          
                  child: new Text("${_letters[6]}")
                    )
          ),
               ],
               
              
             ) ,  
           )
               ),
               new Container(
                 margin: new EdgeInsets.only(left: 250.0,bottom: 40.0),
          child: new RaisedButton(
              
                 onPressed:(() => method()),
       
                 
                  shape: new RoundedRectangleBorder(
                    
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(30.0))),
                          
                  child: new Text("submit")
                    )
               ),
                  
               new Container(
                 margin: new EdgeInsets.only(bottom: 20.0) ,
                 height: 40.0,
                 color: Colors.white,
                 child: new Text("$dssum",
                 style:
                    new TextStyle(color: Colors.black, fontSize: 24.0))),
               
          ],
        ),
      );
    });
  }
  Widget _buildItem(int index, String text,Status status,ShakeCell tile) {
    return new MyButton(
        key: new ValueKey<int>(index) ,
          status: status,
        text: text ,
         tile: tile,
        onPress: () {

          // print("repository  english is ${_suggestions[0]}");
                        if (status == Status.Active) {
                          print("hello if condition is in it");
                          if(text==text){
                        setState(() {
                   ssum='$ssum'+'$text';
                  _statuses[index] = Status.Visible;
                
                });
                print("hello this sum string is $ssum");
                  print("this is status is $_statuses");   
                        }
                        }
        }
    );}

  method() {
    print("method of ontab is $ssum");
    var c=0;
    c=ssum.length;
   
    print("the length of the string is $c");
     print("worddata is 11111$_worddata");
    _worddata.forEach((e){
      if(e.compareTo('$ssum')==0)

      { count=count+1;
  print("hello data ius shanthu count is $count");
       print("worddata is $_worddata");
        _worddata.remove(e);
         dssum="$dssum"+"$ssum"+" ,";
         print("hello this is the value is matched $_worddata");
         widget.onScore(c);
               
         c=0;
         ssum='';
         _statuses = _letters.map((a)=>Status.Active).toList(growable: false);
      if(count==2)
      {count=0;
      
                        
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                        
                          widget.onEnd();
                         
                        });
                         
                      
      _letters2.removeRange(0, _letters2.length);
       _worddata.removeRange(0,_worddata.length);
       _letters.removeRange(0, _letters.length);
      

      }
        
      }
    else{
  setState(() {
                   
        
                  _statuses = _letters.map((a)=>Status.Active).toList(growable: false);
                });
    }
     
    });
    ssum='';
   

  }

  method1(String letter, color) {
    ssum="$ssum"+"$letter";
    color=new Color(0xFF8b3);
    print("tthhhhhheee data  isss $ssum");
  }

}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text,this.status,this.tile, this.onPress}) : super(key: key);

  final String text;
  final VoidCallback onPress;
   ShakeCell tile;
Status status;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
//        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == null && widget.text != null) {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new Container(
        child: new Padding(
            padding: new EdgeInsets.all(3.0),


     child:new ScaleTransition(
        scale: animation,
        child: new GestureDetector(
            // onLongPress: () {
            //   showDialog(
            //       context: context,
            //       child: new FractionallySizedBox(
            //           heightFactor: 0.5,
            //           widthFactor: 0.8,
            //           child: new FlashCard(text: widget.text)));
            // },
            child: new RaisedButton(
              padding: new  EdgeInsets.all(15.0),
              //  color: new Color(0XFFFED2B7),
             
                onPressed: () => widget.onPress(),
                
                  color: widget.status == Status.Visible
                      ? Colors.yellow
                      : Colors.teal,
                shape: new CircleBorder(
                  
                   ),
                child: new Text(_displayText,
                    style:
                    new TextStyle(color: Colors.black, fontSize: 24.0))))) )) ;
  }
}