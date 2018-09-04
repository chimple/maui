import 'dart:async';
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

  Future<int> delete(int id) async {
    return await drawingDao.delete(id);
  }

  Future<int> update(Drawing drawing) async {
    return await drawingDao.update(drawing);
  }
}
