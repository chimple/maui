import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/Shaker.dart';

class Connectdots extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Connectdots(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new ConnectdotsState();
}
enum Status {Active, Visible, Disappear}
enum ShakeCell { Right, InActive, Dance, CurveRow }

class ConnectdotsState extends State<Connectdots> {

  var  i=0;
  
  //var count=0;


  final int _size = 4;
  static int size=4;
   var j=size;
   var n=size;
  var m=size;
   var k=0;
   var count1=0;
   //var count2=0;
   var count3=0;
   var count6=0;
   var count4=0;
  //var count5=0;
  var count0=0;
  var r;
  var rand;
 
 List<String> numbers=[];

  List<String>_shuffledLetters = [];
 
  List _copyAns = [];
 
  List<String> _letters;
 
  List<String> _todnumber=[];
  List<Status> _statuses;
List<String> _letterex=[];
bool _isLoading = true;
var z=0;
 Tuple2<List<String>, List<String>> consecutive;


  List<ShakeCell> _ShakeCells = [];
   @override
  void initState() {
    super.initState();
    _initBoard();
  }

 void _initBoard() async {
  


    setState(() => _isLoading = true);
      consecutive= await fetchConsecutiveData(widget.gameCategoryId, 7,9);
print("hello this is the data od gamecategory ${widget.gameCategoryId}");
       
    print("this data is coming from fetchng ${consecutive.item1}");
   
 consecutive.item1.forEach((e) { _copyAns.add(e);});


 var rnge = new Random();
  for (var i = 0; i <1; i++) {
      rand= rnge.nextInt(2);
    
  }
     if(rand==1){
         consecutive.item1.forEach((e){ numbers.add(e);});
         consecutive.item2.forEach((v){numbers.add(v);});

     }
     else{
       consecutive.item2.forEach((e){ numbers.add(e);});
         consecutive.item1.forEach((v){numbers.add(v);});
     }
      print("suffle data is in my numbers is $numbers");
      
      print("sorted numbers are $numbers ");
  
    for (var i = 0; i < numbers.length; i += _size * _size) {
      _shuffledLetters.addAll(
          numbers.skip(i).take(_size * _size).toList(growable: true)
      );
    }
    _statuses = numbers.map((a)=>Status.Active).toList(growable: false);
_ShakeCells=numbers.map((a)=>ShakeCell.InActive).toList(growable: false);

    print(_shuffledLetters);


      var todnumbers= new List.generate(m, (_) => new List(n));
    for(var i=0; i<size; i++)
    {
      for(var j=0;j<size; j++)
      {
        count3= j+1+count1;

     //  count3= count2+j+1+count1;
      print("print something in forloop");
   _shuffledLetters.sublist(count1,count3).forEach((e){todnumbers[i][j]=e;});
    
        print("value of 2d is each time $todnumbers");
      }
      count1=count3;
   
     
    }
     for(var i=1;i<size;i++){
       if(i%2!=0){
    Iterable letdo = todnumbers[i].reversed; 
    var fReverse = letdo.toList();

    print("value of 2d is $todnumbers");

       print("RRRRRR $fReverse");
     todnumbers[i].setRange(0, size, fReverse.map((e)=>e));
 print("value o ooppps$todnumbers");
       }
     }

todnumbers.forEach((e){e.forEach((v){_todnumber.add(v);});});

 print("2d value is in my oops is$_todnumber");


 var todcolnumbers= new List.generate(m, (_) => new List(n));
    for(var i=0; i<size; i++)
    {
      if(i%2!=0){

        print("this treacing $count6");
        print("this treacing 2count$count4");

         for(var j=size-1;j>=0; j--) {
             count6= 1+count4;
            
      print("this jjjj is $j");

   _shuffledLetters.sublist(count4,count6).forEach((e){todcolnumbers[j][i]=e;});
      
        print("value of 2d is cols each time $todcolnumbers");
         count4=count6;
         }
         
      }
      else
      {
      for(var j=0;j<size; j++)
      {
        count6= j+1+count4;
      // count6= count2+j+1+count4;
      print("print something in forloop");
   _shuffledLetters.sublist(count4,count6).forEach((e){todcolnumbers[j][i]=e;});
    
        print("value of 2d is cols each time $todcolnumbers");
      }
      }
      count4=count6;
   
    }
   
   


   todcolnumbers.forEach((e){e.forEach((v){_letterex.add(v);});});
    
  
  var rng = new Random();
  for (var i = 0; i <1; i++) {
      r= rng.nextInt(4);
    
  }
  if(r==4){
    r=r-1;
  }
  print("hello sir $r");

  switch(r)
  {
    case 0: { 
      _letters=_todnumber;} 
     break;
     case 1: {  
       Iterable _number4 = _todnumber.reversed;
            var fruitsInReverset = _number4.toList();
            _letters=fruitsInReverset;
             } 
      break; 
     
      case 2: {  
           _letters=_letterex;
               } 
      break; 
      case 3: {  
       Iterable _number4 = _letterex.reversed;
            var fruitsInReverset = _number4.toList();
            _letters=fruitsInReverset;
             } 
      break; 
  }

    setState(() => _isLoading = false);
  }
   @override
  void didUpdateWidget(Connectdots oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
     
    }
  }

  Widget _buildItem(int index,String  text, Status status,ShakeCell tile) {

   
    return new MyButton(
        key:new  ValueKey<int>(index),
        text: text,
         index: index,
        status: status,
          tile: tile,
        onPress: () {
      
          if (status == Status.Active) {
            if(text==_copyAns[i])
            {

              setState(() {
                _statuses[index] = Status.Visible;
                widget.onScore(1);count0++;
                        widget.onProgress((count0) / (_copyAns.length-1));
                     

              });
              print("length is${_copyAns.length}");
             
            i++;
                print("hey this onend$i");
            
             if(i==_copyAns.length)
              {
                  k=0;
                                
    count1=0;
   
    count3=0;
    count6=0;
    count4=0;
   //count5=0;
   _todnumber.removeRange(0, _todnumber.length);
                _letters.removeRange(0, _letters.length);
                
                 _letterex.removeRange(0, _letterex.length);
                 numbers.removeRange(0, numbers.length);

   _shuffledLetters.removeRange(0, _shuffledLetters.length);

                 new Future.delayed(const Duration(milliseconds: 250),
                            () {
                        
                          widget.onEnd();
                         
                        });
              }

            }
            else{
                setState(() {
               _ShakeCells[index] = ShakeCell.Right;
               print("hello shake cell list$_ShakeCells");
                 new Future.delayed(const Duration(milliseconds: 400), () {
                  setState(() {
                    _ShakeCells[index] = ShakeCell.InActive;
                  });
                });

              });
            }
          }
       
        });


  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    var j = 0;
   
     return new ResponsiveGridView(
      rows: _size,
      cols: _size,
    maxAspectRatio: 1.0,
      children: _letters.map((e) => _buildItem(j, e, _statuses[j],_ShakeCells[j++])).toList(growable: false),
    );
  

  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.index,this.status,this.tile, this.onPress}) : super(key: key);

  final String text;
  int index;
  Status status;
   ShakeCell tile;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animationRight,animation, animationWrong, animationDance;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 10), vsync: this);
    controller =
       new  AnimationController(duration: new Duration(milliseconds: 250), vsync: this);
        animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
    animationWrong = new Tween(begin: -1.0, end: 1.0).animate(controller1);
    _myAnim();
  }
  void _myAnim() {
    animationWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");

    int _color =0xFF5F9EA0;


     if (widget.tile==ShakeCell.Right) {
      _color = 0xFFff0000; // red
    }

      return new ScaleTransition(
          scale: animation,
          child: new Shake(
   animation: widget.tile == ShakeCell.Right
                ? animationWrong
                : animationRight,
          

              child: new ScaleTransition(
                scale: animationRight,
             child: new RaisedButton(
                  onPressed: () => widget.onPress(),
       
                  color: widget.status == Status.Visible
                      ? new Color(0xFFffffff)
                      : new Color(_color),
                  shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0))),
                  child: new Text("$_displayText",
                  key: new Key(widget.index.toString()+"but"),
                      style:
                          new TextStyle(color: Colors.black, fontSize: 24.0)))      ),
       ) );
  }
}
