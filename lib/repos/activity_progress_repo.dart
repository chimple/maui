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
    int activitiesAttempted = await activityProgressDao
        .getActivityProgressScoreByTopicIdAndUserId(topicId, userId);
    int activitiesPresent =
        await ActivityTopicRepo().getTopicActivitiesByTopicId(topicId);
    double activitiesCompleted = (activitiesAttempted / activitiesPresent);
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
    print("nbbb");
    if (activityProgress == null) {
      await activityProgressDao.insertActivityProgress(new ActivityProgress(
        topicId: topicId,
        userId: userId,
        activityId: activityId,
      ));
      return "inserted";
    } else {
      return "already present";
    }

    // else {
    //   if (quizProgress.maxScore < maxScore) {
    //     await activityProgressDao.updateQuizProgress(new QuizProgress(
    //       topicId: topicId,
    //       userId: userId,
    //       quizId: activityId,
    //     ));
    //     return "Current maxScore updated";
    //   } else {
    //     return "Current maxScore is less than or equal to the Previous maxScore";
    //   }
    // }
  }
}
