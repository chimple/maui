import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';

class PictureSentence extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  PictureSentence(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PictureSentenceState();
}

class _PictureSentenceState extends State<PictureSentence> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      children: <Widget>[
        new Container(
          child: new Text(
            "Which is the biggest (A)___________ in the (B)__________?",
            key: new Key("fruit"),
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                letterSpacing: 5.0,
                color: Colors.black),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.all(64.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Stack(

                  // alignment: const Alignment(0.6, 0.6),

                  children: [
                    new Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new AssetImage('assets/mountain.jpg')))),
                    new Container(
                      decoration: new BoxDecoration(
                        color: Colors.black45,
                      ),
                      child: new Text(
                        'A',
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
              new Stack(

                  // alignment: const Alignment(0.6, 0.6),

                  children: [
                    new Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new AssetImage('assets/Earth.jpg')))),
                    new Container(
                      decoration: new BoxDecoration(
                        color: Colors.black45,
                      ),
                      child: new Text(
                        'B',
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
        new ResponsiveGridView(
          cols: 2,
          rows: 4,
          maxAspectRatio: 4.0,
          children: <Widget>[
            new RaisedButton(
                onPressed: () => null,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text("Mountain",
                    style: new TextStyle(color: Colors.white, fontSize: 32.0))),
            new RaisedButton(
                onPressed: () => null,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text("City",
                    style: new TextStyle(color: Colors.white, fontSize: 32.0))),
            new RaisedButton(
                onPressed: () => null,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text("World",
                    style: new TextStyle(color: Colors.white, fontSize: 32.0))),
            new RaisedButton(
                onPressed: () => null,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text("Country",
                    style: new TextStyle(color: Colors.white, fontSize: 32.0))),
          ],
        )
      ],
    );
  }
}
