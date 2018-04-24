import 'package:flutter/material.dart';
import '../components/drawing.dart';
import 'dart:ui' as ui;


class Draw_Challenge extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;

  Draw_Challenge({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.isRotated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new Draw_Challenge_Screen();
}

class Draw_Challenge_Screen extends State<Draw_Challenge> {
  DrawPadController _padController;
  void initState() {
    print({"init State - in drawScreen": "line 22"});
    _padController = new DrawPadController();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    MediaQueryData media = MediaQuery.of(context);
    var assetsImage = new AssetImage('assets/apple.png');

    if(media.size.height > media.size.width){
    return new LayoutBuilder(builder: (context, constraints)
    {
      print({"this is constraints":"potrait"});
        return new Container(
            width: constraints.maxWidth, height: constraints.maxHeight,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Column(children: <Widget>[
                    new Image(image: assetsImage,
                        width: constraints.maxWidth * 0.5,
                        height: constraints.maxHeight * 0.18),
                    new Container(
                        width: constraints.maxWidth, height: constraints.maxHeight * 0.08,
                        child: new Text("APPLE",
                            key: new Key('imgtext'),
                            textAlign: TextAlign.center,
                            style:
                            new TextStyle(
                                fontSize: constraints.maxHeight * 0.05,
                                fontWeight: FontWeight.bold))
                    ),
                    new Container(
                        width: constraints.maxWidth, height: constraints.maxHeight * 0.1,
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new RaisedButton(
                                child: new Text("Send"),
                                color: Colors.blue,
                                onPressed: _onSend,
                              ),
                            ]
                        )
                    ),


                    new FittedBox(
                      fit: BoxFit.fill,
                      child: new Container(
                        width: constraints.maxWidth, height: constraints.maxHeight * 0.5,

                        // otherwise the logo will be tiny
                        child: new MyDrawPage(_padController,
                            key: new GlobalObjectKey('MyDrawPage')),
                        key: new Key('draw_screen'),
                      ),
                    ),

                  ])
                ]
            )
        );
      }
    );
    }
    else {
    print({'landscape mode ....': ""});
      return new LayoutBuilder(builder: (context, constraints)
      {
        print({"this is constraints": constraints});

        return new Padding(
            padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child: new Row(
                children: <Widget>[
                  new Column(
                      children: <Widget>[
                        new Image(image: assetsImage,
                            width: constraints.maxWidth * 0.3,
                            height: constraints.maxHeight * 0.45),
                        new Container(
                            width: constraints.maxWidth * 0.2, height: constraints.maxHeight * 0.1,
                            child: new Text("APPLE",
                                key: new Key('imgtext'),
                                textAlign: TextAlign.center,
                                style:
                                new TextStyle(
                                    fontSize: constraints.maxHeight * 0.08,
                                    fontWeight: FontWeight.bold))
                        ),
                        new Container(
                            width: constraints.maxWidth * 0.2, height: constraints.maxHeight * 0.4,
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  new RaisedButton(
                                    child: new Text("Send"),
                                    color: Colors.blue,
                                    onPressed: _onSend,
                                  )
                                ])
                        )
                      ]
                  ),


                  new Column(
                      children: <Widget>[
                        new FittedBox(
                          fit: BoxFit.fill,
                          child: new Container(
                            width: constraints.maxWidth * 0.7, height: constraints.maxHeight * 0.75,

                            // otherwise the logo will be tiny
                            child: new MyDrawPage(_padController,
                                key: new GlobalObjectKey('MyDrawPage')),
                            key: new Key('draw_screen'),
                          ),
                        ),
                      ]
                  )
                ]
            )
        );
      }
      );
    }
  }

  void _onSend() {
    _padController.send();
  }

}
