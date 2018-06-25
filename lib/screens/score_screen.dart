import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:maui/components/user_item.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/db/entity/user.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:audioplayer/audioplayer.dart';


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
  
  List<AnimationController> _controllers = new List<AnimationController>();
  List<Animation<double>> _animations = new List<Animation<double>>();


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
  
  var keys = 0;

  @override
  void initState() {
    // TODO: implement initState

    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    

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

    for (var i = 0; i < 4; i++) {
      final _controller = new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 500));
      _controllers.add(_controller);
      _animations.add(
          new CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
      new Future.delayed(Duration(milliseconds: 2000 + (i) * 300), () {
        _controller.forward();
      });
    }

    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllers.forEach((f) => f.dispose());
    controller.dispose();
    super.dispose();
    
    
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        keys: keys++,
        onPress: () {}
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

    List<Widget> tablestars1 = new List<Widget>();
    List<Widget> tablestars2 = new List<Widget>();
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
    
    List <Widget> starsMap1 =  stars
                              .map((e) => _buildItem(j++, e),)
                              .toList(growable: false);


    List <Widget> starsMap2 =  stars
                              .map((e) => _buildItem(k++, e),)
                              .toList(growable: false);
    for(var i=0; i < 4; i++){
    tablestars1.add(new ScaleTransition(
                           scale: _animations[i],
                           child: starsMap1[i]));}                       

    for(var l=0; l < 4; l++){
    tablestars2.add(new ScaleTransition(
                           scale: _animations[l],
                           child: starsMap2[l]));}  

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
                height: ht > wd ? ht * 0.15 : wd * 0.13,
                child: new Image(
                  image: new AssetImage("assets/hoodie/$gameName.png"),
                ),
              ),
            ),

            new Row(
              mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: ht > wd ? ht * 0.19 : wd * 0.15,
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new LimitedBox(
                          maxHeight: ht * 0.13,
                          child: new UserItem(user: myUser),),
                        // new Padding(
                        //   padding: new EdgeInsets.symmetric(vertical: ht > wd ? ht * 0.01 : wd * 0.01),
                        // ),
                        new Text(
                          '$myScore',
                          style: new TextStyle(
                              fontSize: ht > wd ? ht * 0.05 : wd * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      ])),
                 gameDisplay == GameDisplay.myHeadToHead ? new Container(
                    height: ht > wd ? ht * 0.19 : wd * 0.15,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new LimitedBox(
                            maxHeight: ht * 0.13,
                            child: new UserItem(user: myUser),),
                          // new Padding(
                          //   padding: new EdgeInsets.symmetric(vertical: ht > wd ? ht * 0.01 : wd * 0.01),
                          // ),
                          new Text(
                            '$myScore',
                            style: new TextStyle(
                                fontSize: ht > wd ? ht * 0.05 : wd * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ])) : new Row()
              ],
            ),

            //Stars Being Displayed according to the score
            new ScaleTransition(
              scale: _characterAnimation,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new  Row(
                    mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.center : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tablestars1),

                        new Padding(
                          padding: new EdgeInsets.all(10.0),
                        ),
                        
                        gameDisplay == GameDisplay.myHeadToHead ? new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: tablestars2) : new Row(),
                        ]),
                new Row(
                  mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? MainAxisAlignment.start : MainAxisAlignment.center,
                      crossAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: <Widget>[
                     new Text( myScore < 10 ? "Poor" : myScore >= 10 && myScore < 20 ? "Good" : myScore >= 20 && myScore < 30 ? "Very Good" : "Excellent", style: new TextStyle(color: Colors.black, fontSize: ht > wd ? ht * 0.05 : wd * 0.04,),)
                  ]),
                  gameDisplay == GameDisplay.myHeadToHead || gameDisplay == GameDisplay.networkTurnByTurn || gameDisplay == GameDisplay.localTurnByTurn ? new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                    new Text(myScore < 10 ? "Poor" : myScore >= 10 && myScore < 20 ? "Good" : myScore >= 20 && myScore < 30 ? "Very Good" : "Excellent", style: new TextStyle(color: Colors.black, fontSize: ht > wd ? ht * 0.05 : wd * 0.05,),)
                  ]) : new Row(),
                  ]),
                ], 
              ),
            ),
            

            // Icons which redirect to home, refresh and fast-forward
             new Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 new Container(
                   
                     child: IconButton(
                         icon: new Image.asset("assets/home_button.png"),
                         iconSize: ht > wd ? ht * 0.1 : wd * 0.1,
                         onPressed: () {
                           _animations[3].addStatusListener((status) {
                             if (status == AnimationStatus.completed) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                             }
                           });
                           // Navigator.of(context).pushNamed('/tab');                           
                         })),
                 
                  new Container(                    
                     child: IconButton(
                         icon: new Image.asset("assets/forward_button.png"),
                         iconSize: ht > wd ? ht * 0.1 : wd * 0.1,
                         onPressed: () {
                            _animations[3].addStatusListener((status) {
                             if (status == AnimationStatus.completed) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                             }
                           });
                           // Navigator.of(context).pushNamed('/tab'),
                           
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
  // AudioPlayer _audioPlayer;
  // bool _isPlaying = false;
  // Directory documentsDirectory;
  


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

      // _initAudioPlayer();
  }

  // void _initAudioPlayer() {
  //   _audioPlayer = new AudioPlayer();
  //   _audioPlayer.setCompletionHandler(() {
  //     _isPlaying = true;
  //   });
  //   _audioPlayer.setErrorHandler((msg) {
  //     _isPlaying = true;
  //   });
  // }

  // void initAudioPlayer() async {
  //   audioPlayer = new AudioPlayer();
  //   documentsDirectory = await getApplicationDocumentsDirectory();
  //   audioPlayer.play(join(documentsDirectory.path, 'star_music.mp3'), isLocal: true);
  // }

  //   void _play() async {

  //  if (!_isPlaying) {
  //    Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //    final result = await _audioPlayer
  //        .play(join(documentsDirectory.path, 'apple.ogg'), isLocal: true);
  //    if (result == 1) {
  //      _isPlaying = true;
  //    }
  //  }
  // }

   @override
    void didUpdateWidget(MyButton oldWidget) {
      // TODO: implement didUpdateWidget
      super.didUpdateWidget(oldWidget); 
    }


  @override
  void dispose() {    
    // _isPlaying=false;
    // _audioPlayer.stop();
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
    // print("$documentsDirectory");
    // audioPlayer.play(join(documentsDirectory.path, 'star_music.mp3'), isLocal: true);
    // _play();
    return new Shake(
      animation: animation,
      child: new GestureDetector(
      child: new Container(  
        height: ht > wd ? ht * 0.3 : ht * 0.15,
        width: ht > wd ? wd * 0.22 : wd * 0.09 ,     
      child: new FlatButton(
         onPressed: () => widget.onPress(),
         color: Colors.transparent,         
         child: new IconButton(
        icon: _displayText == "true" ? new Image.asset("assets/star_gained.png") : new Image.asset("assets/star.png"),
        key: new Key("${widget.keys}"),
        iconSize: ht > wd ? ht * 0.1 : wd * 0.05,
        color: Colors.black,
         )         
    ))
    ));
  }
}
