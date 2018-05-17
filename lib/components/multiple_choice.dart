import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/screens/chat_bot_screen.dart';
import 'package:maui/state/app_state_container.dart';

class MultipleChoice extends StatelessWidget {
  Function onSubmit;
  String answer;
  List<String> choices;
  MultipleChoice({this.answer, this.choices, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    if (answer != null) {
      List<String> displayChoices;
      UnitMode unitMode;
      displayChoices = List.from(choices)
        ..add(answer)
        ..shuffle();
      unitMode = UnitMode.values[new Random().nextInt(3)];
      MediaQueryData media = MediaQuery.of(context);
      final size =
          min(media.size.width, media.size.height) / displayChoices.length;
      var user = AppStateContainer.of(context).state.loggedInUser;

      return new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: displayChoices.map((choice) {
                return new UnitButton(
                  maxHeight: size,
                  maxWidth: size,
                  fontSize: 14.0,
                  text: choice,
                  unitMode: unitMode,
                  onPress: () => onSubmit(new ChatItem(
                      sender: user.id,
                      chatItemType: ChatItemType.text,
                      content: (choice))),
                );
              }).toList(growable: false)));
    }
    return new Container();
  }
}
