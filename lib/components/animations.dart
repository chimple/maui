import 'package:flutter/material.dart';
import 'package:maui/quack/post_comments.dart';
import 'package:nima/nima_actor.dart';
import 'dart:ui';

class Animations extends StatefulWidget {
  @override
  AnimationsState createState() {
    return new AnimationsState();
  }
}

class AnimationsState extends State<Animations> {
  List<String> emotions = ["happy", "joy", "hello", "sad", "bored"];
  String emotion;
  int count;
  PageController _pageController;
  int _currentPageIndex;

  @override
  void initState() {
    count = 0;
    _pageController = PageController(initialPage: 0);
    _currentPageIndex = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Initial An imation - ${emotions[0]}");
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    return Stack(
      children: <Widget>[
        new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: new Container(
            decoration:
                new BoxDecoration(color: Colors.grey[200].withOpacity(0.1)),
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  onPressed: () {Navigator.of(context).pop();},
                  child: new Icon(Icons.close, size: size.height * 0.05, color: Colors.white)
                ),
              ],
            ),
            Container(
              height: size.height * 0.84,
              child: Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () async => await _pageController.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn),
                      child: new Icon(
                        Icons.keyboard_arrow_left,
                        size: size.height * 0.08,
                        color: count == 0 ? Colors.grey : Colors.white,
                      )),
                  Expanded(
                      child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: emotions.length,
                          itemBuilder: (context, index) => new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                                // height: double.maxFinite,
                                                // width: double.maxFinite,
                                                height: size.height > size.width
                                                    ? size.height * 0.8
                                                    : size.height * 0.85,
                                                width: size.height > size.width
                                                    ? size.width * 0.8
                                                    : size.width * 0.5,
                                                child: new NimaActor(
                                                  "assets/quack",
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.scaleDown,
                                                  animation:
                                                      '${emotions[count]}',
                                                  mixSeconds: 0.2,
                                                )),
                                          ),
                                        ]),
                                  ]),
                          onPageChanged: (index) {
                            print('onPageChanged: $index');
                            print(
                                'OnPageChanged Emotion: ${emotions[0 + index]}');                                
                            setState(() {
                              count = 0 + index;
                            });
                          })),
                  FlatButton(
                      onPressed: () async => await _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn),
                      child: new Icon(
                        Icons.keyboard_arrow_right,
                        size: size.height * 0.08,
                        color: count == emotions.length - 1
                            ? Colors.grey
                            : Colors.white,
                      )),
                ],
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top: 25.0)),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      height: size.height * 0.08,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(12.0),
                        color: Colors.amber,
                      ),
                      child: new FlatButton(
                          child: new Text(
                        'Draw',
                        style: new TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ))),
                  new Container(
                      height: size.height * 0.08,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(12.0),
                        color: Colors.amber,
                      ),
                      child: new FlatButton(
                          child: new Text(
                        'Post',
                        style: new TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )))
                ]),
          ],
        ),
      ],
    );
  }
}
