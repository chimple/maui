import 'package:flutter/material.dart';
import 'package:maui/quack/card_detail_wrapper.dart';

class ShowHelp extends StatelessWidget {
  final String topicId;
  const ShowHelp({
    Key key,
    @required this.topicId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      print("Size ${constraints.maxHeight} , ${constraints.maxWidth}");
      return new Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth * 0.89,
        child: new Drawer(
          child: new CardDetailWrapper(
            cardId: topicId,
            showBackButton: false,
          ),
        ),
      );
    });
  }
}
