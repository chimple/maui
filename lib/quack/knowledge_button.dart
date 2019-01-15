import 'package:flutter/material.dart';
import 'package:maui/loca.dart';
import 'package:maui/quack/quiz_navigator.dart';

class KnowledgeButton extends StatelessWidget {
  final String cardId;

  KnowledgeButton({key, @required this.cardId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(32.0))),
          color: Color(0xFF0E4476),
          padding: EdgeInsets.all(16.0),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (BuildContext context) {
//                      Provider.dispatch<RootState>(
//                          context,
//                          AddProgress(
//                              cardId: cardList[0].id,
//                              parentCardId: cardId,
//                              index: 1));
              return QuizNavigator(
                cardId: cardId,
              );
            }));
          },
          child: Text(
            Loca.of(context).next,
            style: TextStyle(color: Colors.white, fontSize: 32.0),
          ),
        ));
  }
}
