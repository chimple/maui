import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/mad_sentence_game.dart';
import 'package:maui/models/sentence_data.dart';
import 'package:storyboard/storyboard.dart';

class MadSentenceGameStory extends FullScreenStory {
  SentenceData sentenceData = SentenceData((s) => s
    ..headers = ListBuilder<String>(['Who', 'How', 'What'])
    ..gameId = 'MadeSentenceGame'
    ..wordWithImages.add(BuiltList<WordWithImage>([
      WordWithImage((w) => w
        ..word = ''
        ..image = ''),
      WordWithImage((w) => w
        ..word = 'The Boy'
        ..image = 'assets/masking/pattern_01.png'),
      WordWithImage((w) => w
        ..word = 'The Tiger'
        ..image = 'assets/masking/pattern_02.png'),
      WordWithImage((w) => w
        ..word = 'The Girl'
        ..image = 'assets/masking/pattern_03.png')
    ]))
    ..wordWithImages.add(BuiltList<WordWithImage>([
      WordWithImage((w) => w
        ..word = ''
        ..image = ''),
      WordWithImage((w) => w
        ..word = 'speaks'
        ..image = 'assets/masking/pattern_04.png'),
      WordWithImage((w) => w
        ..word = 'eat'
        ..image = 'assets/masking/pattern_05.png'),
      WordWithImage((w) => w
        ..word = 'laugh'
        ..image = 'assets/masking/pattern_06.png')
    ]))
    ..wordWithImages.add(BuiltList<WordWithImage>([
      WordWithImage((w) => w
        ..word = ''
        ..image = ''),
      WordWithImage((w) => w
        ..word = 'nicely'
        ..image = 'assets/masking/pattern_20.png'),
      WordWithImage((w) => w
        ..word = 'food'
        ..image = 'assets/masking/pattern_14.png'),
      WordWithImage((w) => w
        ..word = 'loudly'
        ..image = 'assets/masking/pattern_15.png')
    ])));

  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MadSentenceGame(
              sentenceData: sentenceData,
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        )
      ];
}
