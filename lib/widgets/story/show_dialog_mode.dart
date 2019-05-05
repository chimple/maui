import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ShowDialogMode extends StatefulWidget {
  final List<String> listofWords;
  ShowDialogMode({Key key, this.listofWords}) : super(key: key);

  @override
  ShowDialogModeState createState() => ShowDialogModeState();
}

class ShowDialogModeState extends State<ShowDialogMode> {
  bool highlightOnLongPress = false;
  int highlightIndex = -1;
  FlutterTts flutterTts = new FlutterTts();

  @override
  Widget build(BuildContext context) {
    int index = 0;
    Widget _build(String s, int i) {
      return InkWell(
        onLongPress: () {
          setState(() {
            highlightIndex = i;
          });
          showDialog(
            context: context,
            builder: (context) {
              return FractionallySizedBox(
                  heightFactor:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 0.5
                          : 0.8,
                  widthFactor:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 0.8
                          : 0.4,
                  child: textDescriptionDialog(context, s, 'textDesciption'));
            },
          );
        },
        child: RichText(
          text: TextSpan(
            text: s + " ",
            style: TextStyle(
              fontSize: 23,
              color: highlightIndex == i ? Colors.red : Colors.black,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: ScrollController(),
      child: Wrap(
        children: widget.listofWords.map((s) => _build(s, index++)).toList(),
      ),
    );
  }

  Widget textDescriptionDialog(
      BuildContext context, String text, String textDesciption) {
    text = text.replaceAll(new RegExp(r'[^\w\s]+'), '');
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return new Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.close),
                    iconSize: mediaQuery.size.height * 0.07,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                new IconButton(
                    icon: new Icon(Icons.volume_up),
                    iconSize: mediaQuery.size.height * 0.07,
                    color: Colors.black,
                    onPressed: () {
                      flutterTts.speak(text);
                    }),
              ],
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: mediaQuery.size.height * 0.05, color: Colors.green),
            ),
            Image.asset('assets/stories/images/$text.jpg',
                height: mediaQuery.orientation == Orientation.portrait
                    ? mediaQuery.size.height * 0.2
                    : mediaQuery.size.height * 0.3),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                textDesciption + '$text',
                style: TextStyle(
                    fontSize: mediaQuery.orientation == Orientation.portrait
                        ? mediaQuery.size.height * 0.02
                        : mediaQuery.size.height * 0.03,
                    color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
