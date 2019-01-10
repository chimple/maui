import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:maui/db/dao/tile_dao.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:uuid/uuid.dart';

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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'loca.dart';

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

      String imagePath = join(documentsDirectory.path, "sister.png");
      ByteData imageData = await rootBundle.load(join("assets", "sister.png"));
      List<int> imageBytes = imageData.buffer
          .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);
      await new File(imagePath).writeAsBytes(imageBytes);

      String imagePath1 = join(documentsDirectory.path, "brother.png");
      ByteData imageData1 =
          await rootBundle.load(join("assets", "brother.png"));
      List<int> imageBytes1 = imageData1.buffer
          .asUint8List(imageData1.offsetInBytes, imageData1.lengthInBytes);
      await new File(imagePath1).writeAsBytes(imageBytes1);

      String imagePath2 = join(documentsDirectory.path, "father.png");
      ByteData imageData2 = await rootBundle.load(join("assets", "father.png"));
      List<int> imageBytes2 = imageData2.buffer
          .asUint8List(imageData2.offsetInBytes, imageData2.lengthInBytes);
      await new File(imagePath2).writeAsBytes(imageBytes2);

      String imagePath3 = join(documentsDirectory.path, "mother.png");
      ByteData imageData3 = await rootBundle.load(join("assets", "mother.png"));
      List<int> imageBytes3 = imageData3.buffer
          .asUint8List(imageData3.offsetInBytes, imageData3.lengthInBytes);
      await new File(imagePath3).writeAsBytes(imageBytes3);

      String imagePath5 = join(documentsDirectory.path, "chat_Bot_Icon.png");
      ByteData imageData5 =
          await rootBundle.load(join("assets", "chat_Bot_Icon.png"));
      List<int> imageBytes5 = imageData5.buffer
          .asUint8List(imageData5.offsetInBytes, imageData5.lengthInBytes);
      await new File(imagePath5).writeAsBytes(imageBytes5);

      String audioPath = join(documentsDirectory.path, "apple.ogg");
      ByteData audioData = await rootBundle.load(join("assets", "apple.ogg"));
      List<int> audioBytes = audioData.buffer
          .asUint8List(audioData.offsetInBytes, audioData.lengthInBytes);
      await new File(audioPath).writeAsBytes(audioBytes);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString('deviceId');

      await new UserDao().insert(new User(
          id: 'sister',
          name: Loca().sister,
          image: imagePath,
          deviceId: deviceId,
          currentLessonId: 56));

      await new UserDao().insert(new User(
          id: 'brother',
          name: Loca().brother,
          image: imagePath1,
          deviceId: deviceId,
          currentLessonId: 1));

      await new UserDao().insert(new User(
          id: 'mother',
          name: Loca().mother,
          image: imagePath3,
          deviceId: deviceId,
          currentLessonId: 1));

      await new UserDao().insert(new User(
          id: 'father',
          name: Loca().father,
          image: imagePath2,
          deviceId: deviceId,
          currentLessonId: 1));

//      await new UserDao().insert(new User(
//          id: 'best_friend',
//          name: 'Best Friend',
//          image: imagePath4,
//          deviceId: 'other_device',
//          currentLessonId: 1));

      await new UserDao().insert(new User(
          id: 'bot',
          name: Loca().friend,
          image: imagePath5,
          deviceId: deviceId,
          currentLessonId: 1));
    } else {
      _db = await openDatabase(path, version: 1);
    }

    didInit = true;
//    new UnitDao().getUnit('a').then((r) => print(r));
//    new LessonDao().getLesson(1).then((r) => print(r));
//    new LessonDao().getLessonBySeq(1).then((r) => print(r));
//    new LessonDao()
//        .getLessonsBelowSeqAndByConceptId(100, [3, 5]).then((r) => print(r));
//    new LessonUnitDao().getLessonUnitsByLessonId(1).then((r) => print(r));
//    new LessonUnitDao()
//        .getLessonUnitsBelowSeqAndByConceptId(100, 3)
//        .then((r) => print(r));
//    new LessonUnitDao().getEagerLessonUnitsByLessonId(1).then((r) => print(r));
//    new LessonUnitDao()
//        .getEagerLessonUnitsBelowSeqAndByConceptId(100, 3)
//        .then((r) => print(r));
//    fetchPairData(57, 16).then((p) => print(p));
//    fetchTrueOrFalse(56).then((t) => print(t));
//    fetchRollingData(56, 5).then((r) => print(r));
//    fetchWordWithBlanksData(56).then((c) => print(c));
//    fetchMathData(1).then((m) => print(m));
//    fetchMathData(2).then((m) => print(m));
//    fetchMathData(3).then((m) => print(m));
//    fetchMathData(4).then((m) => print(m));
//    fetchMathData(5).then((m) => print(m));
//    fetchMathData(6).then((m) => print(m));
//    fetchMathData(7).then((m) => print(m));
//    fetchMathData(8).then((m) => print(m));
//    fetchMathData(9).then((m) => print(m));
//    fetchMathData(10).then((m) => print(m));
//    fetchMathData(11).then((m) => print(m));
//    fetchMathData(12).then((m) => print(m));
//    fetchTablesData(21).then((m) => print(m));
//    fetchFillNumberData(39, 4).then((f) => print(f));
//    fetchCrosswordData(1).then((c) => print(c));
//    fetchCirclewrdData(1).then((e) => print(e));
//
//    fetchMultipleChoiceData(1, 3).then((m) => print(m));
//    fetchMultipleChoiceData(4, 6).then((m) => print(m));
//    fetchMultipleChoiceData(56, 6).then((m) => print(m));
//    fetchWordData(56, 10, 3).then((m) => print(m));
//    fetchWordData(4, 8, 5).then((m) => print(m));
//    fetchConsecutiveData(46, 6, 3)
//        .then((d) => print('fetchConsecutiveData: ${d.toString()}'));
//    fetchConsecutiveData(47, 12, 4).then((d) => print(d));
//    fetchSequenceData(1, 8).then((s) => print(s));
//    fetchSequenceData(57, 12).then((s) => print(s));

    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
  }
}
