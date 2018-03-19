import 'package:flutter/material.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Card(
      color: Colors.white,
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.chat, size: 128.0, color: textStyle.color),
            new Text('Chat', style: textStyle),
          ],
        ),
      ),
    );
  }
}