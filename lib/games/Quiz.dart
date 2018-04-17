import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';

class Quiz extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;


  Quiz({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.gameCategoryId, this.isRotated}) : super(key: key);
  
  @override
  State createState() => new QuizState();
}

class QuizState extends State<Quiz> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
 
 Tuple2<String, bool> _allques;
  String questionText;
  bool tf;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  Animation<double> buttonSqueezeAnimation;

  Animation<double> buttonZoomout;

  AnimationController _loginButtonController;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(()=>_isLoading=true);
    _allques =  await fetchTrueOrFalse(widget.gameCategoryId);
    print("this is my data  $_allques");
    print(_allques.item1);
    questionText = _allques.item1;
    print(_allques.item2);
    tf = _allques.item2;
    setState(()=>_isLoading=false);
    _loginButtonController = new AnimationController(
      duration: new Duration(milliseconds: 3000),
      vsync: this
    );
  }

  void handleAnswer(bool answer) {
    isCorrect = (tf == answer);
    _playAnimation();
    if (isCorrect) {
      _playAnimation();
      widget.onScore(1);
      widget.onProgress(1.0);
      widget.onEnd();
      _initBoard();
    }
    this.setState(() {
      print(4);
      overlayShouldBeVisible = true;
    });
  }


  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    }
    on TickerCanceled{}
  }
  
    @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double ht=media.height;
    double wd = media.width;
    print("Question text here $questionText");
    print("Answer here $tf");

    if(_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }    

    buttonSqueezeAnimation = new Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(new CurvedAnimation(
      parent: _loginButtonController.view,
      curve: new Interval(0.0, 0.250)
    ));

    buttonZoomout = new Tween(
      begin: 500.0,
      end: 1000.0,
    ).animate(
      new CurvedAnimation(
        parent: _loginButtonController.view,
        curve: new Interval(
          0.550, 0.900,
          curve: Curves.bounceOut,
        )
    ));
       

    return new Material(
      color: const Color(0xFF54cc70),
      child: new Stack(
      fit: StackFit.loose,
      children: <Widget>[
        new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
          
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [new QuestionText(questionText)]
            ),

           new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.all(wd * 0.015),
                    ),

                  new AnswerButton(buttonController: _loginButtonController.view, answer: true, onTap: () => handleAnswer(false))/*true button*/, 

                    new Padding(
                      padding: new EdgeInsets.all(wd * 0.015),
                    ),

                  new AnswerButton(buttonController: _loginButtonController.view, answer: false, onTap: () => handleAnswer(false)), /*false button*/

                    new Padding(
                      padding: new EdgeInsets.all(wd * 0.015),
                    ),
                  ]
                ),

                 new Padding(
                      padding: new EdgeInsets.all(ht * 0.015),
                    ),

               new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                      new Padding(
                        padding: new EdgeInsets.all(wd * 0.015),
                      ),

                    new AnswerButton(buttonController: _loginButtonController.view, answer: true, onTap: () => handleAnswer(false)),/*true button*/

                    new Padding(
                      padding: new EdgeInsets.all(wd * 0.015),
                    ),

                    new AnswerButton(buttonController: _loginButtonController.view, answer: false, onTap: () => handleAnswer(false)), /*false button*/ 

                      new Padding(
                        padding: new EdgeInsets.all(wd * 0.015),
                      ),

                    ]
                ),
              ]
            ),
          ],
        ),
        
      ],
    ),
    );
  }
    
}


class QuestionText extends StatefulWidget {

  final String _question;

  QuestionText(this._question);

  @override
  State createState() => new QuestionTextState();
}

class QuestionTextState extends State<QuestionText> with SingleTickerProviderStateMixin {

  Animation<double> _fontSizeAnimation;
  AnimationController _fontSizeAnimationController;

  @override
  void initState() {
    super.initState();
    _fontSizeAnimationController = new AnimationController(duration: new Duration(milliseconds: 500), vsync: this);
    _fontSizeAnimation = new CurvedAnimation(parent: _fontSizeAnimationController, curve: Curves.bounceOut);
    _fontSizeAnimation.addListener(() => this.setState(() {print(2);}));
    _fontSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _fontSizeAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(QuestionText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._question != widget._question) {
      _fontSizeAnimationController.reset();
      _fontSizeAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double ht=media.height;
    double wd = media.width;
    return new Material(
      color: const Color(0xFF54cc70),
      child:  new Container(
        height: ht * 0.22,
        width: wd * 0.6,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(25.0),
              color: const Color(0xFFf8c43c),              
              border: new Border.all(
                  color: const Color(0xFF54cc70),
                  ),
                ),
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ new Text( widget._question,
              style: new TextStyle(color: Colors.white, fontSize: ht>wd? ht*0.06 : wd*0.06, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
                  ),
              ],
              ),
            ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final bool answer;
  final VoidCallback onTap;

  AnswerButton({Key key, this.answer, this.onTap, this.buttonController})
      : buttonSqueezeanimation = new Tween(
          begin: 320.0,
          end: 70.0,
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        buttomZoomOut = new Tween(
          begin: 70.0,
          end: 1000.0,
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.550,
              0.999,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        )
            .animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  final Animation buttomZoomOut;

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: buttomZoomOut.value == 70
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: new InkWell(
          onTap: () {
            _playAnimation();
            onTap();
          },
          child: new Hero(
            tag: "fade",
            child: buttomZoomOut.value <= 300
                ? new Container(
                    width: buttomZoomOut.value == 70
                        ? buttonSqueezeanimation.value
                        : buttomZoomOut.value,
                    height:
                        buttomZoomOut.value == 70 ? 60.0 : buttomZoomOut.value,
                    alignment: FractionalOffset.center,
                    decoration: new BoxDecoration(
                      color: const Color.fromRGBO(247, 64, 106, 1.0),
                      borderRadius: buttomZoomOut.value < 400
                          ? new BorderRadius.all(const Radius.circular(30.0))
                          : new BorderRadius.all(const Radius.circular(0.0)),
                    ),
                    child: buttonSqueezeanimation.value > 75.0
                        ? new Text(
                            answer == true ? "True" : "False",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3,
                            ),
                          )
                        : buttomZoomOut.value < 300.0
                            ? new CircularProgressIndicator(
                                value: null,
                                strokeWidth: 1.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                            : null)
                : new Container(
                    width: buttomZoomOut.value,
                    height: buttomZoomOut.value,
                    decoration: new BoxDecoration(
                      shape: buttomZoomOut.value < 500
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      color: const Color.fromRGBO(247, 64, 106, 1.0),
                    ),
                  ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushNamed(context, "Quiz");
      }
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}



