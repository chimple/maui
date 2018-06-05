import 'package:flutter/material.dart';
import 'package:maui/screens/chat_bot_screen.dart';
import 'package:maui/state/app_state_container.dart';

class TextChoice extends StatelessWidget {
  Function onSubmit;
  List<String> texts;
  TextChoice({this.onSubmit, this.texts});

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Wrap(
          children: texts
              .map((t) => new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new RaisedButton(
                        onPressed: () => onSubmit(new ChatItem(
                            sender: user.id,
                            chatItemType: ChatItemType.text,
                            content: (t))),
                        child: new Text(t)),
                  ))
              .toList(growable: false)),
    );
  }
}
