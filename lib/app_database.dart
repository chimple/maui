import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:maui/db/dao/unit_dao.dart';
import 'package:maui/db/dao/user_dao.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/db/dao/lesson_dao.dart';
import 'package:maui/db/dao/lesson_unit_dao.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
    if (!await dbFile.exists()) {
      ByteData data = await rootBundle.load(join("assets", "database.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);
      _db = await openDatabase(path, version: 1);

//      String imagePath = join(documentsDirectory.path, "african_child.png");
//      ByteData imageData =
//          await rootBundle.load(join("assets", "african_child.png"));
//      List<int> imageBytes = imageData.buffer
//          .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);
//      await new File(imagePath).writeAsBytes(imageBytes);
//
//      String imagePath1 = join(documentsDirectory.path, "indian_child.png");
//      ByteData imageData1 =
//          await rootBundle.load(join("assets", "indian_child.png"));
//      List<int> imageBytes1 = imageData1.buffer
//          .asUint8List(imageData1.offsetInBytes, imageData1.lengthInBytes);
//      await new File(imagePath1).writeAsBytes(imageBytes1);

      String audioPath = join(documentsDirectory.path, "apple.ogg");
      ByteData audioData = await rootBundle.load(join("assets", "apple.ogg"));
      List<int> audioBytes = audioData.buffer
          .asUint8List(audioData.offsetInBytes, audioData.lengthInBytes);
      await new File(audioPath).writeAsBytes(audioBytes);

//      await new UserDao().insert(new User(
//          id: 'dbb24390-20f0-11e8-c6ee-c11cc1dabc53',
//          name: 'Aiysha',
//          image: imagePath,
//          currentLessonId: 56));
//
//      await new UserDao().insert(new User(
//          id: 'ad851669-e0a9-4bf7-a8d0-2a6b0b166013',
//          name: 'Ramu',
//          image: imagePath1,
//          currentLessonId: 1));

      await new UserDao().getUsers().then((u) => print(u));
    } else {
      _db = await openDatabase(path, version: 1);
    }

    didInit = true;
    new UnitDao().getUnit('a').then((r) => print(r));
    new LessonDao().getLesson(1).then((r) => print(r));
    new LessonDao().getLessonBySeq(1).then((r) => print(r));
    new LessonDao()
        .getLessonsBelowSeqAndByConceptId(100, [3, 5]).then((r) => print(r));
    new LessonUnitDao().getLessonUnitsByLessonId(1).then((r) => print(r));
    new LessonUnitDao()
        .getLessonUnitsBelowSeqAndByConceptId(100, 3)
        .then((r) => print(r));
    new LessonUnitDao().getEagerLessonUnitsByLessonId(1).then((r) => print(r));
    new LessonUnitDao()
        .getEagerLessonUnitsBelowSeqAndByConceptId(100, 3)
        .then((r) => print(r));
    fetchPairData(57, 16).then((p) => print(p));
    fetchTrueOrFalse(56).then((t) => print(t));
    fetchRollingData(56, 5).then((r) => print(r));
    fetchWordWithBlanksData(56).then((c) => print(c));
    fetchMathData(1).then((m) => print(m));
    fetchMathData(2).then((m) => print(m));
    fetchMathData(3).then((m) => print(m));
    fetchMathData(4).then((m) => print(m));
    fetchMathData(5).then((m) => print(m));
    fetchMathData(6).then((m) => print(m));
    fetchMathData(7).then((m) => print(m));
    fetchMathData(8).then((m) => print(m));
    fetchMathData(9).then((m) => print(m));
    fetchMathData(10).then((m) => print(m));
    fetchMathData(11).then((m) => print(m));
    fetchMathData(12).then((m) => print(m));
    fetchMathData(13).then((m) => print(m));
    fetchMathData(14).then((m) => print(m));
    fetchTablesData(21).then((m) => print(m));
    fetchFillNumberData(39, 4).then((f) => print(f));
    fetchCrosswordData(1).then((c) => print(c));
    fetchCirclewrdData(1).then((e) => print(e));

    fetchMultipleChoiceData(1, 3).then((m) => print(m));
    fetchMultipleChoiceData(4, 6).then((m) => print(m));
    fetchMultipleChoiceData(56, 6).then((m) => print(m));
    fetchWordData(56, 10, 3).then((m) => print(m));
    fetchWordData(4, 8, 5).then((m) => print(m));
    fetchConsecutiveData(46, 6, 3)
        .then((d) => print('fetchConsecutiveData: ${d.toString()}'));
    fetchConsecutiveData(47, 12, 4).then((d) => print(d));
    fetchSequenceData(1, 8).then((s) => print(s));
    fetchSequenceData(57, 12).then((s) => print(s));
  }
}
