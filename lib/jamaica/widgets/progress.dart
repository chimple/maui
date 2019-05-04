import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/user_progress_screen.dart';
import 'package:maui/state/app_state_container.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameStatuses = AppStateContainer.of(context).userProfile.gameStatuses;
    return UserProgressScreen(gameStatuses: gameStatuses);
  }
}
