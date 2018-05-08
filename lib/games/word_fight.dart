import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:maui/games/single_game.dart';
class WordFight extends StatefulWidget {
 Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
GameConfig gameConfig;
 bool isRotated;

  WordFight({key, this.onScore, this.onProgress, this.onEnd, this.iteration,  this.gameConfig, this.isRotated=false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>new  WordFightState();
}
enum Statuses {right,wrong}
class WordFightState extends State<WordFight> {
    final TextEditingController _textController = new TextEditingController();
  bool loading=true;
  List<String> array = new List();
String _dispText='';
String _dispText1='';
List<String> data=['','','','',''];
List<String> _category=['sports'];
List<String> _catList=['cricket','football','tennis','golf','basketball'];
 var rand =new Random();
         int randNum;
         String randomWord='';
          @override
  void initState() {
    super.initState();
  
    randNum =rand.nextInt(_catList.length-1);
    randomWord=_catList[randNum];
  }
 
   void submit(text){
   
//     // print('testing cases     ${text.toLowerCase()}');
// if(text.toLowerCase()==randomWord){
//   _dispText1='CORRECT';
// }
// else {
//   _dispText1='WRONG';
// }
 
 print('array   ;list   $array');
 _textController.clear();
 setState((){
   array.add(text);
   //loading=false;
 });
   
   }
 
 @override
  Widget build(BuildContext context) {
 
    Size size=MediaQuery.of(context).size;
print('width      ${size.width}');
int j=0;int i=0;
    return 
    new Column(
      children: <Widget>[
       
       
     
     new Container(
      padding: new EdgeInsets.all(size.width/10),
         child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              new  Flexible(
                flex:3,
                fit: FlexFit.tight,child:new Container(
             //   width: 200.0,
               height: 40.0,
                color: Colors.brown[300],
                child: new Text(_category[0],textAlign: TextAlign.center,style: new TextStyle(fontWeight:FontWeight.bold,fontSize: 24.0),),
              )),
              // new Flexible(
              //   flex:1,
              //   fit:FlexFit.tight,
              //   child:new Container(
              //     height: 40.0,
              //   color: Colors.brown[50],
              //   child: new Text(randomWord[0],textAlign: TextAlign.center,style: new TextStyle(fontSize: 24.0)),
              // ))
            ],
          )),
          
        //  new Container(child:new ListView(
        //    shrinkWrap: true,
        //    children:loading?[]: array,)),
       new Container(
          decoration: const BoxDecoration(
    border: const Border(
      top: const BorderSide(width: 3.0, color: Colors.red),
      left: const BorderSide(width: 3.0, color:  Colors.red),
      right: const BorderSide(width: 3.0, color:  Colors.red),
      bottom: const BorderSide(width: 3.0, color:  Colors.red),
    ),
  ),
         height: 90.0,
         width:300.0,
         child:  new ListView(
          shrinkWrap: true,
        children:
        array.map((String string) {
          return new Row(
            children: [
              new Text(string,style: new TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18.0),textAlign: TextAlign.center,)
            ],
          );
        }).toList(),
      )),
            new Container(
      padding: new EdgeInsets.all(size.width/10),
         child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              new  Flexible(
                flex:3,

                fit: FlexFit.tight,child:new Container(
             //   width: 200.0,
               height: 40.0,
                color: Colors.brown[300],
                child:new TextField(
                  controller: _textController,
                  decoration: new InputDecoration(border: InputBorder.none),
                  style: new TextStyle(fontWeight: FontWeight.bold,letterSpacing: 2.0,fontSize: 22.0),
                  textAlign: TextAlign.center,
                  onChanged: (text){setState((){_dispText=text;});},
                  onSubmitted: (text){
                  //  setState((){loading=true;});
                    submit(text);},
                ),
              )),
              new Flexible(
                flex:1,
                fit:FlexFit.tight,
                child:new Container(
             
             //   width: 100.0,
                height: 40.0,
                color: Colors.brown[50],
                child: new Text(_dispText1,textAlign: TextAlign.center,style: new TextStyle(fontSize: 18.0,color: Colors.blue)),
              ))
            ],
          )),
     
        ]);
     
  }
}

