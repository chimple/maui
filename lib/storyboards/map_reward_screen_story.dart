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
            ),
          ),
        ),
      ];
}
