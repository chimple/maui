import 'package:flutter/material.dart';
import 'package:maui/components/user_item.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/db/entity/user.dart';

// class ScoreScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//       child: new Center(
//               child: new Text("Score data", style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
//     ),
//       ),);
//   }
// }

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

  @override
  void initState() {
    // TODO: implement initState

    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // _buttonController = new AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    // _textController = new AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    // _userController = new AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    // _characterController = new AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _buttonAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    _characterAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    // _buttonAnimation = new Tween(begin: 0.0, end: 0.0).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.100, 0.400, curve: Curves.elasticOut) ));
    // _textAnimation = new Tween(begin: 0.0, end: 0.0).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.5, curve: Curves.easeIn) ));
    // _userAnimation = new Tween(begin: 0.0, end: 0.0).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.5, curve: Curves.easeIn) ));
    // _characterAnimation = new Tween(begin: 0.0, end: 0.0).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.5, curve: Curves.easeIn) ));

    gameName = widget.gameName;
    gameDisplay = widget.gameDisplay;
    myScore = widget.myScore;
    myUser = widget.myUser;
    otherScore = widget.otherScore;
    otherscore = widget.otherscore;
    otherUser = widget.otherUser;

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

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Size media = MediaQuery.of(context).size;
    print(
        "gmaeName: $gameName...gameDisplay: $gameDisplay...myUser: $myUser...otherUser: $otherUser...myScore:$myScore...otherScore: $otherScore...otherscore: $otherscore");
    // List<Widget> scores = [
    //   new Expanded(
    //       flex: 1,
    //       child: new Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             new UserItem(user: myUser),
    //             new Text('$myScore')
    //           ]))
    // ];
    // if (otherUser != null) {
    //   scores.add(new Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         new UserItem(user: otherUser),
    //         new Text('$otherScore')
    //       ]));
    // }
    return new Scaffold(
        backgroundColor: themeData.primaryColor,
        // backgroundColor: Colors.black,
        body: new SafeArea(
          child: new Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Flexible(
              flex: 1,
              child: new ScaleTransition(
                scale: _characterAnimation,
                child: new Container(
                  child: new Image(
                    image: new AssetImage("assets/hoodie/$gameName.png"),
                  ),
                ),
              ),
            ),
            
            //Stars Being Displayed according to the score
            new Flexible(
              flex: 1,
              child: 
            myScore <= 10 ? new Container(
                child: new Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.star),
                      new Icon(Icons.star_border),
                      new Icon(Icons.star_border),
                      new Icon(Icons.star_border),
                    ]),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text("Poor", style: new TextStyle(color: Colors.black, fontSize: 24.0),)
                          ]
                        )])) : (myScore>10 && myScore<=20) ? new Container(
                      child: new Column(
                      children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Icon(Icons.star),
                          new Icon(Icons.star),
                          new Icon(Icons.star_border),
                          new Icon(Icons.star_border)
                        ]),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text("Good", style: new TextStyle(color: Colors.black, fontSize: 24.0),)
                          ]
                        )])) :  (myScore>20 && myScore<=30) ? new Container(
                          child: new Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  new Icon(Icons.star),
                                  new Icon(Icons.star),
                                  new Icon(Icons.star),
                                  new Icon(Icons.star_border),
                        ]),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text("Very Good", style: new TextStyle(color: Colors.black, fontSize: 24.0),)
                          ]
                        )]))  : new Container(
                          child: new Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  new Icon(Icons.star),
                                  new Icon(Icons.star),
                                  new Icon(Icons.star),
                                  new Icon(Icons.star),
                        ]),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text("Excellent", style: new TextStyle(color: Colors.black, fontSize: 24.0),)
                          ]
                        )
                        ]))),

            //Users Image and score
            
             gameDisplay != GameDisplay.single ? 
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                              padding: new EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            new Text(
                              '$myScore',
                              style: new TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ])),
                  new Expanded(
                      flex: 1,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new UserItem(user: myUser),
                            new Padding(
                              padding: new EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            new Text(
                              '$myScore',
                              style: new TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ]))
                ],
              ) : new Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                              padding: new EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            new Text(
                              '$myScore',
                              style: new TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ]))
                ],
              ),
            
            // Icons which redirect to home, refresh and fast-forward
            new Flexible(
              flex: 1,
            child: 
             new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new ScaleTransition(
                    scale: _buttonAnimation,
                    child: new Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                              color: Colors.black,
                              width: 2.5,
                              style: BorderStyle.solid),
                          // color: Colors.orange
                        ),
                        child: IconButton(
                            iconSize: 100.0,
                            icon: new Icon(Icons.home),
                            onPressed: () {
                              // Navigator.of(context).pushNamed('/tab');
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            })),
                  ),
                  new ScaleTransition(
                    scale: _buttonAnimation,
                    child: gameDisplay == GameDisplay.myHeadToHead
                        ? new Container()
                        : new Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                  color: Colors.black,
                                  width: 2.5,
                                  style: BorderStyle.solid),
                              // color: Colors.orange
                            ),
                            child: IconButton(
                                iconSize: 100.0,
                                icon: new Icon(Icons.refresh),
                                onPressed: () {
                                  // Navigator.of(context).pushNamed('/tab'),
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  }
                            )),
                  ),
                  gameDisplay == GameDisplay.myHeadToHead ? new Container() : new ScaleTransition(
                    scale: _buttonAnimation,
                                      child: new Container(
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.black,
                                width: 2.5,
                                style: BorderStyle.solid
                              ),
                              // color: Colors.orange
                              ),
                          child: IconButton(
                            iconSize: 100.0,
                            icon: new Icon(Icons.refresh),
                            onPressed: (){
                                // Navigator.of(context).pushNamed('/tab'),
                                Navigator.pop(context);
                                }
                          ),
                  )),
                  new ScaleTransition(
                    scale: _buttonAnimation,
                    child: new Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                            color: Colors.black,
                            width: 2.5,
                            style: BorderStyle.solid),
                        // color: Colors.orange
                      ),
                      child: IconButton(
                          iconSize: 100.0,
                          icon: new Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Navigator.of(context).pushNamed('/tab'),
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              ),
            
            // new Expanded(
            //   flex: 1,
            //   child: new Row(
            //    mainAxisSize: MainAxisSize.max,
            //    mainAxisAlignment: MainAxisAlignment.spaceAround,
            //    crossAxisAlignment: CrossAxisAlignment.center,
            //   children: <Widget>[

            //     //First user's score
            //   new Container(
            //     child: new Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: scores),
            //   ),

            //   //Stars Being Displayed according to the score
            //   myScore <= 10 ? new Container(
            //     child: new Column(
            //     children: <Widget>[
            //       new Row(
            //         children: <Widget>[
            //           new Icon(Icons.star),
            //           new Icon(Icons.star_border),
            //           new Icon(Icons.star_border),
            //           new Icon(Icons.star_border),
            //         ])])) : (myScore>10 && myScore<=20) ? new Container(
            //           child: new Column(
            //           children: <Widget>[
            //           new Row(
            //             children: <Widget>[
            //               new Icon(Icons.star),
            //               new Icon(Icons.star),
            //               new Icon(Icons.star_border),
            //               new Icon(Icons.star_border)
            //             ])])) :  (myScore>20 && myScore<=30) ? new Container(
            //               child: new Column(
            //               children: <Widget>[
            //                 new Row(
            //                   children: <Widget>[
            //                       new Icon(Icons.star),
            //                       new Icon(Icons.star),
            //                       new Icon(Icons.star),
            //                       new Icon(Icons.star_border),
            //             ])]))  : new Container(
            //               child: new Column(
            //               children: <Widget>[
            //                 new Row(
            //                   children: <Widget>[
            //                       new Icon(Icons.star),
            //                       new Icon(Icons.star),
            //                       new Icon(Icons.star),
            //                       new Icon(Icons.star),
            //             ])])),

            //   //OtherUser's Score
            //   otherUser != null ? new Column(
            //     mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: otherscore) : new Column(),

            //   ],
            // ),
            // ),

            // new Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: <Widget>[
            //     new Container(
            //       decoration: new BoxDecoration(
            //         shape: BoxShape.circle,
            //         border: new Border.all(
            //           color: Colors.white,
            //           width: 2.5,
            //         ),
            //         color: Colors.white
            //       ),
            //       child: IconButton(
            //       icon: new Icon(Icons.home),
            //       onPressed: () => Navigator.of(context).pushNamed('/tab'),
            //     )
            //     ),
            //     new Container(
            //       decoration: new BoxDecoration(
            //         shape: BoxShape.circle,
            //         border: new Border.all(
            //           color: Colors.white,
            //           width: 2.5,
            //         ),
            //         color: Colors.white
            //       ),
            //       child: IconButton(
            //       icon: new Icon(Icons.fast_forward),
            //       onPressed: () => Navigator.of(context).pushNamed('/tab'),
            //     ),
            //     ),

            //     new Container(
            //       decoration: new BoxDecoration(
            //         shape: BoxShape.circle,
            //         border: new Border.all(
            //           color: Colors.white,
            //           width: 2.5,
            //         ),
            //         color: Colors.white
            //       ),
            //       child: IconButton(
            //       icon: new Icon(Icons.refresh),
            //       onPressed: () => Navigator.of(context).pushNamed('/tab'),
            //     ),
            //     ),
            )],
        )));
  }
}

// class ScoreScreen extends StatelessWidget {
//   // final String gameName;
//   // final GameDisplay gameDisplay;
//   // final User myUser;
//   // final User otherUser;
//   // final int myScore;
//   // final int otherScore;
//   // final List<Widget> otherscore;

//   // ScoreScreen(
//   //     {Key key,
//   //     this.gameName,
//   //     this.gameDisplay,
//   //     this.myUser,
//   //     this.otherUser,
//   //     this.myScore,
//   //     this.otherScore})
//   //     : super(key: key);

//   // @override
//   // Widget build(BuildContext context) {
//   //   ThemeData themeData = Theme.of(context);
//   //   Size media = MediaQuery.of(context).size;
//   //   print(
//   //       "gmaeName: $gameName...gameDisplay: $gameDisplay...myUser: $myUser...otherUser: $otherUser...myScore:$myScore...otherScore: $otherScore...otherscore: $otherscore");
//   //   // List<Widget> scores = [
//   //   //   new Expanded(
//   //   //       flex: 1,
//   //   //       child: new Column(
//   //   //           mainAxisAlignment: MainAxisAlignment.start,
//   //   //           crossAxisAlignment: CrossAxisAlignment.center,
//   //   //           children: <Widget>[
//   //   //             new UserItem(user: myUser),
//   //   //             new Text('$myScore')
//   //   //           ]))
//   //   // ];
//   //   // if (otherUser != null) {
//   //   //   scores.add(new Column(
//   //   //       mainAxisAlignment: MainAxisAlignment.end,
//   //   //       crossAxisAlignment: CrossAxisAlignment.center,
//   //   //       children: <Widget>[
//   //   //         new UserItem(user: otherUser),
//   //   //         new Text('$otherScore')
//   //   //       ]));
//   //   // }
//   //   return new Scaffold(
//   //       backgroundColor: themeData.primaryColor,
//   //       // backgroundColor: Colors.black,
//   //       body: new Flex(
//   //         direction: Axis.vertical,
//   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: <Widget>[
//   //           new Expanded(
//   //             flex: 1,
//   //             child: new Image(
//   //               image: new AssetImage("assets/hoodie/$gameName.png"),
//   //             ),
//   //           ),
//   //           new Expanded(
//   //             flex: 1,
//   //             child: gameDisplay != GameDisplay.single ?

//   //             new Row(
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               crossAxisAlignment: CrossAxisAlignment.center,
//   //               children: <Widget>[
//   //                 new Expanded(
//   //                     flex: 1,
//   //                     child: new Column(
//   //                         mainAxisAlignment: MainAxisAlignment.center,
//   //                         crossAxisAlignment: CrossAxisAlignment.center,
//   //                         children: <Widget>[
//   //                           new UserItem(user: myUser),
//   //                           new Padding(
//   //                             padding: new EdgeInsets.symmetric(vertical: 20.0),
//   //                           ),
//   //                           new Text(
//   //                             '$myScore',
//   //                             style: new TextStyle(
//   //                                 fontSize: 50.0,
//   //                                 fontWeight: FontWeight.bold,
//   //                                 color: Colors.white),
//   //                           )
//   //                         ])),
//   //                 new Expanded(
//   //                     flex: 1,
//   //                     child: new Column(
//   //                         mainAxisAlignment: MainAxisAlignment.center,
//   //                         crossAxisAlignment: CrossAxisAlignment.center,
//   //                         children: <Widget>[
//   //                           new UserItem(user: myUser),
//   //                           new Padding(
//   //                             padding: new EdgeInsets.symmetric(vertical: 20.0),
//   //                           ),
//   //                           new Text(
//   //                             '$myScore',
//   //                             style: new TextStyle(
//   //                                 fontSize: 50.0,
//   //                                 fontWeight: FontWeight.bold,
//   //                                 color: Colors.white),
//   //                           )
//   //                         ]))
//   //               ],
//   //             )
//   //             :
//   //             new Row(
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               crossAxisAlignment: CrossAxisAlignment.center,
//   //               children: <Widget>[
//   //                 new Expanded(
//   //                     flex: 1,
//   //                     child: new Column(
//   //                         mainAxisAlignment: MainAxisAlignment.center,
//   //                         crossAxisAlignment: CrossAxisAlignment.center,
//   //                         children: <Widget>[
//   //                           new UserItem(user: myUser),
//   //                           new Padding(
//   //                             padding: new EdgeInsets.symmetric(vertical: 20.0),
//   //                           ),
//   //                           new Text(
//   //                             '$myScore',
//   //                             style: new TextStyle(
//   //                                 fontSize: 50.0,
//   //                                 fontWeight: FontWeight.bold,
//   //                                 color: Colors.white),
//   //                           )
//   //                         ]))
//   //               ],
//   //             )
//   //           ),
//   //           new Expanded(
//   //             flex: 1,
//   //             child: new Row(
//   //               crossAxisAlignment: CrossAxisAlignment.center,
//   //               mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //               children: <Widget>[
//   //                 new Container(
//   //                       decoration: new BoxDecoration(
//   //                           shape: BoxShape.circle,
//   //                           border: new Border.all(
//   //                             color: Colors.black,
//   //                             width: 2.5,
//   //                             style: BorderStyle.solid
//   //                           ),
//   //                           // color: Colors.orange
//   //                           ),
//   //                       child: IconButton(
//   //                         iconSize: 100.0,
//   //                         icon: new Icon(Icons.home),
//   //                         onPressed: () {
//   //                             // Navigator.of(context).pushNamed('/tab');
//   //                             Navigator.pop(context);
//   //                             Navigator.pop(context);
//   //                             Navigator.pop(context);
//   //                             }
//   //                       )),
//   //                 new Container(
//   //                     decoration: new BoxDecoration(
//   //                         shape: BoxShape.circle,
//   //                         border: new Border.all(
//   //                           color: Colors.black,
//   //                           width: 2.5,
//   //                           style: BorderStyle.solid
//   //                         ),
//   //                         // color: Colors.orange
//   //                         ),
//   //                     child: IconButton(
//   //                       iconSize: 100.0,
//   //                       icon: new Icon(Icons.refresh),
//   //                       onPressed: (){
//   //                           // Navigator.of(context).pushNamed('/tab'),
//   //                           Navigator.pop(context);
//   //                           }
//   //                     ),
//   //                   ),
//   //                 new Container(
//   //                     decoration: new BoxDecoration(
//   //                         shape: BoxShape.circle,
//   //                         border: new Border.all(
//   //                           color: Colors.black,
//   //                           width: 2.5,
//   //                           style: BorderStyle.solid
//   //                         ),
//   //                         // color: Colors.orange
//   //                         ),
//   //                     child: IconButton(
//   //                       iconSize: 100.0,
//   //                       icon: new Icon(Icons.arrow_forward),
//   //                       onPressed: (){
//   //                           // Navigator.of(context).pushNamed('/tab'),
//   //                           Navigator.pop(context);
//   //                           Navigator.pop(context);
//   //                           }
//   //                     ),
//   //                   ),
//   //               ],
//   //             ),
//   //           )
//   //           // new Expanded(
//   //           //   flex: 1,
//   //           //   child: new Row(
//   //           //    mainAxisSize: MainAxisSize.max,
//   //           //    mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //           //    crossAxisAlignment: CrossAxisAlignment.center,
//   //           //   children: <Widget>[

//   //           //     //First user's score
//   //           //   new Container(
//   //           //     child: new Column(
//   //           //     mainAxisAlignment: MainAxisAlignment.start,
//   //           //     crossAxisAlignment: CrossAxisAlignment.center,
//   //           //     children: scores),
//   //           //   ),

//   //           //   //Stars Being Displayed according to the score
//   //           //   myScore <= 10 ? new Container(
//   //           //     child: new Column(
//   //           //     children: <Widget>[
//   //           //       new Row(
//   //           //         children: <Widget>[
//   //           //           new Icon(Icons.star),
//   //           //           new Icon(Icons.star_border),
//   //           //           new Icon(Icons.star_border),
//   //           //           new Icon(Icons.star_border),
//   //           //         ])])) : (myScore>10 && myScore<=20) ? new Container(
//   //           //           child: new Column(
//   //           //           children: <Widget>[
//   //           //           new Row(
//   //           //             children: <Widget>[
//   //           //               new Icon(Icons.star),
//   //           //               new Icon(Icons.star),
//   //           //               new Icon(Icons.star_border),
//   //           //               new Icon(Icons.star_border)
//   //           //             ])])) :  (myScore>20 && myScore<=30) ? new Container(
//   //           //               child: new Column(
//   //           //               children: <Widget>[
//   //           //                 new Row(
//   //           //                   children: <Widget>[
//   //           //                       new Icon(Icons.star),
//   //           //                       new Icon(Icons.star),
//   //           //                       new Icon(Icons.star),
//   //           //                       new Icon(Icons.star_border),
//   //           //             ])]))  : new Container(
//   //           //               child: new Column(
//   //           //               children: <Widget>[
//   //           //                 new Row(
//   //           //                   children: <Widget>[
//   //           //                       new Icon(Icons.star),
//   //           //                       new Icon(Icons.star),
//   //           //                       new Icon(Icons.star),
//   //           //                       new Icon(Icons.star),
//   //           //             ])])),

//   //           //   //OtherUser's Score
//   //           //   otherUser != null ? new Column(
//   //           //     mainAxisSize: MainAxisSize.max,
//   //           //     mainAxisAlignment: MainAxisAlignment.end,
//   //           //     crossAxisAlignment: CrossAxisAlignment.center,
//   //           //     children: otherscore) : new Column(),

//   //           //   ],
//   //           // ),
//   //           // ),

//   //           // new Row(
//   //           //   mainAxisSize: MainAxisSize.max,
//   //           //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //           //   crossAxisAlignment: CrossAxisAlignment.center,
//   //           //   children: <Widget>[
//   //           //     new Container(
//   //           //       decoration: new BoxDecoration(
//   //           //         shape: BoxShape.circle,
//   //           //         border: new Border.all(
//   //           //           color: Colors.white,
//   //           //           width: 2.5,
//   //           //         ),
//   //           //         color: Colors.white
//   //           //       ),
//   //           //       child: IconButton(
//   //           //       icon: new Icon(Icons.home),
//   //           //       onPressed: () => Navigator.of(context).pushNamed('/tab'),
//   //           //     )
//   //           //     ),
//   //           //     new Container(
//   //           //       decoration: new BoxDecoration(
//   //           //         shape: BoxShape.circle,
//   //           //         border: new Border.all(
//   //           //           color: Colors.white,
//   //           //           width: 2.5,
//   //           //         ),
//   //           //         color: Colors.white
//   //           //       ),
//   //           //       child: IconButton(
//   //           //       icon: new Icon(Icons.fast_forward),
//   //           //       onPressed: () => Navigator.of(context).pushNamed('/tab'),
//   //           //     ),
//   //           //     ),

//   //           //     new Container(
//   //           //       decoration: new BoxDecoration(
//   //           //         shape: BoxShape.circle,
//   //           //         border: new Border.all(
//   //           //           color: Colors.white,
//   //           //           width: 2.5,
//   //           //         ),
//   //           //         color: Colors.white
//   //           //       ),
//   //           //       child: IconButton(
//   //           //       icon: new Icon(Icons.refresh),
//   //           //       onPressed: () => Navigator.of(context).pushNamed('/tab'),
//   //           //     ),
//   //           //     ),
//   //         ],
//   //       ));
//   // }
// }
