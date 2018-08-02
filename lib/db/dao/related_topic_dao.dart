import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/related_topic.dart';
import 'package:maui/db/entity/topic.dart';
import 'package:sqflite/sqflite.dart';

class RelatedTopicDao {
  Future<List<RelatedTopic>> getRelatedTopicsByTopicId(String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(RelatedTopic.table,
        columns: [
          RelatedTopic.topicIdCol,
          RelatedTopic.relTopicIdCol,
        ],
        where:
            '${RelatedTopic.topicIdCol} = ? OR ${RelatedTopic.relTopicIdCol} = ?',
        whereArgs: [topicId, topicId]);
    return maps
        .map((el) => new RelatedTopic.fromMap(el))
        .toList(growable: false);
  }

  Future<List<Topic>> getTopicsByRelatedTopicId(String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps =
        await db.query('${Topic.table} t, ${RelatedTopic.table} r', columns: [
      't.${Topic.idCol}',
      't.${Topic.nameCol}',
      't.${Topic.imageCol}',
      't.${Topic.colorCol}'
    ], where: '''
  (r.${RelatedTopic.relTopicIdCol} = ? AND r.${RelatedTopic.topicIdCol} = t.${Topic.idCol})
  OR
  (r.${RelatedTopic.topicIdCol} = ? AND r.${RelatedTopic.relTopicIdCol} = t.${Topic.idCol})
''', whereArgs: [
      topicId,
      topicId
    ]);
    return maps.map((el) => new Topic.fromMap(el)).toList();
  }
}
