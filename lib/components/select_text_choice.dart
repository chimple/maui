import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/screens/chat_screen.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/loca.dart';

class SelectTextChoice extends StatelessWidget {
  final OnUserPress onUserPress;
  List<String> texts;
  String answer;
  SelectTextChoice({this.onUserPress, this.texts, this.answer});

  @override
  Widget build(BuildContext context) {
    List<String> displayChoices = List.from(texts ?? [Loca().hi, Loca().hello]);
    if (answer != null) {
      displayChoices.add(answer);
      displayChoices.shuffle();
    }
    MediaQueryData media = MediaQuery.of(context);
    final size =
        min(media.size.width, media.size.height) / displayChoices.length - 32.0;
    return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Wrap(
          children: displayChoices.map((text) {
            Widget child;
            if (text.startsWith(imagePrefix)) {
              child = UnitButton(
                  maxHeight: size,
                  maxWidth: size,
                  fontSize: 14.0,
                  text: text.substring(3),
                  unitMode: UnitMode.image,
                  onPress: () => onUserPress(text));
            } else if (text.startsWith(audioPrefix)) {
              child = UnitButton(
                  maxHeight: size,
                  maxWidth: size,
                  fontSize: 14.0,
                  text: text.substring(3),
                  unitMode: UnitMode.audio,
                  onPress: () => onUserPress(text));
            } else {
              child = RaisedButton(
                  onPressed: () => onUserPress(text),
                  child: new Text(text, style: TextStyle(fontSize: 24.0)));
            }
            return Padding(padding: const EdgeInsets.all(8.0), child: child);
          }).toList(growable: false),
        ));
  }
}
