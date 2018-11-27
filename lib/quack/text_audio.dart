import 'dart:async';

import 'package:flutter/material.dart';

class TextAudio extends StatefulWidget {
  final String fulltext;
  final String audiofile;
  final int duration;

  TextAudio({this.audiofile, this.fulltext, this.duration});

  @override
  TextAudioState createState() {
    return new TextAudioState();
  }
}

class TextAudioState extends State<TextAudio> {
  List<String> words;
  String start = "", middle = "", end = "";
  int j = 0;

  @override
  void initState() {
    super.initState();
    looper();
  }

  void looper() async {
    int numOfChar = widget.fulltext.length;
    int charTime = (widget.duration ~/ numOfChar);
    words = widget.fulltext.split(" ");
    int loop = words.length;

    for (int i = 0; i < loop; i++) {
      await new Future.delayed(
          Duration(milliseconds: middle.length * charTime));
      setState(() {
        start = start + middle;
        middle = words.removeAt(0) + " ";

        end = "";
        for (String temp in words) {
          end = end + temp + " ";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: Theme.of(context).textTheme.body2,
        children: <TextSpan>[
          new TextSpan(text: start),
          new TextSpan(
              text: middle, style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: end),
        ],
      ),
    );
  }
}
