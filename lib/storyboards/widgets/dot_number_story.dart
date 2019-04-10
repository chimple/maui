import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/widgets/dot_number.dart';
import 'package:storyboard/storyboard.dart';

class DotNumberStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: DotNumber(
                number: 7,
                showNumber: true,
              ),
            ),
          ),
        )
      ];
}
