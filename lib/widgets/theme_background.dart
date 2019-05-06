import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

class ThemeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FlareActor(
          themeBackgrounds[
                  AppStateContainer.of(context).userProfile.currentTheme] ??
              'assets/background_flare/cafe.flr',
          alignment: Alignment.center,
          fit: BoxFit.cover,
          animation: AppStateContainer.of(context).userProfile.currentTheme),
    );
  }
}
