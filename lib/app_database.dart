import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:maui/db/entity/user.dart';
import 'package:maui/db/dao/user_dao.dart';
import 'package:maui/db/dao/lesson_dao.dart';
import 'package:maui/db/dao/lesson_unit_dao.dart';
import 'package:maui/db/dao/unit_dao.dart';
import 'package:maui/db/dao/unit_part_dao.dart';
import 'package:maui/repos/game_data.dart';

class AppDatabase {
  static final AppDatabase _appDatabase = new AppDatabase._internal();

  Database _db;
  bool didInit = false;

  factory AppDatabase() {
    return _appDatabase;
  }

  AppDatabase._internal();

  Future<Database> getDb({String path}) async {
    if (!didInit) await _initDatabase(path: path);
    return _db;
  }

  Future _initDatabase({String path}) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "maui.db");
    var dbFile = new File(path);
    if(!await dbFile.exists()) {
      ByteData data = await rootBundle.load(join("assets", "database.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);
      _db = await openDatabase(path, version: 1);

      String imagePath = join(documentsDirectory.path, "chimple_logo.png");
      ByteData imageData = await rootBundle.load(join("assets", "chimple_logo.png"));
      List<int> imageBytes = imageData.buffer.asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);
      await new File(imagePath).writeAsBytes(imageBytes);

      await new UserDao().insert(new User(
        id: '1',
        name: 'Chimple',
        image: imagePath
      ));
      await new UserDao().getUsers().then((u)=>print(u));
    } else {
      _db = await openDatabase(path, version: 1);
    }

    didInit = true;
    new UnitDao().getUnit('a').then((r)=>print(r));
    new LessonDao().getLesson(1).then((r)=>print(r));
    new LessonDao().getLessonBySeq(1).then((r)=>print(r));
    new LessonDao().getLessonsBelowSeqAndByConceptId(100, [3,5]).then((r)=>print(r));
    new LessonUnitDao().getLessonUnitsByLessonId(1).then((r)=>print(r));
    new LessonUnitDao().getLessonUnitsBelowSeqAndByConceptId(100, 3).then((r)=>print(r));
    new LessonUnitDao().getEagerLessonUnitsByLessonId(1).then((r)=>print(r));
    new LessonUnitDao().getEagerLessonUnitsBelowSeqAndByConceptId(100, 3).then((r)=>print(r));
    fetchPairData(1, 16).then((p)=>print(p));
    fetchTrueOrFalse(12).then((t)=>print(t));
    fetchRollingData(13, 5).then((r)=>print(r));
    fetchWordWithBlanksData(13).then((c)=>print(c));
    fetchMathData(15).then((m)=>print(m));
    fetchMathData(16).then((m)=>print(m));
    fetchMathData(17).then((m)=>print(m));
    fetchMathData(18).then((m)=>print(m));
    fetchMathData(19).then((m)=>print(m));
    fetchMathData(20).then((m)=>print(m));
    fetchMathData(21).then((m)=>print(m));
    fetchMathData(22).then((m)=>print(m));
    fetchMathData(23).then((m)=>print(m));
    fetchMathData(24).then((m)=>print(m));
    fetchMathData(25).then((m)=>print(m));
    fetchMathData(26).then((m)=>print(m));
    fetchMathData(27).then((m)=>print(m));
    fetchMathData(28).then((m)=>print(m));
    fetchTablesData(36).then((m)=>print(m));
  }
}
