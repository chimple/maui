import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/story/story_list.dart';

class StoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Story'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: StoryList(),
    );
  }
}
