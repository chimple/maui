import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/chat_bot.dart';
import 'package:storyboard/storyboard.dart';

class BentoBoxStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: BentoBox(
              dragConfig: DragConfig.draggableBounceBack,
              cols: 2,
              rows: 2,
              children: <Widget>[
                Text('A', key: Key('A')),
                Text('B', key: Key('B')),
                Text('C', key: Key('C')),
                Text('D', key: Key('D')),
              ],
            ),
          ),
        ),
      ];
}
