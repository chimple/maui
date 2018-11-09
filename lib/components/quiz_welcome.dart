import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';
import 'package:maui/quack/quiz_navigator.dart';

class QuizWelcome extends StatefulWidget {
  final String cardId;

  QuizWelcome({Key key, this.cardId}) : super(key: key);

  @override
  QuizWelcomeState createState() {
    return new QuizWelcomeState();
  }
}

class QuizWelcomeState extends State<QuizWelcome> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: size.height * 0.69,
          width: size.width * 0.9,
          child: new NimaActor(
            "assets/quack",
            alignment: Alignment.center,
            fit: BoxFit.scaleDown,
            animation: 'joy',
            mixSeconds: 0.2,
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(12.0),
              color: Colors.amber,
            ),
            padding: new EdgeInsets.only(
                top: size.height * 0.01, bottom: size.height * 0.01),
            height: size.height * 0.2,
            width: size.width * 0.4,
            child: FlatButton(
              color: Colors.amber,
              child: Text('Quiz', style: new TextStyle(fontSize: size.height > size.width ? size.height * 0.06 : size.height * 0.1, fontWeight: FontWeight.bold,),),
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => QuizNavigator(
                            cardId: widget.cardId,
                          ))),
            ),
          ),
        )
      ],
    );
  }
}
