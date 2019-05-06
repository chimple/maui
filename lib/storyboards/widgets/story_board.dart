import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/screens/story_screen.dart';
import 'package:maui/widgets/story/activity/text_highlighter.dart';
import 'package:maui/widgets/story/show_dialog_mode.dart';
import 'package:maui/widgets/story/story_page.dart';
import 'package:storyboard/storyboard.dart';

class StoryBoard extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: StoryPage(
              storyId: '24752',
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: StoryScreen(),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: TextHighlighter(
              text:
                  'Look at these beautiful horses and elephants! Who brought them here? squealed Ahilya. Reluctantly, she tore her eyes away from the beautiful animals – it would get dark soon! She hurried inside the temple and lit a lamp. Ahilya closed her eyes and bowed in prayer.',
              onComplete: (_) {},
            ),
          ),
        ),
        Scaffold(
            body: Center(
          child: ShowDialogMode(
            listofWords:
                'Look at these beautiful horses and elephants! Who brought them here? squealed Ahilya. Reluctantly, she tore her eyes away from the beautiful animals – it would get dark soon! She hurried inside the temple and lit a lamp. Ahilya closed her eyes and bowed in prayer.'
                    .split(" "),
          ),
        ))
      ];
}
