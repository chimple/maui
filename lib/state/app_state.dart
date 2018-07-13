import 'package:meta/meta.dart';
import 'package:maui/db/entity/user.dart';

class AppState {
  User loggedInUser;

  AppState({this.loggedInUser});

  @override
  int get hashCode => loggedInUser.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          loggedInUser == other.loggedInUser;

  @override
  String toString() {
    return 'AppState{loggedInUser: $loggedInUser}';
  }
}
