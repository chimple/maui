import 'dart:async';
import 'dart:convert';
import 'package:maui/db/entity/drawing.dart';
import 'package:maui/db/dao/drawing_dao.dart';

class DrawingRepo {
  static final DrawingDao drawingDao = DrawingDao();

  const DrawingRepo();

  Future<Drawing> getDrawing(String id) async {
    return drawingDao.getDrawing(id);
  }

  Future<List<Drawing>> getDrawingsByActivityId(String activityId) async {
    return await drawingDao.getDrawingsByActivityId(activityId);
  }

  Future<Drawing> getLatestDrawingByActivityId(String activityId) async {
    return await drawingDao.getLatestDrawingByActivityId(activityId);
  }

  Future<int> delete(int id) async {
    return await drawingDao.delete(id);
  }

  Future<Drawing> upsert(
      {Map<String, dynamic> jsonMap, String activityId, String userId}) async {
    final existingDrawing = await drawingDao.getDrawing(jsonMap['id']);
    String jsonStr = json.encode(jsonMap);
    if (existingDrawing == null) {
      Drawing drawing = Drawing(
          id: jsonMap['id'],
          activityId: activityId,
          json: jsonStr,
          createdAt: DateTime.now(),
          userId: userId,
          updatedAt: DateTime.now());
      print('inserting Drawing: $drawing');
      return await drawingDao.insert(drawing);
    } else {
      existingDrawing.json = jsonStr;
      existingDrawing.updatedAt = DateTime.now();
      print('updating Drawing: $existingDrawing');
      await drawingDao.update(existingDrawing);
      return existingDrawing;
    }
  }
}
