import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/user_item.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/components/responsive_grid_view.dart';


// enum Status { Neutral, Active }

class ScoreScreen extends StatefulWidget {
  final String gameName;
  final GameDisplay gameDisplay;
  final User myUser;
  final User otherUser;
  final int myScore;
  final int otherScore;
  final List<Widget> otherscore;

  ScoreScreen(
      {Key key,
      this.gameName,
      this.gameDisplay,
      this.myUser,
      this.otherUser,
      this.myScore,
      this.otherScore})
      : super(key: key);

  @override
  _ScoreScreenState createState() => new _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  // AnimationController _buttonController,_textController,_userController,_characterController;

  Animation<double> _buttonAnimation,
      _characterAnimation,
      _userAnimation,
      _textAnimation;

  String gameName;
  GameDisplay gameDisplay;
  User myUser;
  User otherUser;
  int myScore;
  int otherScore;
  List<Widget> otherscore;
  List<String> stars = [];
  // List<Status> _statuses = [];
  var keys = 0;

  @override
  void initState() {
    // TODO: implement initState

    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // _buttonController = new AnimationController(
    //     duration: const Duration(milliseconds: 500), vsync: this);
    // _textController = new AnimationController(
    //     duration: const Duration(milliseconds: 500), vsync: this);
    // _userController = new AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    // _characterController = new AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _buttonAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    _characterAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    _buttonAnimation = new Tween(begin: 0.0, end: 0.0).animate(
        new CurvedAnimation(
            parent: controller,
            curve: new Interval(0.100, 0.400, curve: Curves.elasticOut)));
    _textAnimation = new Tween(begin: 0.0, end: 0.0).animate(
        new CurvedAnimation(
            parent: controller,
            curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));
    // _userAnimation = new Tween(begin: 0.0, end: 0.0).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.5, curve: Curves.easeIn) ));
    // _characterAnimation = new Tween(begin: 0.0, end: 0.0).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.5, curve: Curves.easeIn) ));

    gameName = widget.gameName;
    gameDisplay = widget.gameDisplay;
    myScore = widget.myScore;
    myUser = widget.myUser;
    otherScore = widget.otherScore;
    otherscore = widget.otherscore;
    otherUser = widget.otherUser;

    for (var i = 0; i < 4; i++) {
      myScore > (10*i) ? stars.add("true") : stars.add("false");      
    }

    
    // _statuses = [ Status.Neutral, Status.Neutral, Status.Neutral, Status.Neutral];

    super.initState();
    controller.forward();
  }

  void _Animatebutton() {}
  void _AnimateUser() {}
  void _AnimateText() {}
  void _AnimateCharacter() {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    // _buttonController.dispose();
    // _characterController.dispose();
    // _userController.dispose();
    // _textController.dispose();
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        keys: keys++,
        onPress: () {

        }
        );
  }
  


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Size media = MediaQuery.of(context).size;
    double ht = media.height;
    double wd = media.width;
    int j=0;
    int k = 0;

    final _colors = SingleGame.gameColors[widget.gameName];
    final color = _colors != null ? _colors[0] : Colors.amber;
    
    print(
        "gmaeName: $gameName...gameDisplay: $gameDisplay...myUser: $myUser...otherUser: $otherUser...myScore:$myScore...otherScore: $otherScore...otherscore: $otherscore");
    List<Widget> scores = [
      new Expanded(
          flex: 1,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new UserItem(user: myUser),
                new Text('$myScore')
              ]))
    ];
    if (otherUser != null) {
      scores.add(new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new UserItem(user: otherUser),
            new Text('$otherScore')
          ]));
    }

    return new LayoutBuilder(builder: (context, constraints) {
    final hPadding = pow(constraints.maxWidth / 150.0, 2);
    final vPadding = pow(constraints.maxHeight / 150.0, 2);

    double maxWidth = (constraints.maxWidth - hPadding * 2) / 2;
    double maxHeight = (constraints.maxHeight - vPadding * 2) / 3;

    final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

    return new Scaffold(
        backgroundColor: color,
        body: new SafeArea(
            child: new Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new ScaleTransition(
              scale: _characterAnimation,
              child: new Container(
                height: ht > wd ? ht * 0.15 : wd * 0.15,
                child: new Image(
                  image: new AssetImage("assets/hoodie/$gameName.png"),
                ),
              ),
            ),

            new Row(
                mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                      flex: 1,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new UserItem(user: myUser),
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 20.0),
                            ),
                            new Text(
                              '$myScore',
                              style: new TextStyle(
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ])),
                   gameDisplay == GameDisplay.myHeadToHead ? new Expanded(
                      flex: 1,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new UserItem(user: myUser),
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 20.0),
                            ),
                            new Text(
                              '$myScore',
                              style: new TextStyle(
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ])) : new Row()
                ],
              ),

            //Stars Being Displayed according to the score
            new ScaleTransition(
              scale: _characterAnimation,
              child: 
            
            new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Row(
                      mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.start : MainAxisAlignment.center,
                          crossAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                          children: <Widget>[
                          // new Icon(Icons.star, size: ht > wd ? ht * 0.05 : wd * 0.05,),
                          // myScore >= 10 ? new Icon(Icons.star, size: ht > wd ? ht * 0.05 : wd * 0.05,) : new Icon(Icons.star_border, size: ht > wd ? ht * 0.05 : wd * 0.05,),
                          // myScore >= 20 ? new Icon(Icons.star, size: ht > wd ? ht * 0.05 : wd * 0.05,) : new Icon(Icons.star_border, size: ht > wd ? ht * 0.05 : wd * 0.05,),
                          // myScore >= 30 ? new Icon(Icons.star, size: ht > wd ? ht * 0.05 : wd * 0.05,) : new Icon(Icons.star_border, size: ht > wd ? ht * 0.05 : wd * 0.05,),]),

                          new ResponsiveGridView(
                          rows: 1,
                          cols: 4,
                          children: stars
                              .map((e) => new Padding(
                                    padding: EdgeInsets.all(buttonPadding),
                                    child: _buildItem(j++, e),
                                  ))
                              .toList(growable: false),
                          )]),

                          gameDisplay == GameDisplay.myHeadToHead ? new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            
                          // new Icon(Icons.star, size: ht > wd ? ht * 0.05 : wd * 0.05,),
                          // myScore >= 10 ? new Icon(Icons.star, size: ht > wd ? ht * 0.05 : wd * 0.05,) : new Icon(Icons.star_border, size: ht > wd ? ht * 0.05 : wd * 0.05,),
                          // myScore >= 20 ? new Icon(Icons.star, size: ht > wd ? ht * 0.05 : wd * 0.05,) : new Icon(Icons.star_border, size: ht > wd ? ht * 0.05 : wd * 0.05,),
                          // myScore >= 30 ? new Icon(Icons.star, size: ht > wd ? ht * 0.05 : wd * 0.05,) : new Icon(Icons.star_border, size: ht > wd ? ht * 0.05 : wd * 0.05,),]) : new Row(),]),
                          new ResponsiveGridView(
                          rows: 1,
                          cols: 4,
                          children: stars
                              .map((e) => new Padding(
                                    padding: EdgeInsets.all(buttonPadding),
                                    child: _buildItem(k++, e),
                                  ))
                              .toList(growable: false),
                          )]) : new Row(),
                          ]),
                new Row(
                  mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.start : MainAxisAlignment.center,
                      crossAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: <Widget>[
                     new Text( myScore < 10 ? "Poor" : myScore >= 10 && myScore < 20 ? "Good" : myScore >= 20 && myScore < 30 ? "Very Good" : "Excellent", style: new TextStyle(color: Colors.black, fontSize: ht > wd ? ht * 0.05 : wd * 0.05,),)
                  ]),
                  gameDisplay != GameDisplay.single ? new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                    new Text(myScore < 10 ? "Poor" : myScore >= 10 && myScore < 20 ? "Good" : myScore >= 20 && myScore < 30 ? "Very Good" : "Excellent", style: new TextStyle(color: Colors.black, fontSize: ht > wd ? ht * 0.05 : wd * 0.05,),)
                  ]) : new Row(),
                  ]),
                ], 
              ),
            ),
            ),
            

            // Icons which redirect to home, refresh and fast-forward
             new Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 new Container(
                    //  decoration: new BoxDecoration(
                    //    shape: BoxShape.circle,
                    //    border: new Border.all(
                    //        color: Colors.black,
                    //        width: 2.5,
                    //        style: BorderStyle.solid),
                    //    // color: Colors.orange
                    //  ),
                     child: IconButton(
                         icon: new Image.asset("assets/home_button.png"),
                         iconSize: ht > wd ? ht * 0.1 : wd * 0.1,
                         onPressed: () {
                           // Navigator.of(context).pushNamed('/tab');
                           Navigator.pop(context);
                           Navigator.pop(context);
                           Navigator.pop(context);
                         })),
                 
                  new Container(
                    //  decoration: new BoxDecoration(
                    //    shape: BoxShape.circle,
                    //    border: new Border.all(
                    //        color: Colors.black,
                    //        width: 2.5,
                    //        style: BorderStyle.solid),
                    //    // color: Colors.orange
                    //  ),
                     child: IconButton(
                         icon: new Image.asset("assets/forward_button.png"),
                         iconSize: ht > wd ? ht * 0.1 : wd * 0.1,
                         onPressed: () {
                           // Navigator.of(context).pushNamed('/tab'),
                           Navigator.pop(context);
                           Navigator.pop(context);
                         }),
                   ),
               ],
             ),
             new Padding(
               padding: new EdgeInsets.all(5.0),
             )
            ],
        )));
    });
  }
}


class MyButton extends StatefulWidget {
  // Status status;
  
  MyButton(
      {Key key,
      this.text,
      this.keys,
      this.onPress})
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  int keys;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;

    controller = new AnimationController(
        duration: new Duration(milliseconds: 600), vsync: this);
    
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
//        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });

      // _displayText == "true" ? widget.status = Status.Active : Status.Neutral;
    
    controller.forward();
    // _myAnim();
  }

  // void _myAnim() {
  //   animation.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       controller.reverse();
  //     } else if (status == AnimationStatus.dismissed) {
  //       controller.forward();
  //     }
  //   });
  //   controller.forward();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double ht = media.height;
    double wd = media.width;
    widget.keys++;
    print("_MyButtonState.build");
    return new Shake(
      animation: animation,
      child: new GestureDetector(
    
    // child: new UnitButton(
    //   onPress: () => widget.onPress(),
    //   text: _displayText,
    //   unitMode: widget.unitMode,
     child: new Container(
       
     child: new FlatButton(
         onPressed: () => widget.onPress(),
         color: Colors.transparent,
         
         child: new Icon(
        _displayText == "true" ? Icons.star : Icons.star_border,
        key: new Key("${widget.keys}"),
        size: ht > wd ? ht * 0.05 : wd * 0.05,
        color: Colors.black,
         )
         
    ),)
    ) );
  }
}
