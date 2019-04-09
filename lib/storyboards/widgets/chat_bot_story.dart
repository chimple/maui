import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/widgets/chat_bot.dart';
import 'package:storyboard/storyboard.dart';

class ChatBotStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: ChatBot(
              text: 'Hello. How are you?',
              choices: <String>['Good', 'Bad', 'OK. But not that OK'],
              chatCallback: (text) => print(text),
            ),
          ),
        ),
      ];
}
