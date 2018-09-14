import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/activity_progress.dart';
import 'package:sqflite/sqflite.dart';

class ActivityProgressDao {
  const ActivityProgressDao();
  Future<ActivityProgress> getActivityProgressByTopicIdAndActivityIdAndUserId(
      String topicId, String activityId, String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(ActivityProgress.table,
        columns: [
          ActivityProgress.userIdCol,
          ActivityProgress.topicIdCol,
          ActivityProgress.activityIdCol
        ],
        where:
            '''${ActivityProgress.topicIdCol} = ? AND ${ActivityProgress.activityIdCol} = ? AND ${ActivityProgress.userIdCol} = ?''',
        whereArgs: [
          topicId,
          activityId,
          userId
        ]);
    if (maps.length > 0) {
      return ActivityProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<int> getActivityProgressScoreByTopicIdAndUserId(
      String topicId, String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> activitiesAttempted = await db.query(ActivityProgress.table,
        columns: [ActivityProgress.activityIdCol],
        where:
            '''${ActivityProgress.topicIdCol} = ? AND ${ActivityProgress.userIdCol} = ?''',
        whereArgs: [topicId, userId]);

    return activitiesAttempted.length;
  }

  Future<void> insertActivityProgress(ActivityProgress activityProgress,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(ActivityProgress.table, activityProgress.toMap());
  }
}
