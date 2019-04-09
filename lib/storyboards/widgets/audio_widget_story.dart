import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/widgets/audio_widget.dart';
import 'package:storyboard/storyboard.dart';

class AudioWidgetStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: AudioWidget(
              word: '1',
              play: true,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: AudioWidget(
              word: '1',
              play: false,
            ),
          ),
        ),
      ];
}
