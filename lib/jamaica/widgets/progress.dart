import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/user_progress_screen.dart';
import 'package:maui/jamaica/state/state_container.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameStatuses =
        StateContainer.of(context).state.userProfile.gameStatuses;
    return UserProgressScreen(gameStatuses: gameStatuses);
  }
}
