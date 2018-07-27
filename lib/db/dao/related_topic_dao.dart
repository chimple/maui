import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/related_topic.dart';
import 'package:sqflite/sqflite.dart';

class RelatedTopicDao {
  Future<List<RelatedTopic>> getRelatedTopics(String topicId,
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
}
