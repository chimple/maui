import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';

class QuizGrid extends StatelessWidget {
  final List<String> buttonData;

  QuizGrid({Key key, @required this.buttonData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15.0,
      mainAxisSpacing: 20.0,
      shrinkWrap: true,
      padding: EdgeInsets.all(20.0),
      addAutomaticKeepAlives: true,
      children: buttonData
          .map((e) => new QuizButton(text: e))
          .toList(growable: false),
    );
  }
}
