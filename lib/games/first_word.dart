import 'package:flutter/material.dart';
import 'dart:math';
import 'package:maui/components/responsive_grid_view.dart';
class FirstWord extends StatefulWidget {
 Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
 int gameCategoryId;
 bool isRotated;

  FirstWord({key, this.onScore, this.onProgress, this.onEnd, this.iteration,this.gameCategoryId, this.isRotated=false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>new  FirstWordState();
}
enum Statuses {right,wrong}
class FirstWordState extends State<FirstWord> {
  List<String> _letters=['','','','',''];
 List<bool> _focus;
String _dispText='';
List<String> data=['','','','',''];
List<String> _category=['sports'];
List<String> _catList=['cricket','football','tennis','golf','basketball'];
 var rand =new Random();
         int randNum;
         String randomWord='';
          @override
  void initState() {
    super.initState();
    _focus=[true,false,false,false,false];
    randNum =rand.nextInt(_catList.length-1);
    randomWord=_catList[randNum];
  }
 
   void submit(text){
    // print('testing cases     ${text.toLowerCase()}');
if(text.toLowerCase()==randomWord){
  _dispText='U R CORRECT';
}
else {
  _dispText='U R WRONG';
}
   }
 // FocusNode focusNode = new FocusNode();
Widget _buildItem(int index, String text,bool auto) {
  FocusNode focusNode = new FocusNode();
 
  
    return new MyButton(
      auto: auto,
      index: index,
     focusNode: focusNode,
       key: new ValueKey<int>(index),
        text: text,
      
        onPress: (text) {
          print('coming here  $text   ');
          setState((){
            _focus[index+1]=true;
            _focus[index]=false;
            print('focus array        $_focus');
            _letters[index]=text;});
        }
    );
}


 @override
  Widget build(BuildContext context) {
   
    Size size=MediaQuery.of(context).size;
print('width      ${size.width}');
int j=0;int i=0;
    return new Column(
   /// shrinkWrap: true,
      children: <Widget>[
         new Container(child: new Text('$_dispText',style: new TextStyle(fontSize: 25.0,color: Colors.blue),),),
     new Container(
      padding: new EdgeInsets.all(size.width/10),
    child:
        
          new Row(
            children: <Widget>[

              new Container(
             //   width: 200.0,
              //  height: 40.0,
                color: Colors.brown[300],
                child: new Text(_category[0],style: new TextStyle(fontSize: 24.0),),
              ),
              new Container(

             //   width: 100.0,
              //  height: 40.0,
                color: Colors.brown[50],
                child: new Text(randomWord[0],style: new TextStyle(fontSize: 24.0)),
              )
            ],
          )),
     
    
       new ResponsiveGridView(
          maxAspectRatio: 1.0,
           padding: new EdgeInsets.all(1.0),
          // mainAxisSpacing: 0.0,
          // crossAxisSpacing: 0.0,
           rows: 1,
           cols: 5,
           children: _letters.map((e) => _buildItem(j, e,_focus[j++])).toList(growable: false),
         
       
        
     )]);
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text,this.index, this.onPress,this.status,this.focusNode,this.auto}) : super(key: key);
final FocusNode focusNode;
  final String text;
  final Function onPress;
  final Statuses status;
  final int index;
   bool auto;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller,controller1;
  Animation<double> animation,animation1;
  String _displayText;
  bool tt;

  initState() {
    super.initState();
    tt=widget.auto;
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    print('autofocus     ${widget.auto}');
    // controller = new AnimationController(
    //     duration: new Duration(milliseconds: 10), vsync: this);
    //     controller1 = new AnimationController(
    //     duration: new Duration(milliseconds: 40), vsync: this);
    // animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn);

    // controller.forward();
    //  animation1 = new Tween(begin: -5.0, end: 5.0).animate(controller1);
    // _myAnim();
      controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
//        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
       //   if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
         // }
        }
      });
    controller.forward();
  }

 
  //  void _myAnim() {
  //   animation1.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       controller1.reverse();
  //     } else if (status == AnimationStatus.dismissed) {
  //       controller1.forward();
  //     }
  //   });
  //   controller1.forward();
  // }

   @override
  void didUpdateWidget(MyButton oldWidget) {
   
    super.didUpdateWidget(oldWidget);
     tt=widget.auto;
    // if (oldWidget.text == null && widget.text != null) {
    //   _displayText = widget.text;
    //   controller.forward();
    // } else if (oldWidget.text != widget.text) {
    //   controller.reverse();
    // }
    print("_MyButtonState.didUpdateWidget: ${widget.auto} ${oldWidget.auto}");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return   new Container(
              //  color: Colors.brown[50],
              //  height: 40.0,width: 100.0,
decoration: new BoxDecoration(shape: BoxShape.rectangle,color: Colors.red),
child: new TextField(
 // focusNode:widget.focusNode ,
 // maxLength: 1,
 autofocus:tt,
  onChanged: (text){
    
    widget.onPress(text);
 
   
      
      

  },
  
),



    //             child:  new TextFormField(
    //               focusNode: widget.focusNode,
    //          //  autofocus: true,
    //           // maxLength: 1,
    //               //initialValue: '',                //  maxLength: randomWord.length,
    //               onFieldSubmitted: (text){widget.onPress;  
    // FocusScope.of(context).requestFocus(new FocusNode());},
    //           // onChanged: (text){setState((){_dispText=text;});},
    //             )
                //new Text('correct',style: new TextStyle(fontSize: 24.0)),
              );
  }
}
