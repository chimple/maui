import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

class ThemeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FlareActor(
          themeBackgrounds['school'] ?? 'assets/background_flare/cafe.flr',
          alignment: Alignment.bottomCenter,
          fit: BoxFit.cover,
          animation: 'school'),
    );
  }
}
