import 'package:flutter/material.dart';
import 'package:maui/loca.dart';
import 'package:maui/quack/post_comments.dart';
import 'package:nima/nima_actor.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'dart:ui';

class Animations extends StatefulWidget {
  @override
  AnimationsState createState() {
    return new AnimationsState();
  }
}

class AnimationsState extends State<Animations> {
  List<String> emotions = ["happy", "joy", "hello", "sad", "bored", "welcome with hello"];
  String emotion, _animationName;
  int count;
  PageController _pageController;
  int _currentPageIndex;
  bool paused = false;

  @override
  void initState() {
    count = 0;
    _pageController = PageController(initialPage: 0);
    _currentPageIndex = 0;
    _animationName = emotions[0];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _complete(bool mounted) {
   if (mounted) {
      setState(() {
        paused = true;
        _animationName = null;
      });
   }
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
            Container(
              height: size.height > size.width
                  ? size.height * 0.88
                  : size.height * 0.70,
              width: double.maxFinite - size.width * 0.1,
              child: Stack(
                children: <Widget>[
                  PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: emotions.length,
                      itemBuilder: (context, index) => Container(
                            height: double.maxFinite - size.height * 0.1,
                            width: double.maxFinite - size.height * 0.4,
                            //color: Colors.red,
                            child: new NimaActor(
                              "assets/quack",
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              animation: '${emotions[count]}',
                              mixSeconds: 0.2,
                              paused: paused,
                              completed: (String animationName) {
                                    _complete(mounted);
                                  },
                            ),
                          ),
                      onPageChanged: (index) {
                        print('onPageChanged: $index');
                        print('OnPageChanged Emotion: ${emotions[0 + index]}');
                        setState(() {
                          count = 0 + index;
                          paused = false;
                        });
                      }),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Icon(Icons.arrow_back,
                            size: size.height * 0.05, color: Colors.white)),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FlatButton(
                        onPressed: () async =>
                            await _pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn),
                        child: new Icon(
                          Icons.keyboard_arrow_left,
                          size: size.height * 0.08,
                          color: count == 0 ? Colors.grey : Colors.white,
                        )),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: FlatButton(
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
                  ),
                ],
              ),
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      height: size.height * 0.08,
                      width: size.width * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(12.0),
                        color: Colors.amber,
                      ),
                      child: new FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DrawingWrapper(
                                        activityId: 'lion_roar',
                                        template: null,                                        
                                      )),
                            );
                          },
                          child: new Text(
                            Loca.of(context).draw,
                            style: new TextStyle(
                                fontSize: 40.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))),
                  new Container(
                      height: size.height * 0.08,
                      width: size.width * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(12.0),
                        color: Colors.amber,
                      ),
                      child: new FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => PostComments()),
                            );
                          },
                          child: new Text(
                            Loca.of(context).post,
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
