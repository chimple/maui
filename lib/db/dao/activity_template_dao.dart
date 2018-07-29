import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:sqflite/sqflite.dart';
import '../entity/activity_template.dart';

class ActivityTemplateDao {
  Future<ActivityTemplate> getTopic(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(ActivityTemplate.table,
        columns: [ActivityTemplate.activityIdCol, ActivityTemplate.imageCol],
        where: '${ActivityTemplate.activityIdCol} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ActivityTemplate.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ActivityTemplate>> getAllTemplates({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      ActivityTemplate.table,
      columns: [
        ActivityTemplate.activityIdCol,
        ActivityTemplate.imageCol,
      ],
    );
    return maps.map((el) => new ActivityTemplate.fromMap(el)).toList();
  }
}
