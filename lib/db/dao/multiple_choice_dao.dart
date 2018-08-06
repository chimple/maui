import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/multiple_choice.dart';
import 'package:sqflite/sqflite.dart';

class MultipleChoiceDao {
  Future<List<MultipleChoice>> getMultipleChoicesByTopicId(String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(MultipleChoice.table,
        columns: [
          MultipleChoice.idCol,
          MultipleChoice.topicIdCol,
          MultipleChoice.questionCol,
          MultipleChoice.answerCol,
          MultipleChoice.choice1Col,
          MultipleChoice.choice2Col,
          MultipleChoice.choice3Col
        ],
        where: '${MultipleChoice.topicIdCol} = ?',
        whereArgs: [topicId]);
    return maps.map((el) => new MultipleChoice.fromMap(el)).toList();
  }
}
