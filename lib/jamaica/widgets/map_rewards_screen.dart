import 'package:built_collection/built_collection.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/data/rewards_data.dart';
import 'package:maui/jamaica/widgets/show_rewards.dart';

class MapRewardScreen extends StatelessWidget {
  final Map<RewardData, List<RewardCategory>> rewardList;
  final BuiltMap<String, int> items;

  const MapRewardScreen({Key key, this.rewardList, this.items})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: FlareActor(
              'assets/background_flare/background.flr',
              fit: MediaQuery.of(context).orientation == Orientation.portrait
                  ? BoxFit.fitHeight
                  : BoxFit.fitWidth,
              animation: 'bird',
              alignment: Alignment.center,
            ),
          ),
          ShowRewards(rewardList: rewardList, items: items)
        ],
      ),
    );
  }
}
