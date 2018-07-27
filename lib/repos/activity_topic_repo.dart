import 'dart:async';

import 'package:maui/db/entity/activity_topic.dart';
import 'package:maui/db/dao/activity_topic_dao.dart';

class ActivityTopicRepo {
  static final ActivityTopicDao activityTopicDao = ActivityTopicDao();

  const ActivityTopicRepo();

  Future<ActivityTopic> getActivityTopic(String activityId) async {
    return await activityTopicDao.getActivityTopic(activityId);
  }
}
