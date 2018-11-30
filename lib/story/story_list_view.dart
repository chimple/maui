import 'package:flutter/material.dart';
import 'package:maui/loca.dart';

class StoryListView extends StatelessWidget {
  const StoryListView({ Key key }) : super(key: key);

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
            new Icon(Icons.book, size: 128.0, color: textStyle.color),
            new Text(Loca.of(context).story, style: textStyle),
          ],
        ),
      ),
    );
  }
}