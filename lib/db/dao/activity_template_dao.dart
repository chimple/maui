import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:sqflite/sqflite.dart';
import '../entity/activity_template.dart';

class ActivityTemplateDao {
  Future<List<ActivityTemplate>> getActivityTemplatesByActivityId(
      String activityId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(ActivityTemplate.table,
        columns: [
          ActivityTemplate.activityIdCol,
          ActivityTemplate.imageCol,
        ],
        where: '${ActivityTemplate.activityIdCol} = ?',
        whereArgs: [activityId]);

    return maps.map((el) => new ActivityTemplate.fromMap(el)).toList();
  }
}
