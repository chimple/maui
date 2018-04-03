import 'package:flutter/material.dart';

class Crossword extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Crossword({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new CrosswordState();
}

class CrosswordState extends State<Crossword> {
  var sum=0;
  var pressedtext='';
  var pressedindex=0;
  var flag1=0;
  var correct=0;
  
  List<String> _allLetters = [
    'C','','','','',
    'A','','','','',
    'T','I','G', 'E','R',
    '','','','','A',
    '','','','','T',
  ];
  static final int _size = 5;
  List<String> _rightwords=new List(_size);
  List<String> _letters=new List();
  List<int> _flag=new List();
  List _sortletters=new List(_size*2); 
  //String text1='';
    @override
  void initState() {
    super.initState();
    _initBoard();
  }
 void _initBoard() {
   _letters=_allLetters;
  
   //print('array $_flag');
    for (var i = 0; i < _allLetters.length; i++) {
     if(_allLetters[i]==''){_letters[i]='1';}
     else{_letters[i]=_allLetters[i];}
    }
    for (var i = 0,j=0,h=0; i < _letters.length; i++){
      if(i==5||i==11||i==12||i==13||i==19){
        _rightwords[j++]=_letters[i];
        _sortletters[h++]=_letters[i];
        _sortletters[h++]=i;
         _letters[i]='';
        }
    }
     _flag.length=_letters.length+_size+1;
    for (var i = 0; i < _flag.length; i++) {
      _flag[i]=0;
      }
  //  print('helo $_sortletters');
  }
  Widget _buildItem(int index, String text,int flag) {
  final TextEditingController t1= new TextEditingController(text: text);
  if(text!='1'){
    return new MyButton(
        index: index,
        text: text,
        color1:1,
        onAccepted: (targettext){
            flag1=0;         
               for (var i = 0; i < _sortletters.length; i++) {
                if(_sortletters[i]==targettext && index==_sortletters[++i]){ 
             //  _rightwords[index-100]='';
               flag1=1; 
               break;
               }} 
              setState(() {
              if (flag1==1) {
              _letters[index]= targettext;
              correct++;
              widget.onScore(1);
               widget.onProgress(correct/_size);
               if(correct==_size){widget.onEnd();}
               }
             else if(flag1==0){
                _flag[index]=1 ;
               } 
            });
            }, 
            flag:flag,
            arr:_flag
      );//mybutton     
 }
  else {
   return new MyButton(
        index:index,
        text: '',
        color1: 0,
        flag:flag,
        arr:_flag,
        onAccepted: (text) { },
   );
  }
}
@override
  Widget build(BuildContext context) {
  //  print("MyTableState.build");
   List<TableRow> rows = new List<TableRow>();
   List<TableRow> rows1 = new List<TableRow>();
    var j = 0,h=0;
    for (var i = 0; i < 5; i++) {
      List<Widget> cells = _letters
          .skip(i*_size)
          .take(_size)
          .map((e) => _buildItem(j++, e,_flag[h++]))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    j=100;
      for (var i = 0; i < 1; i++) {
      List<Widget> cells = _rightwords
          .skip(i*1)
          .take(_size)
          .map((e) => _buildItem(j++,e,_flag[h++]))
          .toList();
      rows1.add(new TableRow(children: cells));
    }
    return new Center(
      child:new Container(
      color: Colors.purple[300],
      child: new Column(
        children: <Widget>[
          new Table(children: rows), 
          new Padding(padding: new EdgeInsets.all(20.0)),
          new Text("choose words",style: new TextStyle(color: Colors.black,
          fontSize: 50.0,fontFamily:"Roboto")),
          new Padding(padding: new EdgeInsets.all(20.0)),
          new Table(children: rows1)
        ],
       
      ))
    );
  }
}
class MyButton extends StatefulWidget {
  MyButton({ this.index, this.text,this.color1,this.flag,this.onAccepted,this.arr});
  var index;
  final int color1;
  final int flag;
  final String text;
   List arr;
  final DragTargetAccept onAccepted;
 // final String text1;
   
  @override
  _MyButtonState createState() => new _MyButtonState();
}
class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;
  
  initState() {
    super.initState();
    _displayText = widget.text;
    controller =new AnimationController(duration: new Duration(milliseconds: 80), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.decelerate)
      ..addStatusListener((state) {
     //  print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
         controller.forward();
       }
      });
    controller.forward();
  }
 @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ( widget.flag==1) {
     // print("old ${oldWidget.text} new ${widget.text}");
      controller.reverse();
  
    }
  //  print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }
 void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }
 @override
  Widget build(BuildContext context) { 
    for (var i = 0; i < widget.arr.length; i++) {
      widget.arr[i]=0;
      }
    if(widget.index<100 && widget.color1!=0){
    //  print('nik $_displayText');
    
     return new TableCell(
        child: new Padding(
            padding:const EdgeInsets.all(8.0),
            child:new ScaleTransition(
                scale: animation,
                child:new Container(
                width: 30.0,
                height: 44.0,
                 decoration: new BoxDecoration(
                  color: widget.color1==1?Colors.yellow[500]:Colors.purple[300],
                  borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                ),
                child: new DragTarget(
                onAccept: (String data) => widget.onAccepted(data),  
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
            return new Container(
                width: 30.0,
                height: 44.0,
               decoration: new BoxDecoration(
                  color: Colors.yellow[500],
                  borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                ),
                child:new Center(
                  child:new Text(widget.text,style:new TextStyle(color:Colors.black,fontSize: 24.0)),
                ),
              );
            },
          ),
              ), ),),);
    }
     else if (widget.index>=100){
       return new TableCell(
        child: new Draggable(
          data: _displayText,
          child:new Padding(
          padding:new EdgeInsets.all(8.0),
          child:new ScaleTransition(
                scale: animation,
          child: new Container(
                width: 30.0,
                height: 44.0,
                 decoration: new BoxDecoration(
                  color: widget.color1==1?Colors.yellow[500]:Colors.purple[300],
                  borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                ),
                child:new Center(
                  child:new Text(_displayText,style:new TextStyle(color:Colors.black ,fontSize: 24.0)),
                ),
              )
            ),
          ),
          feedback: new Container(
              height: 60.0,
              width: 80.0,
           decoration: new BoxDecoration(shape:BoxShape.rectangle,
           borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
           color: Colors.yellow[400]),
           child:new Center(
              child:new Text(_displayText,
                style:new TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 26.0,
                ),),
              ),
            ),
        
        ));
    }
   else{
    return new TableCell(
        child: new Padding(
            padding:const EdgeInsets.all(8.0),
            child:new ScaleTransition(
                scale: animation,
                child: new Container(
                width: 30.0,
                height: 44.0,
                 decoration: new BoxDecoration(
                  color:Colors.purple[300],
                  borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                ),
                child:new Center(
                  child:new Text(_displayText,style:new TextStyle(color:Colors.black ,fontSize: 24.0)),
                ),
              )
            ))); 
}}
}