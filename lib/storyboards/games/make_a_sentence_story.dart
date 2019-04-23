import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/make_a_sentence.dart';
import 'package:storyboard/storyboard.dart';

class MakeASentenceStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MakeASentence(
              words: [
                ['','The boy', 'The Tiger', 'The girl'],
                ['','speaks', 'eat', 'talk'],
                ['','nicely', 'food', 'loud'],
                // ['nicely', 'food', 'loud'],
                // ['nicely', 'food', 'loud']
              ],
            ),
          ),
        ),
      ];
}
