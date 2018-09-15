import 'dart:async';
import 'package:maui/db/entity/activity_progress.dart';
import 'package:maui/db/dao/activity_progress_dao.dart';
import "package:maui/repos/activity_topic_repo.dart";

class ActivityProgressRepo {
  const ActivityProgressRepo();
  static final ActivityProgressDao activityProgressDao =
      new ActivityProgressDao();

  Future<double> getActivityProgressStatus(
      String topicId, String userId) async {
    print("j bewqg");
    int activitiesAttempted = await activityProgressDao
        .getActivityProgressScoreByTopicIdAndUserId(topicId, userId);
    print(activitiesAttempted);
    print("object");
    int activitiesPresent =
        await ActivityTopicRepo().getTopicActivitiesByTopicId(topicId);
    print(activitiesPresent);
    double activitiesCompleted = (activitiesAttempted / activitiesPresent);
    print(activitiesCompleted);
    print("ngf");
    return activitiesCompleted;
  }

  Future<String> insertActivityProgress(
      String userId, String topicId, String activityId) async {
    ActivityProgress activityProgress = await activityProgressDao
        .getActivityProgressByTopicIdAndActivityIdAndUserId(
      topicId,
      activityId,
      userId,
    );
    if (activityProgress == null) {
      await activityProgressDao.insertActivityProgress(new ActivityProgress(
        topicId: topicId,
        userId: userId,
        activityId: activityId,
      ));
      return "inserted";
    } else {
      print(activityProgress);
      return "already present";
    }
  }
}
