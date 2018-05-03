import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/screens/chat_bot_screen.dart';
import 'package:maui/state/app_state_container.dart';

class MultipleChoice extends StatefulWidget {
  Function onSubmit;
  String answer;
  List<String> choices;
  MultipleChoice({this.answer, this.choices, this.onSubmit});

  @override
  MultipleChoiceState createState() {
    return new MultipleChoiceState();
  }
}

class MultipleChoiceState extends State<MultipleChoice> {
  List<String> displayChoices;
  UnitMode unitMode;

  @override
  void initState() {
    super.initState();
    displayChoices = List.from(widget.choices)
      ..add(widget.answer)
      ..shuffle();
    unitMode = UnitMode.values[new Random().nextInt(3)];
  }

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;

    return new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: displayChoices.map((choice) {
              return new ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 48.0),
                  child: new UnitButton(
                    text: choice,
                    unitMode: unitMode,
                    onPress: () => widget.onSubmit(new ChatItem(
                        sender: user.id,
                        chatItemType: ChatItemType.text,
                        content: (choice))),
                  ));
            }).toList(growable: false)));
  }
}
