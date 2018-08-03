import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/trueOrFalse.dart';

class TrueorFalseDao {
  Future <TrueOrFalse> getTrueOrFalseDataByTopicId(String topicId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();

    List<Map> maps = await db.query(TrueOrFalse.table,
    columns: [
      TrueOrFalse.idCol,
      TrueOrFalse.topicIdCol,
      TrueOrFalse.questionCol,
      TrueOrFalse.associatedQuestionCol,
      TrueOrFalse.isTrueCol
    ],
    where: '${TrueOrFalse.topicIdCol} = ?',
    whereArgs: [topicId]);
    if (maps.length > 0) {
      return TrueOrFalse.fromMap(maps.first);
    
    }
   return null;
  }



  Future <List<TrueOrFalse>> getTrueOrFalseDatasbyTopicId(String topicId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();

    List<Map> maps = await db.query(TrueOrFalse.table, 
    columns: [
       TrueOrFalse.idCol,
       TrueOrFalse.topicIdCol,
       TrueOrFalse.questionCol,
       TrueOrFalse.associatedQuestionCol,
       TrueOrFalse.isTrueCol
    ],
    where: '${TrueOrFalse.topicIdCol} = ?',
    whereArgs: [topicId]);

    return maps.map((trueorfalse) => new TrueOrFalse.fromMap(trueorfalse)).toList();
  }
}