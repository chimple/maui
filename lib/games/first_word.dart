import 'package:flutter/material.dart';
import 'dart:math';
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
    // print('testing cases     ${text.toLowerCase()}');
if(text.toLowerCase()==randomWord){
  _dispText1='CORRECT';
}
else {
  _dispText1='WRONG';
}
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
                child: new Text(_category[0],style: new TextStyle(fontSize: 24.0),),
              )),
              new Flexible(
                flex:1,
                fit:FlexFit.tight,
                child:new Container(
                  height: 40.0,
                color: Colors.brown[50],
                child: new Text(randomWord[0],style: new TextStyle(fontSize: 24.0)),
              ))
            ],
          )),
          new Container(child: new Text(_dispText.toUpperCase(),style:new TextStyle(fontSize: 20.0,color: Colors.red)),),
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
                  onChanged: (text){setState((){ _dispText=text;});},
                  onSubmitted: (text){submit(text);},
                ),
              )),
              new Flexible(
                flex:1,
                fit:FlexFit.tight,
                child:new Container(
             
             //   width: 100.0,
                height: 40.0,
                color: Colors.brown[50],
                child: new Text(_dispText1,style: new TextStyle(fontSize: 18.0,color: Colors.blue)),
              ))
            ],
          )),
     
        ]);
     
  }
}

