import 'package:flutter/material.dart';
import 'package:maui/components/QuizButton.dart';

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
      children: new List.generate(buttonData.length, (i) {
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new QuizButton(text: " ${buttonData[i]}"),
        );
      }),
    );
  }
}
