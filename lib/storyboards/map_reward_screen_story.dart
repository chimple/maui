import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/map_rewards_screen.dart';
import 'package:storyboard/storyboard.dart';

import 'package:maui/jamaica/models/rewards_data.dart';

class MapRewardsScreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MapRewardScreen(
              rewardList: rewardList,
              items: BuiltMap<String, int>({
                'a': 1,
                'b': 0,
                'c': 1,
                'd': 0,
                'e': 0,
                'f': 1,
                'g': 0,
                'h': 1,
              }),
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: MapRewardScreen(
              rewardList: rewardList,
              items: BuiltMap<String, int>({
                'a': 0,
                'b': 0,
                'c': 0,
                'd': 1,
                'e': 1,
                'f': 1,
                'g': 0,
                'h': 1,
              }),
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: MapRewardScreen(
              rewardList: rewardList,
              items: BuiltMap<String, int>({
                'a': 1,
                'b': 1,
                'c': 1,
                'd': 0,
                'e': 1,
                'f': 1,
                'g': 1,
                'h': 0,
              }),
            ),
          ),
        ),
      ];
}
