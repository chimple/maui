import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/screens/chat_bot_screen.dart';
import 'package:storyboard/storyboard.dart';

class ChatBotScreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [ChatBotScreen()];
}
