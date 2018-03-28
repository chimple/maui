import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'dart:ui' show window;
import 'dart:math';
var quest = 5;
var result=0;

class Abacus extends StatefulWidget {
 Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;


  Abacus({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>new  AbacusState();
}

class AbacusState extends State<Abacus> {
  var sum=0;
  var ia=0;
  List Check=[];
  final List<String> _allLetters = [
   
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    ];
  final int _size = 3;
 
  List<String> _shuffledLetters = [];
  List _Index = [];
  List<String> _letters;
 final List<String> _allLetters1=[
    '','','',
  ];
var u=1;
  var n=0;
  var m=0;
   List<String> _letters1;
  
 // var result=0;
  @override
  void initState() {
    super.initState();
     for (var i = 0; i < 3; i ++) {
      _shuffledLetters.addAll(
          _allLetters1.skip(0).take(_size).toList(growable: true)
      );
    }
    print(_shuffledLetters);
  
    for (var i = 0; i < _allLetters.length; i ++) {
      _shuffledLetters.addAll(
          _allLetters.skip(0).take(_size).toList(growable: true)
      );
    }
    print(_shuffledLetters);
    _letters = _shuffledLetters.sublist(0, _shuffledLetters.length);
    
   
  }

  Widget _buildItem(int index, String text) {

    final TextEditingController t1= new TextEditingController(text: text);
    return new MyButton(
      key:new  ValueKey<int>(index),
      text: text,
      index: index,
      onac: (index) {
          print('control transfer');
          print('index$index');
           setState((){
          var val=index;
          _Index.add(val);
       var num1=_letters[index];
       Check.add(num1);
      
       print("...............$index,$_Index,$u");
      
      if(result==quest){
        
      }else{
for(var i=0;i<_size;i++){
  if(_Index[0]%_size==i){
     if(Check[0]=='1'&&_Index[0]+_size>=_letters.length){
       if(_letters[_Index[0]-_size]==''){
_letters[_Index[0]-(3*_size)]='1';
_letters[_Index[0]]=''; result=result+pow(10,(_size-1-i));}
else{}

           }
  else if(Check[0]=='1'&&_letters[_Index[0]+_size]=='1'&&_Index[0]==i){}
     else if(Check[0]=='1'&&_letters[_Index[0]+_size]==''){
             _letters[_Index[0]]='';
             _letters[_Index[0]+(3*_size)]='1';
             result=result-pow(10,(_size-1-i));
           }
            else if(Check[0]=='1'&&_letters[_Index[0]-_size]==''){
              _letters[_Index[0]]='';
              _letters[_Index[0]-(3*_size)]='1';
            result=result+pow(10,(_size-1-i));
         
           } 
  }
  
}}_Index=[];
Check=[];
print("result==$result");
  });
             });


  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
print("letters1 $_letters1");
print("letters $_letters");
    
    List<TableRow> rows = new List<TableRow>();
   var  j = 0;
    for (var i = 0; i < _letters.length; i=i+_size) {
      List<Widget> cells = _letters
          .skip(i)
          .take(_size)
          .map((e) => _buildItem(j++, e))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    return new Center( child: new Container( 
    //  height: 400.0,
     // width: 200.0,
      decoration: const BoxDecoration(
    border: const Border(
      top: const BorderSide(width: 3.0, color: Colors.red),
      left: const BorderSide(width: 3.0, color:  Colors.red),
      right: const BorderSide(width: 3.0, color:  Colors.red),
      bottom: const BorderSide(width: 3.0, color:  Colors.red),
    ),
  ),
  
      child:  new Column(children: <Widget>[new Text(quest.toString()), new Question(),
   
    new Container(
        height: 3.0, //width: 100.0,
      
       color: Colors.black87,
      ),

     //new Expanded(child: 
     new Container(//height: 300.0,
     // width: 100.0,
      child: 
    new Table(children: rows)), new Container(
        height: 3.0,// width: 100.0,
      
       color: Colors.black87,
      ),
    
    
     ] ) ));
    
  
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text,this.index,this.onac}) : super(key: key);
 
  final String text;
  final DragTargetAccept onac;


List<String> letters;
int index;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;
List _Index=[];
List Check=[];
String let='';
 var val=0;
  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller =new
        AnimationController(duration:new Duration(milliseconds: 50), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
         // if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
       // }
      });
    controller.forward();
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
var tt='';
  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
   
    return new TableCell(
     
           child: new ScaleTransition(
              scale: animation,
               child: new Center(
           child:    new Container(
             height: 35.0,
             width: 35.0,
           
            child:new Stack( alignment: const Alignment(0.0, 0.0), children: <Widget>[
             
                 new Container(
          height: 40.0,
          width: 3.0,
          color: Colors.black,
        ), //new Column(  
new Draggable(child: 
  new GestureDetector(
               
  onVerticalDragEnd: (dynamic)=>widget.onac(widget.index),
             child:  new Container(
            // height: 10.0,
           //  width: 10.0,
          decoration:_displayText!=''? new BoxDecoration(
        color: Colors.red[400],
        shape: BoxShape.circle, 
      ):new BoxDecoration(), padding: new EdgeInsets.all(5.0),
                    child:new Text(_displayText,
                        style:new
                            TextStyle(color: Colors.white, fontSize: 24.0))),
                        
             ),
             feedback: new Container(),
                         //   onDragStarted: ()=>widget.onac(widget.index),
                          
    )]),))));
  }
}


class Question extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration:new BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.rectangle,
      ),

      child: new Text(result.toString()),
     );
  }

}