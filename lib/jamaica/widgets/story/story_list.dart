import 'dart:convert';
import 'dart:core';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/jamaica/widgets/story/story_card.dart';
import 'package:data/data.dart';

class StoryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoryListState();
  }
}

class StoryListState extends State<StoryList> {
  bool _isLoading = true;
  BuiltList<StoryConfig> _stories;
  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  Future<String> _loadStoryAsset() async {
    return await rootBundle.loadString('assets/stories/story.json');
  }

  Future _loadStory() async {
    print('load data::');
    final standardSerializers =
        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

    final jsonString = await _loadStoryAsset();
    final json = jsonDecode(jsonString);
    Stories s = standardSerializers.deserialize(json);
    setState(() {
      _isLoading = false;
      _stories = s.stories;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        child: Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return new Container(
        color: Colors.orange,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (context, index) {
            return StoryCard(storyConfig: _stories[index]);
          },
          itemCount: _stories.length,
        ),
      );
    }
  }
}
