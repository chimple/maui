import 'package:meta/meta.dart';
import 'package:maui/db/entity/user.dart';

class AppState {
  User loggedInUser;
  double buttonFontSize;
  double buttonWidth;
  double buttonHeight;
  double buttonRadius;

  AppState({this.loggedInUser});

  @override
  int get hashCode =>
      loggedInUser.hashCode ^
      buttonFontSize.hashCode ^
      buttonWidth.hashCode ^
      buttonHeight.hashCode ^
      buttonRadius.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          loggedInUser == other.loggedInUser &&
          buttonFontSize == other.buttonFontSize &&
          buttonWidth == other.buttonWidth &&
          buttonHeight == other.buttonHeight &&
          buttonRadius == other.buttonRadius;

  @override
  String toString() {
    return 'AppState{loggedInUser: $loggedInUser}';
  }
}
