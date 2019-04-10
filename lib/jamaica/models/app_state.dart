library app_state;

import 'package:built_value/built_value.dart';
import 'package:data/models/user_profile.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  bool get isLoading;
  UserProfile get userProfile;

  AppState._();
  factory AppState([updates(AppStateBuilder b)]) = _$AppState;

  factory AppState.loading() => AppState((b) => b..isLoading = true);
}
