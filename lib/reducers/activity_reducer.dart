import 'package:maui/actions/activity_actions.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/user_activity.dart';
import 'package:redux/redux.dart';

final activityReducer = combineReducers<Map<String, UserActivity>>([
  TypedReducer<Map<String, UserActivity>, ActivitiesLoadedAction>(
      _setLoadedActivities),
  TypedReducer<Map<String, UserActivity>, AddLikeAction>(_setLikeAdd),
  TypedReducer<Map<String, UserActivity>, AddProgressAction>(_setProgressAdd),
]);

Map<String, UserActivity> _setLoadedActivities(
    Map<String, UserActivity> activities, ActivitiesLoadedAction action) {
  return action.activityMap;
}

Map<String, UserActivity> _setLikeAdd(
    Map<String, UserActivity> activities, AddLikeAction action) {
  if (action.userId == null) {
    activities.update(action.parentId, (u) => u..like = true,
        ifAbsent: () => UserActivity()..like = true);
  }
  return activities;
}

Map<String, UserActivity> _setProgressAdd(
    Map<String, UserActivity> activities, AddProgressAction action) {
  activities.update(
      action.parentCardId,
      (u) => u
        ..done = action.done
        ..total = action.total,
      ifAbsent: () => UserActivity()
        ..done = action.done
        ..total = action.total);
  return activities;
}
