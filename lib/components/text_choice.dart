import 'package:flutter/material.dart';
import 'package:maui/screens/chat_bot_screen.dart';
import 'package:maui/state/app_state_container.dart';

class TextChoice extends StatefulWidget {
  Function onSubmit;
  TextChoice({this.onSubmit});

  @override
  TextChoiceState createState() {
    return new TextChoiceState();
  }
}

class TextChoiceState extends State<TextChoice> {
  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new Row(
      children: <Widget>[
        new FlatButton(
            onPressed: () => widget.onSubmit(new ChatItem(
                sender: user.id,
                chatItemType: ChatItemType.text,
                content: ('👍'))),
            child: new Text('👍')),
        new FlatButton(
            onPressed: () => widget.onSubmit(new ChatItem(
                sender: user.id,
                chatItemType: ChatItemType.text,
                content: ('👏'))),
            child: new Text('👏')),
        new FlatButton(
            onPressed: () => widget.onSubmit(new ChatItem(
                sender: user.id,
                chatItemType: ChatItemType.text,
                content: ('👌'))),
            child: new Text('👌')),
        new FlatButton(
            onPressed: () => widget.onSubmit(new ChatItem(
                sender: user.id,
                chatItemType: ChatItemType.text,
                content: ('👋'))),
            child: new Text('👋')),
      ],
    );
  }
}
