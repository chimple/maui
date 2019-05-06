import 'package:flutter/material.dart';
import 'package:maui/widgets/story/story_list.dart';

class StoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(backgroundColor: Colors.orange, body: StoryList());
  }
}
