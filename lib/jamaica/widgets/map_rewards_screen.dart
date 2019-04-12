import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/models/rewards_data.dart';
import 'package:maui/jamaica/widgets/show_rewards.dart';

class MapRewardScreen extends StatefulWidget {
  final Map<RewardData, List<RewardCategory>> rewardList;

  const MapRewardScreen({Key key, this.rewardList}) : super(key: key);
  @override
  _MapRewardScreenState createState() => _MapRewardScreenState();
}

class _MapRewardScreenState extends State<MapRewardScreen> {
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
          ShowRewards(
            rewardList: widget.rewardList,
          )
        ],
      ),
    );
  }
}
