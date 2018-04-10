import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'dart:ui' show window;
import 'dart:math';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
var quest = 0;
var result=0;

class Abacus extends StatefulWidget {
 Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
 int gameCategoryId;
 bool isRotated;

  Abacus({key, this.onScore, this.onProgress, this.onEnd, this.iteration,this.gameCategoryId, this.isRotated=false})
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
    int _size = 4;
   bool _isLoading = true;
  List<String> _shuffledLetters = [];
  List _Index = [];
  List status=[0,1,1,1,1];
  List<String> _letters;
   Tuple4<int,String,int,int> data;
 final List<String> _allLetters1=[
    '','','','','',''
  ];
var u=1;
  var n=0;
  var m=0;
  var finalans=0;
   List<String> _letters1=[];
  
 // var result=0;
  @override
  void initState() {
    super.initState();
   _initBoard();
  }

  void _initBoard() async{
     setState(() => _isLoading = true);
     data= await  fetchMathData(widget.gameCategoryId);
    print('data is $data');
     print('data is ${data.item1}');
      var q=data.item4.toString();
_size=q.length;
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
    quest=data.item1;
    result=0;
    finalans=data.item4;
    var x=data.item1;
    var y=data.item2;
    var z=data.item3;
   
    _letters1.add(x.toString());
    _letters1.add(y.toString());
    _letters1.add(z.toString());
    _letters1.add('=');
    _letters1.add('?');
    print('data in array$_letters1');
     setState(() => _isLoading = false);
  //print(' data from database${fetchMathData(1)}');
  }

  Widget _buildItem(int index, String text,int stat) {

    final TextEditingController t1= new TextEditingController(text: text);
    return new MyButton(
      key:new  ValueKey<int>(index),
      text: text,
      index: index,
      colorflag: stat,
      onac: (index) {
      
          print('control transfer');
          print('index$index');
           setState((){
          var val=index;
          _Index.add(val);
       var num1=_letters[index];
       Check.add(num1);
      
       print("...............$index,$_Index,$u");
      
      if(result==finalans){}
      
      else{
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
  
}}
 if(result==quest){
       quest=finalans;
       status[2]=0;
       status[0]=1;
        if(result==finalans){
          _letters1[4]=finalans.toString();
          status[2]=1;
          status[4]=0;  widget.onEnd();
        new Future.delayed(const Duration(milliseconds: 500), () {
                widget.onEnd();
              });
      }
      }
_Index=[];
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
      if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    List<TableRow> rows = new List<TableRow>();
   var  j = 0;
    for (var i = 0; i < _letters.length; i=i+_size) {
      List<Widget> cells = _letters
          .skip(i)
          .take(_size)
          .map((e) => _buildItem(j++, e,status[0]))
          .toList();
      rows.add(new TableRow(children: cells));
    }

 List<TableRow> rows1 = new List<TableRow>();
   var  k = 100;j=0;
    for (var i = 0; i < _letters1.length; i=i+5) {
      List<Widget> cells = _letters1
          .skip(i)
          .take(5)
          .map((e) => _buildItem(k++, e,status[j++]))
          .toList();
      rows1.add(new TableRow(children: cells));
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
    new Container(//height: 300.0,
      width: 300.0,
      child: 
    new Table(children: rows1)),
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
  MyButton({Key key, this.text,this.index,this.onac,this.colorflag,this.textflag}) : super(key: key);
 
  final String text;
  final DragTargetAccept onac;
  final int colorflag;
  final int textflag;

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
   if(widget.index>=100){

return new TableCell(
  child: new Center(
   child:  new Container(
     height: 50.0,
     width: 50.0,
      decoration: new BoxDecoration(
        color:widget.colorflag!=0? Colors.white30:Colors.yellowAccent,
        shape: BoxShape.rectangle
        
      ), padding: new EdgeInsets.all(10.0),
      child: new Text(widget.text,
       style:new
                            TextStyle(color: Colors.red, fontSize: 24.0)) ,
    )
  ),

);

   }
   else{
    return new TableCell(
     
           child: new ScaleTransition(
              scale: animation,
               child: new Center(
           child:    new Container(
           // height: 35.0,
          //   width: 35.0,
           
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
                          
    )]),))));}
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