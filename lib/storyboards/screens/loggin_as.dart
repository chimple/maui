import 'package:flutter/material.dart';
import 'package:storyboard/storyboard.dart';
import 'package:maui/screens/login_as.dart';


class LoginAsStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: LoginAs(),
          ),
        ),
      ];
}
