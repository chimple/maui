import 'dart:async';

import 'package:flutter/material.dart';

class Casino extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Casino({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CasinoState();
}

class _CasinoState extends State<Casino> {
  @override
  Widget build(BuildContext context) {
    Widget eachBUtton =  new Stack(
                    children: cards.map((String card) {
                    return new Container(
               
                    child: new Row( 
                      children:<Widget> [ new Container( 
                       padding: const EdgeInsets.all(8.0),
                      child:new Row(
                       children:<Widget>[
                        
                          new CustomCardItem(card: card),
                        
                         ]
                        ) 
                      )
                     ],
                   )
                 );
               }).toList()
               );
             
    return  new Expanded(
            
            child:new Container(
              color:Colors.blueGrey,
              child: new Column( 
                children:<Widget>[ new Container( 
                  color:Colors.pinkAccent,
                   padding: const EdgeInsets.all(8.0),
                  child:new Text('APPLE',
                              style: new TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent,
                             )
                        )
            ),
            
              new Container(
                 padding: const EdgeInsets.all(8.0),
                 child:new Row (
                          children:[
                            eachBUtton,
                            eachBUtton,
                            eachBUtton,
                            eachBUtton
                          ]
                        )
              ),
             
             ]
            )
           )
         );
  }
}
List cards = ['','','','','',''];

class CustomCardItem extends StatefulWidget {
  final String card;
  CustomCardItem({this.card});
  @override
  CustomCardItemState createState() => new CustomCardItemState(card: card);
}

class CustomCardItemState extends State<CustomCardItem> {
  final String card;
  Key key = new Key('default');
  CustomCardItemState({this.card});
  initState() {
    super.initState();
    key = new Key(card);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    return new Container(
       
      child:new  SafeArea(
       
        child: new Dismissible(
        key: key,
        direction:DismissDirection.vertical,
        
        child: new Container(
          color:Colors.red,
          
          padding: const EdgeInsets.all(8.0),
          height: 100.0,
          child: new Card(
            color:Colors.amber,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new SizedBox(
                  height: 50.0,
                  width:50.0,
                  child: new Stack(
                    children: <Widget>[
                    
                        new Center(
                          child: new Text('A',
                                style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40.0
                              )
                            )
                        ) ,
                      
                    ],
                  ),
                ),
                new Container(
                  
                  child: new Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: new DefaultTextStyle(
                      style: descriptionStyle,
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: new Text(
                              card,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
    );
  }
}

