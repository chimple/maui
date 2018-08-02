import 'dart:async';
import 'package:maui/db/entity/activity.dart';
import 'package:maui/db/dao/activity_dao.dart';

class ActivityRepo {
  static final ActivityDao activityDao = ActivityDao();

  const ActivityRepo();

  Future<Activity> getActivity(String id) async {
    return activityDao.getActivity(id);
  }

  Future<List<Activity>> getActivitiesByTopicId(String topicId) async {
    return await activityDao.getActivitiesByTopicId(topicId);
  }
}
