import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';

class QuizPage extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;


  QuizPage({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.gameCategoryId}) : super(key: key);
  
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  bool _isLoading = true;
 
 Tuple2<String, bool> _allques;
  String questionText;
  bool tf;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

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
  }

  void handleAnswer(bool answer) {
    isCorrect = (tf == answer);
    if (isCorrect) {
      widget.onScore(1);
      widget.onProgress(1.0);
    }
    this.setState(() {
      overlayShouldBeVisible = true;
    });
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

    return new Material(
      child: new Stack(
      fit: StackFit.loose,
      children: <Widget>[
        ht > wd ? new Column(
        mainAxisAlignment: MainAxisAlignment.end,       
           children: <Widget>[
             new Column(
               mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[new Column( 
               mainAxisAlignment: MainAxisAlignment.end,
             children: <Widget>[ 
               new Padding(
              padding: new EdgeInsets.all(ht*0.12),
            ),

             new QuestionText(questionText),

              new Padding(
              padding: new EdgeInsets.all(ht*0.08),
            ),
             ]
           ),
              ],
             ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.all(wd * 0.015),
                  ),
                  new AnswerButton(true, () => handleAnswer(true)), //true button
                  new Padding(
                    padding: new EdgeInsets.all(wd * 0.015),
                  ),
                  new AnswerButton(false, () => handleAnswer(false)), 
                  new Padding(
                    padding: new EdgeInsets.all(wd * 0.015),
                  ),// false button
                ],
            ),
            new Padding(
              padding: new EdgeInsets.only(bottom: ht * 0.1),
            ),
          ],
        ) : new Column(
        mainAxisAlignment: MainAxisAlignment.end,       
           children: <Widget>[
             new Column(
               mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[new Column( 
               mainAxisAlignment: MainAxisAlignment.end,
             children: <Widget>[ 
               new Padding(
              padding: new EdgeInsets.all(ht * 0.06),
            ),
               

              new Padding(
              padding: new EdgeInsets.all(ht*0.05),
            ),
             ]
           ),
              ],
             ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.only(left: wd * 0.015),
                  ),
                  new AnswerButton(true, () => handleAnswer(true)), //true button
                  new Padding(
                    padding: new EdgeInsets.only(right: wd * 0.015),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(left: wd * 0.015),
                  ),
                  new AnswerButton(false, () => handleAnswer(false)), 
                  new Padding(
                    padding: new EdgeInsets.only(right: wd * 0.015),
                  ),
                ],
            ),

            new Padding(
              padding: new EdgeInsets.only(bottom: ht * 0.01),
            ),
          ],
        ),


        overlayShouldBeVisible == true ? new Container(
          height: ht,
          width: wd,
          child: new CorrectWrongOverlay(
            isCorrect,
                () {   
                  new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd();
              });
              this.setState(() {
                overlayShouldBeVisible = false;
              });          
            }
        )) : new Container()
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
    _fontSizeAnimation.addListener(() => this.setState(() {}));
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
      child: new Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(25.0),
              color: const Color(0xFF03A9F4),
                ),
                padding: new EdgeInsets.all(20.0),
            child: new Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(25.0),
              color: const Color(0xFF03A9F4),
                ),
                padding: new EdgeInsets.all(20.0),
            child: ht>wd ? new Text( widget._question,
              style: new TextStyle(color: Colors.white, fontSize: 60.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
            ) : new Text( widget._question,
              style: new TextStyle(color: Colors.white, fontSize: 48.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
            ),
          ),
          ),
    );
  }
}

class AnswerButton extends StatelessWidget {

  final bool _answer;
  final VoidCallback _onTap;

  AnswerButton(this._answer, this._onTap);

  @override
  Widget build(BuildContext context) {
    return new Expanded( // true button
      child: new Material(        
        child: new InkWell(
          onTap: () => _onTap(),
          child: new Container(              
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(25.0),
                  color: _answer == true ? const Color(0xFF64DD17) : const Color(0xFFE53935),
                    
                ),
                padding: new EdgeInsets.all(20.0),
                child: new Center(
                  child: new Text(_answer == true ? "True" : "False",
                    style: new TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
                  )
                ),
              ),
        ),
      ),
    );
  }
}



class CorrectWrongOverlay extends StatefulWidget {

  final bool _isCorrect;
  final VoidCallback _onTap;

  CorrectWrongOverlay(this._isCorrect, this._onTap);

  @override
  State createState() => new CorrectWrongOverlayState();
}

class CorrectWrongOverlayState extends State<CorrectWrongOverlay> with SingleTickerProviderStateMixin {

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(duration: new Duration(seconds: 2), vsync: this);
    _iconAnimation = new CurvedAnimation(parent: _iconAnimationController, curve: Curves.elasticOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black54,
      child: new InkWell(
        onTap: () => widget._onTap(),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
              child: new Transform.rotate(
                angle: _iconAnimation.value * 2 * PI,
                child: new Icon(widget._isCorrect == true ? Icons.done : Icons.clear, size: _iconAnimation.value * 80.0,),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(bottom: 20.0),
            ),
            new Text(widget._isCorrect == true ? "Correct!" : "Wrong!", style: new TextStyle(color: Colors.white, fontSize: 30.0),)
          ],
        ),
      ),
    );
  }
}