import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/audio_widget.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:storyboard/storyboard.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';

class CuteButtonStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CuteButtonWrapper(
                      key: Key('Success Success'),
                      size: Size(128.0, 128.0),
                      child: CuteButton(
                        child: Center(child: Text('Success Success')),
                        reaction: Reaction.success,
                        onPressed: () {
                          print('Success Success Pressed');
                          return Reaction.success;
                        },
                      ),
                    ),
                    CuteButtonWrapper(
                      key: Key('Success Failure'),
                      size: Size(128.0, 128.0),
                      child: CuteButton(
                        child: Center(child: Text('Success Failure')),
                        reaction: Reaction.success,
                        onPressed: () {
                          print('Success Failure Pressed');
                          return Reaction.failure;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CuteButtonWrapper(
                      key: Key('Failure Failure'),
                      size: Size(128.0, 128.0),
                      child: CuteButton(
                        child: Center(child: Text('Failure Failure')),
                        reaction: Reaction.failure,
                        onPressed: () {
                          print('Failure Failure Pressed');
                          return Reaction.failure;
                        },
                      ),
                    ),
                    CuteButtonWrapper(
                      key: Key('Failure Success'),
                      size: Size(128.0, 128.0),
                      child: CuteButton(
                        child: Center(child: Text('Failure Success')),
                        reaction: Reaction.failure,
                        onPressed: () {
                          print('Failure Success Pressed');
                          return Reaction.success;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
              child: Center(
            child: CuteButtonWrapper(
              key: Key('Success'),
              size: Size(128.0, 128.0),
              dragConfig: DragConfig.draggableBounceBack,
              onDragEnd: (d) => print(d),
              child: CuteButton(
                child: Center(child: Text('Success')),
                reaction: Reaction.success,
              ),
            ),
          )),
        )
      ];
}
