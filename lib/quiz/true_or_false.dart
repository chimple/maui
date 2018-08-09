import 'dart:convert';

import 'package:flutter/material.dart';

const Map<String, dynamic> quizMap = {
  'data': [
    {
      'image': 'lion',
      'question': 'Match the following according to the habitat of each animal',
      'bool': 'true'
    },
    {
      'image': 'duck',
      'question':
          'this is my new appffnkabbfbafanfbfabnafbnafbanfa fa afa  asbffnabfnasb  sbfbfbnafba  nbfnbabnafbnafbnabfanfbna',
      'bool': 'false'
    }
  ]
};

class TrueOrFalse extends StatefulWidget {
  final Map<String, dynamic> input;

  const TrueOrFalse({Key key, this.input = quizMap}) : super(key: key);
  @override
  _TrueOrFalseState createState() {
    // TODO: implement createState
    return new _TrueOrFalseState();
  }
}

class _TrueOrFalseState extends State<TrueOrFalse> {
  List<String> TrueorFalse = ["True", "False"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(
        "this is my data from json  ${"assets/${widget.input['data'][1]['image']}.png"}");
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    return new Scaffold(
//      backgroundColor: Colors.green,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Container(
//        margin: const EdgeInsets.all(10.0),
//        alignment: Alignment.topCenter,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Padding(padding: EdgeInsets.all(10.0)),
              new Container(
                color: Colors.brown,
                child: new SingleChildScrollView(
                  child: new Container(
                    decoration: BoxDecoration(
                        border:
                            new Border.all(color: Colors.black, width: 2.0)),
                    height: size.height / 2,
//                  color: Colors.amber,
                    child: new ListView(
//                addRepaintBoundaries: true,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: new Container(
                            color: Colors.blue,
                            child: new Image.asset(
                              "assets/${widget.input['data'][1]['image']}.png",
                              fit: BoxFit.fill,
//                    color: Colors.red,
                            ),
                          ),
                        ),
                        new Container(
                          child: new Text(
                            "${widget.input['data'][1]['question']}",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.all(10.0)),
              Expanded(
                child: Center(
                  child: new Container(
                    color: Colors.yellow,
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: new List.generate(TrueorFalse.length, (i) {
                        return new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new RaisedButton(
                            color: Colors.blueGrey,
                            child: new Text(
                              "${TrueorFalse[i]}",
                              style: new TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: () {
                              print("this is my True");
                            },
                            splashColor: Colors.red,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
//            new Padding(padding: EdgeInsets.all(5.0)),
            ],
          ),
        ),
      ),
    );
  }
}
